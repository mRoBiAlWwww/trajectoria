import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { GoogleGenerativeAI } from "@google/generative-ai";
import axios from "axios";

admin.initializeApp();
const db = admin.firestore();

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

interface InsightAIResult {
  summary: string[];
  common_pattern: string[];
  strengths: string[];
  weaknesses: string[];
  improvement_suggestion: string;
  career_match_recommendation: string;
}

interface AnalyzeSubmissionData {
  submissionId: string;
  problemStatement: string;
  fileUrls: string[];
}

interface SendFcmData {
  targetToken: string;
  competitionName: string;
  competitionId: string;
  submissionId: string;
  announcementId: string;
}

interface CloseCompetitionData {
  competitionId: string;
  competitionName: string;
  companyName: string;
  topN?: number;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function extractList(value: unknown): string[] {
  if (!Array.isArray(value)) return [];
  return value.map((item) => {
    if (typeof item === "string") return item;
    if (typeof item === "object" && item !== null && "deskripsi" in item) {
      return String((item as Record<string, unknown>)["deskripsi"]);
    }
    return String(item);
  });
}

function parseInsightAI(responseText: string): InsightAIResult {
  const cleaned = responseText
    .replace(/```json\s*/gi, "")
    .replace(/```\s*/gi, "")
    .trim();

  const start = cleaned.indexOf("{");
  const end = cleaned.lastIndexOf("}");
  if (start === -1 || end === -1) {
    throw new Error("No JSON object found in Gemini response");
  }

  const parsed = JSON.parse(cleaned.slice(start, end + 1)) as Record<string, unknown>;

  return {
    summary: extractList(parsed["summary"]),
    common_pattern: extractList(parsed["common_pattern"]),
    strengths: extractList(parsed["strengths"]),
    weaknesses: extractList(parsed["weaknesses"]),
    improvement_suggestion:
      typeof parsed["improvement_suggestion"] === "string"
        ? parsed["improvement_suggestion"]
        : "",
    career_match_recommendation:
      typeof parsed["career_match_recommendation"] === "string"
        ? parsed["career_match_recommendation"]
        : "",
  };
}

// ---------------------------------------------------------------------------
// Shared: recalculate standard competition ranks for all checked submissions
// ---------------------------------------------------------------------------

async function calculateAndUpdateRanks(competitionId: string): Promise<void> {
  const snapshot = await db
    .collection("Submissions")
    .where("competition_id", "==", competitionId)
    .where("is_checked", "==", true)
    .orderBy("score", "desc")
    .get();

  if (snapshot.empty) return;

  const batch = db.batch();
  let rank = 1;
  let prevScore: number | null = null;

  snapshot.docs.forEach((doc, i) => {
    const score = Number(doc.data()["score"] ?? 0);
    if (prevScore !== null && score < prevScore) {
      rank = i + 1;
    }
    prevScore = score;
    batch.update(doc.ref, { rank });
  });

  await batch.commit();
}

// ---------------------------------------------------------------------------
// analyzeSubmission — HTTPS Callable (v1)
// ---------------------------------------------------------------------------

export const analyzeSubmission = functions.https.onCall(
  async (data: AnalyzeSubmissionData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const { submissionId, problemStatement, fileUrls } = data;

    if (!submissionId || !problemStatement || !fileUrls?.length) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "submissionId, problemStatement, and fileUrls are required"
      );
    }

    const geminiApiKey = process.env.GEMINI_API_KEY;
    if (!geminiApiKey) {
      throw new functions.https.HttpsError(
        "internal",
        "Gemini API key not configured"
      );
    }

    const genAI = new GoogleGenerativeAI(geminiApiKey);
    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash-lite" });

    const combined: InsightAIResult = {
      summary: [],
      common_pattern: [],
      strengths: [],
      weaknesses: [],
      improvement_suggestion: "",
      career_match_recommendation: "",
    };

    for (const fileUrl of fileUrls) {
      const fileResponse = await axios.get<ArrayBuffer>(fileUrl, {
        responseType: "arraybuffer",
      });
      const fileBytes = Buffer.from(fileResponse.data);
      const mimeType = fileUrl.endsWith(".pdf") ? "application/pdf" : "image/jpeg";

      const prompt = `Analisa file submission kompetisi ini berdasarkan problem statement berikut:
"${problemStatement}"

Berikan hasil analisis dalam format JSON murni (tanpa markdown, tanpa kode block) sebagai berikut:
{
  "summary": [{"deskripsi": "ringkasan poin 1"}, {"deskripsi": "ringkasan poin 2"}, ...],
  "common_pattern": [{"deskripsi": "problem-solution fit poin 1"}, ...],
  "strengths": [{"deskripsi": "kelebihan teknis 1"}, ...],
  "weaknesses": [{"deskripsi": "kelemahan teknis 1"}, ...],
  "improvement_suggestion": "saran perbaikan dalam satu paragraf",
  "career_match_recommendation": "rekomendasi karir yang sesuai dalam satu paragraf"
}

Aturan:
- summary: 5 poin ringkasan insight utama dari submission
- common_pattern: 5 poin analisis kecocokan solusi terhadap problem statement
- strengths: 3-5 kelebihan teknis yang menonjol dari submission
- weaknesses: 3-5 kelemahan atau area yang perlu ditingkatkan
- improvement_suggestion: saran konkret untuk meningkatkan kualitas submission (1 paragraf)
- career_match_recommendation: rekomendasi role/jalur karir yang cocok berdasarkan skills yang terlihat (1 paragraf)
- Setiap poin hanya satu kalimat singkat
- Gunakan bahasa Indonesia
- Berikan HANYA JSON, tanpa teks pembuka, penutup, atau markdown`;

      const result = await model.generateContent([
        { text: prompt },
        { inlineData: { mimeType, data: fileBytes.toString("base64") } },
      ]);

      const parsed = parseInsightAI(result.response.text());

      combined.summary.push(...parsed.summary);
      combined.common_pattern.push(...parsed.common_pattern);
      combined.strengths.push(...parsed.strengths);
      combined.weaknesses.push(...parsed.weaknesses);
      if (!combined.improvement_suggestion && parsed.improvement_suggestion) {
        combined.improvement_suggestion = parsed.improvement_suggestion;
      }
      if (!combined.career_match_recommendation && parsed.career_match_recommendation) {
        combined.career_match_recommendation = parsed.career_match_recommendation;
      }
    }

    const finalResult: InsightAIResult = {
      summary: combined.summary.slice(0, 5),
      common_pattern: combined.common_pattern.slice(0, 5),
      strengths: combined.strengths.slice(0, 5),
      weaknesses: combined.weaknesses.slice(0, 5),
      improvement_suggestion: combined.improvement_suggestion,
      career_match_recommendation: combined.career_match_recommendation,
    };

    await db
      .collection("Submissions")
      .doc(submissionId)
      .set({ ai_analyzed: finalResult }, { merge: true });

    return finalResult;
  }
);

// ---------------------------------------------------------------------------
// sendFcmNotification — HTTPS Callable (v1)
// ---------------------------------------------------------------------------

export const sendFcmNotification = functions.https.onCall(
  async (data: SendFcmData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const { targetToken, competitionName, competitionId, submissionId, announcementId } = data;

    if (!targetToken || !competitionName || !competitionId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "targetToken, competitionName, and competitionId are required"
      );
    }

    const messageBody = `Halo, ada pengumuman nih dari kompetisi ${competitionName}.`;

    const message: admin.messaging.Message = {
      token: targetToken,
      notification: { title: "Update Lamaran", body: messageBody },
      data: {
        type: "report_submission",
        competition_id: competitionId,
        submission_id: submissionId ?? "",
        announcement_id: announcementId ?? "",
        full_body: messageBody,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "high_importance_channel",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
          icon: "ic_launcher",
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      return { messageId: response };
    } catch (error) {
      const err = error as { message?: string };
      throw new functions.https.HttpsError(
        "internal",
        `FCM send failed: ${err.message ?? String(error)}`
      );
    }
  }
);

// ---------------------------------------------------------------------------
// closeCompetition — HTTPS Callable (v1)
// ---------------------------------------------------------------------------

export const closeCompetition = functions.https.onCall(
  async (data: CloseCompetitionData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const { competitionId, competitionName, companyName, topN = 10 } = data;

    if (!competitionId || !competitionName || !companyName) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "competitionId, competitionName, and companyName are required"
      );
    }

    // Verify caller owns this competition
    const compDoc = await db.collection("Competitions").doc(competitionId).get();
    if (!compDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Competition not found");
    }
    if (compDoc.data()?.["company_id"] !== context.auth.uid) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only the owning company may close this competition"
      );
    }

    // 1. Mark as Closed
    await db.collection("Competitions").doc(competitionId).update({ status: "Closed" });

    // 2. Recalculate final ranks
    await calculateAndUpdateRanks(competitionId);

    // 3. Fetch top-N checked submissions
    const snapshot = await db
      .collection("Submissions")
      .where("competition_id", "==", competitionId)
      .where("is_checked", "==", true)
      .orderBy("score", "desc")
      .limit(topN)
      .get();

    if (snapshot.empty) return { competitionId };

    // 4. Issue certificates (skip duplicates)
    const batch = db.batch();

    for (let i = 0; i < snapshot.docs.length; i++) {
      const subData = snapshot.docs[i].data();
      const rank: number = (subData["rank"] as number | undefined) ?? i + 1;
      const userId: string = (subData["user_id"] as string | undefined) ?? "";
      const submissionId: string =
        (subData["submissions_id"] as string | undefined) ?? snapshot.docs[i].id;

      if (!userId) continue;

      const existing = await db
        .collection("Certificates")
        .where("competition_id", "==", competitionId)
        .where("user_id", "==", userId)
        .limit(1)
        .get();

      if (!existing.empty) continue;

      const certRef = db.collection("Certificates").doc();
      batch.set(certRef, {
        certificate_id: certRef.id,
        competition_id: competitionId,
        user_id: userId,
        competition_name: competitionName,
        company_name: companyName,
        rank,
        top_n: topN,
        issued_at: admin.firestore.Timestamp.now(),
        submission_id: submissionId,
      });
    }

    await batch.commit();
    return { competitionId };
  }
);
