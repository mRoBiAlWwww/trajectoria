import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:trajectoria/common/helper/parser/capitalize.dart';
import 'package:trajectoria/common/helper/parser/parse_sumary.dart' show parseInsightAI;
import 'package:trajectoria/core/config/env/env.dart';
import 'package:trajectoria/features/company/dashboard/data/models/announcement.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/certificate.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/certificate.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/insightAI.dart';

abstract class CompetitionOrganizerService {
  Future<String> createCompetition(CompetitionModel newCompetition);
  Future<String> draftCompetition(CompetitionModel newCompetition);
  Future<List<Map<String, dynamic>>> getDraftCompetitions();
  Future<List<Map<String, dynamic>>> getCompetitionsByCurrentCompany();
  Future<Map<String, dynamic>> getCompetitionById(String competitionId);
  Future<String> deleteCompetitionById(String competitionId);
  Future<String> deleteCompetitionParticipantsByCompetitionId(
    String competitionId,
  );
  Future<String> deleteSubmissionsByCompetitionId(String competitionId);
  Future<List<Map<String, dynamic>>> getCompetitionsByTitle(String keyword);
  Future<List<Map<String, dynamic>>> getJobseekerSubmissions(
    String competitionId,
    String show,
  );
  Future<InsightAIEntity> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  });
  Future<String> finalAssessment(
    int totalScore,
    String feedback,
    String submissionId,
    AnnouncementModel announcement,
  );
  Future<String> addToFinalis(
    SubmissionModel finalis,
    String name,
    String imageUrl,
  );
  Future<List<Map<String, dynamic>>> getFinalis(String competitionId);
  Future<String> deleteFinalis(String finalisId);
  Future<List<Map<String, dynamic>>> getJobseekerSubmissionsIncrement(
    String competitionId,
  );
  Future<List<Map<String, dynamic>>> getAcrossJobseekerSubmissions();
  Future<Map<String, dynamic>> getSubmissionById(String submissionId);
  Future<Map<String, dynamic>> getCompetitionParticipants(
    String competitionParticipantId,
  );
  Future<Map<String, dynamic>> getUserInformationById(String userId);
  Future<Map<String, dynamic>> getCurrentCompanyInformation();
  Future<List<Map<String, dynamic>>> getJobseekerByName(String jobsName);
  Future<List<Map<String, dynamic>>> getCompetitionParticipantsByUserId(
    String userId,
  );
  Future<Map<String, dynamic>?> getJobseekerSubmissionsByPartisipantId(
    String partisipanId,
  );
  Future<String> closeCompetition(
    String competitionId,
    String competitionName,
    String companyName, {
    int topN = 10,
  });
  Future<List<CertificateEntity>> getMyCertificates();
  Future<String> exportSubmissionsToCsv(String competitionId);
}

class CompetitionOrganizerServiceImpl extends CompetitionOrganizerService {
  @override
  Future<String> createCompetition(CompetitionModel newCompetition) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    final String capitalizedKeyword = capitalizeWords(newCompetition.title);
    try {
      if (newCompetition.competitionId.isEmpty) {
        final competitionId = firestoreInstance
            .collection("Competitions")
            .doc()
            .id;

        final updatedEntity = newCompetition.copyWith(
          competitionId: competitionId,
          companyId: currentUser!.uid,
          title: capitalizedKeyword,
          status: "Dirilis",
        );
        await firestoreInstance
            .collection("Competitions")
            .doc(competitionId)
            .set(updatedEntity.toMap());
        return competitionId;
      } else {
        await firestoreInstance
            .collection("Competitions")
            .doc(newCompetition.competitionId)
            .set(newCompetition.toMap());
        return newCompetition.competitionId;
      }
    } catch (e) {
      throw Exception("Error Gagal membuat kompetisi: $e");
    }
  }

  @override
  Future<String> draftCompetition(CompetitionModel newCompetition) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      final competitionId = firestoreInstance
          .collection("Draft_competitions")
          .doc()
          .id;

      final updatedEntity = newCompetition.copyWith(
        competitionId: competitionId,
        companyId: currentUser!.uid,
      );
      await firestoreInstance
          .collection("Draft_competitions")
          .doc(competitionId)
          .set(updatedEntity.toMap());
      return competitionId;
    } catch (e) {
      throw Exception("Error Gagal membuat draft kompetisi: $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDraftCompetitions() async {
    final firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      var drafts = await firestoreInstance
          .collection("Draft_competitions")
          .where("company_id", isEqualTo: currentUser!.uid)
          .get();
      return drafts.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error Gagal mengambil daftar draft kompetisi: $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetitionsByCurrentCompany() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      var competitions = await firestoreInstance
          .collection("Competitions")
          .where("company_id", isEqualTo: currentUser!.uid)
          .get();

      return competitions.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error Gagal mengambil daftar kompetisi: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCompetitionById(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var competitions = await firestoreInstance
          .collection("Competitions")
          .where("competition_id", isEqualTo: competitionId)
          .limit(1)
          .get();

      return competitions.docs.first.data();
    } catch (e) {
      throw Exception("Error Gagal mengambil kompetisi berdasarkan ID: $e");
    }
  }

  @override
  Future<String> deleteCompetitionById(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance
          .collection("Competitions")
          .doc(competitionId)
          .delete();

      return "Kompetisi berhasil dihapus";
    } catch (e) {
      throw Exception("Error Gagal menghapus kompetisi: $e");
    }
  }

  @override
  Future<String> deleteCompetitionParticipantsByCompetitionId(
    String competitionId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestoreInstance
          .collection("Competition_participants")
          .where("competition_id", isEqualTo: competitionId)
          .get();

      WriteBatch batch = firestoreInstance.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      return "Competition partisipan dari kompetisi yang bersangkutan berhasil dihapus";
    } catch (e) {
      throw Exception(
        "Error Gagal menghapus partisipan dari kompetisi yang bersangkutan: $e",
      );
    }
  }

  @override
  Future<String> deleteSubmissionsByCompetitionId(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestoreInstance
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId)
          .get();

      WriteBatch batch = firestoreInstance.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return "Submission dari kompetisi yang bersangkutan berhasil dihapus";
    } catch (e) {
      throw Exception("Error Gagal menghapus kompetisi: $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetitionsByTitle(
    String keyword,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    final String capitalizedKeyword = capitalizeWords(keyword);

    if (capitalizedKeyword.isEmpty) {
      debugPrint("Keyword kosong, mengembalikan list kosong");
      return [];
    }
    try {
      final competitions = await firestoreInstance
          .collection("Competitions")
          .where("company_id", isEqualTo: currentUser!.uid)
          .orderBy("title")
          .startAt([capitalizedKeyword])
          .endAt(["$capitalizedKeyword\uf8ff"])
          .get();

      return competitions.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception(
        "Error Gagal mengambil daftar kompetisi berdasarkan title: $e",
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getJobseekerSubmissions(
    String competitionId,
    String show,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      Query query = firestoreInstance
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId);

      if (show == "newest") {
        query = query.orderBy('submitted_at', descending: true);
      } else if (show == "latest") {
        query = query.orderBy('submitted_at', descending: false);
      } else if (show == "notChecked") {
        query = query.where("is_checked", isEqualTo: false);
      }

      final submissions = await query.get();
      return submissions.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        // Pastikan submissions_id selalu = Firestore document ID
        return <String, dynamic>{...data, 'submissions_id': e.id};
      }).toList();
    } catch (e) {
      throw Exception(
        "Error Gagal mengambil daftar submission dari jobseeker: $e",
      );
    }
  }

  @override
  Future<InsightAIEntity> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  }) async {
    final GenerativeModel geminiModel = GenerativeModel(
      apiKey: Env.geminiApiKey,
      model: "gemini-2.5-flash-lite",
    );
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    List<String> combinedSummary = [];
    List<String> combinedCommonPattern = [];
    List<String> combinedStrengths = [];
    List<String> combinedWeaknesses = [];
    String improvementSuggestion = '';
    String careerMatchRecommendation = '';

    if (fileUrls.isEmpty) {
      throw Exception("Tidak ada file untuk dianalisis");
    }

    try {
      for (final fileUrl in fileUrls) {
        final response = await http.get(Uri.parse(fileUrl));
        if (response.statusCode != 200) {
          throw Exception("Gagal download file (${response.statusCode}): $fileUrl");
        }
        final Uint8List fileBytes = response.bodyBytes;
        // Firebase Storage URLs contain ?alt=media&token=... so we must decode
        // the path portion to find the actual file extension.
        final decodedPath = Uri.decodeFull(Uri.parse(fileUrl).path).toLowerCase();
        final mimeType = decodedPath.endsWith('.pdf')
            ? "application/pdf"
            : decodedPath.endsWith('.png')
                ? "image/png"
                : "image/jpeg";

        final prompt = """
Analisa file submission kompetisi ini berdasarkan problem statement berikut:
"$problemStatement"

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
- Berikan HANYA JSON, tanpa teks pembuka, penutup, atau markdown
""";

        final content = Content.multi([
          TextPart(prompt),
          DataPart(mimeType, fileBytes),
        ]);

        final geminiResponse = await geminiModel.generateContent([content]);
        final InsightAIModel result = parseInsightAI(geminiResponse.text ?? "");

        combinedSummary.addAll(result.summary);
        combinedCommonPattern.addAll(result.commonPattern);
        combinedStrengths.addAll(result.strengths);
        combinedWeaknesses.addAll(result.weaknesses);
        if (improvementSuggestion.isEmpty && result.improvementSuggestion.isNotEmpty) {
          improvementSuggestion = result.improvementSuggestion;
        }
        if (careerMatchRecommendation.isEmpty && result.careerMatchRecommendation.isNotEmpty) {
          careerMatchRecommendation = result.careerMatchRecommendation;
        }
      }

      final finalModel = InsightAIModel(
        summary: combinedSummary.take(5).toList(),
        commonPattern: combinedCommonPattern.take(5).toList(),
        strengths: combinedStrengths.take(5).toList(),
        weaknesses: combinedWeaknesses.take(5).toList(),
        improvementSuggestion: improvementSuggestion,
        careerMatchRecommendation: careerMatchRecommendation,
      );

      // Save to Firestore is non-fatal: UI still gets the result even if save fails
      if (submissionId.isNotEmpty) {
        try {
          await firestoreInstance
              .collection("Submissions")
              .doc(submissionId)
              .set({"ai_analyzed": finalModel.toMap()}, SetOptions(merge: true));
        } catch (_) {
          // Ignore save error — analysis result is still returned to UI
        }
      }

      return finalModel.toEntity();
    } catch (e) {
      throw Exception("Error Analisa Gagal: $e");
    }
  }

  @override
  Future<String> finalAssessment(
    int totalScore,
    String feedback,
    String submissionId,
    AnnouncementModel announcement,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      //Announcement
      final announcementId = firestoreInstance
          .collection("Announcement")
          .doc()
          .id;

      final updatedEntity = announcement.copyWith(
        announcementId: announcementId,
      );
      await firestoreInstance
          .collection("Announcement")
          .doc(announcementId)
          .set(updatedEntity.toMap());

      //Score, feedback & ischecked
      await firestoreInstance.collection("Submissions").doc(submissionId).set({
        "score": totalScore,
        "feedback": feedback,
        "is_checked": true,
      }, SetOptions(merge: true));

      // Auto-recalculate ranks for all checked submissions in this competition
      await _calculateAndUpdateRanks(
        firestoreInstance,
        announcement.competitionId,
      );

      return announcementId;
    } catch (e) {
      throw Exception("Error score tidak berhasil ditambahkan $e");
    }
  }

  /// Recalculates and writes rank for every checked submission in a competition.
  /// Uses standard competition ranking: tied scores get the same rank,
  /// and the next rank skips by the count of tied entries (1, 2, 2, 4).
  Future<void> _calculateAndUpdateRanks(
    FirebaseFirestore firestore,
    String competitionId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId)
          .where("is_checked", isEqualTo: true)
          .orderBy("score", descending: true)
          .get();

      if (snapshot.docs.isEmpty) return;

      final WriteBatch batch = firestore.batch();
      int rank = 1;
      double? prevScore;

      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final double score = (doc.data()['score'] is int)
            ? (doc.data()['score'] as int).toDouble()
            : (doc.data()['score'] ?? 0.0);

        if (prevScore != null && score < prevScore) {
          rank = i + 1;
        }
        prevScore = score;
        batch.update(doc.reference, {'rank': rank});
      }

      await batch.commit();
    } catch (e) {
      // Non-critical: ranking failure should not block the scoring flow
      debugPrint("Auto-ranking failed: $e");
    }
  }

  @override
  Future<String> addToFinalis(
    SubmissionModel finalis,
    String name,
    String imageUrl,
  ) async {
    final firestoreInstance = FirebaseFirestore.instance;

    try {
      final alreadyInFinal = await FirebaseFirestore.instance
          .collection("Submissions")
          .where("submissions_id", isEqualTo: finalis.submissionId)
          .where("is_finalist", isEqualTo: true)
          .get();

      if (alreadyInFinal.docs.isNotEmpty) {
        return "Partisipan ini sudah ada di final";
      }
      await firestoreInstance
          .collection("Submissions")
          .doc(finalis.submissionId)
          .set({"is_finalist": true}, SetOptions(merge: true));

      return "Status finalist telah berhasil diperbarui";
    } catch (e) {
      throw Exception("Error partisipan gagal ditambahkan ke finalis $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFinalis(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var finalis = await firestoreInstance
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId)
          .where("is_finalist", isEqualTo: true)
          .get();
      return finalis.docs.map((e) {
        final data = e.data();
        return <String, dynamic>{...data, 'submissions_id': e.id};
      }).toList();
    } catch (e) {
      throw Exception(
        "Error gagal mendapatkan partisipan finalist kompetisi $e",
      );
    }
  }

  @override
  Future<String> deleteFinalis(String submissionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance.collection("Submissions").doc(submissionId).set({
        "is_finalist": false,
      }, SetOptions(merge: true));
      return "Partisipan telah berhasil dihapus dari daftar finalis";
    } catch (e) {
      throw Exception(
        "Error gagal menghapus partisipan dari daftar finalis $e",
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getJobseekerSubmissionsIncrement(
    String competitionId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      final submissions = await firestoreInstance
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId)
          .orderBy("score", descending: true)
          .get();

      return submissions.docs.map((e) {
        final data = e.data();
        return <String, dynamic>{...data, 'submissions_id': e.id};
      }).toList();
    } catch (e) {
      throw Exception(
        "Error gagal mendapatkan list peringkat dari submissions $e",
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAcrossJobseekerSubmissions() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    try {
      final uid = currentUser!.uid;

      final competitionsSnap = await firestoreInstance
          .collection("Competitions")
          .where("company_id", isEqualTo: uid)
          .get();

      final compIds = competitionsSnap.docs.map((e) => e.id).toList();

      if (compIds.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> allSubs = [];

      for (var i = 0; i < compIds.length; i += 10) {
        final chunk = compIds.sublist(
          i,
          (i + 10 > compIds.length) ? compIds.length : i + 10,
        );

        final subSnap = await firestoreInstance
            .collection("Submissions")
            .where("competition_id", whereIn: chunk)
            .get();

        allSubs.addAll(subSnap.docs.map((e) {
          final data = e.data();
          return <String, dynamic>{...data, 'submissions_id': e.id};
        }).toList());
      }

      return allSubs;
    } catch (e) {
      throw Exception("Error coba lagi $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getSubmissionById(String submissionId) async {
    final firestoreInstance = FirebaseFirestore.instance;

    try {
      final submissionDoc = await firestoreInstance
          .collection("Submissions")
          .doc(submissionId)
          .get();

      if (!submissionDoc.exists) {
        throw Exception("Submission dengan ID '$submissionId' tidak ditemukan");
      }
      final data = submissionDoc.data()!;
      return <String, dynamic>{...data, 'submissions_id': submissionDoc.id};
    } catch (e) {
      throw Exception(
        "Error gagal mendapatkan submission dengan ID yang ada $e",
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getCompetitionParticipants(
    String competitionParticipantId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCompetitionParticipants = await firestoreInstance
          .collection("Competition_participants")
          .doc(competitionParticipantId)
          .get();

      return getCompetitionParticipants.data()!;
    } catch (e) {
      throw Exception(
        "Error gagal mendapatkan partisipan kompetisi dari ID yang ada $e",
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getUserInformationById(String userId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getUserInformation = await firestoreInstance
          .collection("Jobseeker")
          .doc(userId)
          .get();
      return getUserInformation.data()!;
    } catch (e) {
      throw Exception(
        "Error gagal mendapatkan informasi jobseeker yang sedang mengikuti kompetisi $e",
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentCompanyInformation() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getUserInformation = await firestoreInstance
          .collection("Company")
          .doc(currentUser!.uid)
          .get();

      return getUserInformation.data()!;
    } catch (e) {
      throw Exception("Error gagal mendapatkan informasi company anda $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getJobseekerByName(String jobsName) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final String capitalizedKeyword = capitalizeWords(jobsName);

    if (capitalizedKeyword.isEmpty) {
      debugPrint("Nama kosong, mengembalikan user kosong");
      return [];
    }
    try {
      final user = await firestoreInstance
          .collection("Jobseeker")
          .orderBy("name")
          .startAt([capitalizedKeyword])
          .endAt(["$capitalizedKeyword\uf8ff"])
          .get();

      return user.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error Gagal mengambil user berdasarkan nama: $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetitionParticipantsByUserId(
    String userId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      final participants = await firestoreInstance
          .collection("Competition_participants")
          .where("user_id", isEqualTo: userId)
          .get();

      return participants.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception(
        "Error Gagal mengambil partisipan kompetisi berdasarkan user id: $e",
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getJobseekerSubmissionsByPartisipantId(
    String partisipanId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      final competitions = await firestoreInstance
          .collection("Submissions")
          .where("competition_participants_id", isEqualTo: partisipanId)
          .get();

      if (competitions.docs.isEmpty) {
        return null;
      }

      return competitions.docs.first.data();
    } catch (e) {
      throw Exception(
        "Error Gagal mengambil daftar submission berdasarkan partisipan id: $e",
      );
    }
  }

  /// Closes a competition and issues certificates to the top N participants.
  @override
  Future<String> closeCompetition(
    String competitionId,
    String competitionName,
    String companyName, {
    int topN = 10,
  }) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      // 1. Update competition status to "Closed"
      await firestoreInstance
          .collection("Competitions")
          .doc(competitionId)
          .update({"status": "Closed"});

      // 2. Recalculate final ranks
      await _calculateAndUpdateRanks(firestoreInstance, competitionId);

      // 3. Get top N submissions (checked, sorted by score DESC)
      final snapshot = await firestoreInstance
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId)
          .where("is_checked", isEqualTo: true)
          .orderBy("score", descending: true)
          .limit(topN)
          .get();

      if (snapshot.docs.isEmpty) return competitionId;

      // 4. Issue certificates for each top-N submission
      final WriteBatch batch = firestoreInstance.batch();

      for (int i = 0; i < snapshot.docs.length; i++) {
        final subData = snapshot.docs[i].data();
        final int rank = (subData['rank'] as num?)?.toInt() ?? (i + 1);
        final String userId = subData['user_id'] ?? '';
        final String submissionId =
            subData['submissions_id'] ?? snapshot.docs[i].id;

        if (userId.isEmpty) continue;

        final existingCert = await firestoreInstance
            .collection("Certificates")
            .where("competition_id", isEqualTo: competitionId)
            .where("user_id", isEqualTo: userId)
            .limit(1)
            .get();

        if (existingCert.docs.isNotEmpty) continue;

        final certRef = firestoreInstance.collection("Certificates").doc();
        final cert = CertificateModel(
          certificateId: certRef.id,
          competitionId: competitionId,
          userId: userId,
          competitionName: competitionName,
          companyName: companyName,
          rank: rank,
          topN: topN,
          issuedAt: Timestamp.now(),
        );
        batch.set(certRef, cert.toMap()..addAll({'submission_id': submissionId}));
      }

      await batch.commit();
      return competitionId;
    } catch (e) {
      throw Exception("Error gagal menutup kompetisi: $e");
    }
  }

  /// Returns all certificates earned by the current user.
  @override
  Future<List<CertificateEntity>> getMyCertificates() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User belum login");
    }

    try {
      final snapshot = await firestoreInstance
          .collection("Certificates")
          .where("user_id", isEqualTo: currentUser.uid)
          .orderBy("issued_at", descending: true)
          .get();

      return snapshot.docs
          .map((e) => CertificateModel.fromMap(e.data()).toEntity())
          .toList();
    } catch (e) {
      throw Exception("Error gagal mengambil sertifikat: $e");
    }
  }

  /// Generates a CSV string of all submissions for a competition.
  /// Returns the CSV content as a String (to be saved/shared by the caller).
  /// Columns: Rank, Name (via Competition_participants), Score, Feedback, Is Finalist, Submitted At
  @override
  Future<String> exportSubmissionsToCsv(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      // 1. Get all submissions ordered by rank ASC
      final subSnap = await firestoreInstance
          .collection("Submissions")
          .where("competition_id", isEqualTo: competitionId)
          .orderBy("rank")
          .get();

      if (subSnap.docs.isEmpty) {
        return "Rank,User ID,Score,Feedback,Is Finalist,Submitted At\n";
      }

      // 2. Collect unique user IDs for name lookup
      final userIds = subSnap.docs
          .map((d) => d.data()['user_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      // 3. Batch-fetch jobseeker names (chunks of 10 for Firestore whereIn limit)
      final Map<String, String> userNames = {};
      for (var i = 0; i < userIds.length; i += 10) {
        final chunk = userIds.sublist(
          i,
          (i + 10 > userIds.length) ? userIds.length : i + 10,
        );
        final usersSnap = await firestoreInstance
            .collection("Jobseeker")
            .where("user_id", whereIn: chunk)
            .get();
        for (final doc in usersSnap.docs) {
          final data = doc.data();
          final uid = data['user_id']?.toString() ?? '';
          final name = data['name']?.toString() ?? uid;
          if (uid.isNotEmpty) userNames[uid] = name;
        }
      }

      // 4. Build CSV
      final buffer = StringBuffer();
      buffer.writeln('Rank,Nama,User ID,Skor,Feedback,Finalis,Submitted At');

      for (final doc in subSnap.docs) {
        final data = doc.data();
        final int rank = (data['rank'] as num?)?.toInt() ?? 0;
        final String uid = data['user_id']?.toString() ?? '';
        final String name = _escapeCsvField(userNames[uid] ?? uid);
        final double score = (data['score'] is int)
            ? (data['score'] as int).toDouble()
            : (data['score'] ?? 0.0);
        final String feedback =
            _escapeCsvField(data['feedback']?.toString() ?? '');
        final bool isFinalist = data['is_finalist'] == true;
        final String submittedAt = data['submitted_at'] != null
            ? (data['submitted_at'] as Timestamp).toDate().toIso8601String()
            : '';

        buffer.writeln(
          '$rank,$name,$uid,${score.toStringAsFixed(0)},$feedback,${isFinalist ? "Ya" : "Tidak"},$submittedAt',
        );
      }

      return buffer.toString();
    } catch (e) {
      throw Exception("Error gagal mengekspor data kandidat: $e");
    }
  }

  String _escapeCsvField(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
