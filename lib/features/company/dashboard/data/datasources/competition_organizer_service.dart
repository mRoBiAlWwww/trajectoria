import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:trajectoria/common/helper/parser/capitalize.dart';
import 'package:trajectoria/common/helper/parser/parse_sumary.dart';
import 'package:trajectoria/core/config/env/env.dart';
import 'package:trajectoria/features/company/dashboard/data/models/announcement.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
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
      return submissions.docs
          .map((e) => e.data() as Map<String, dynamic>)
          .toList();
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
      apiKey: Env.privateKey,
      model: "gemini-2.5-flash-lite",
    );
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    List<String> combinedSummary = [];
    List<String> combinedProblemSolution = [];

    try {
      for (final fileUrl in fileUrls) {
        final response = await http.get(Uri.parse(fileUrl));
        if (response.statusCode != 200) {
          throw Exception("Gagal download file: $fileUrl");
        }
        final Uint8List fileBytes = response.bodyBytes;

        final mimeType = fileUrl.endsWith(".pdf")
            ? "application/pdf"
            : "image/jpeg";

        final analysisResultSummary = Content.multi([
          TextPart(
            "Analisa file kompetisi ini. $problemStatement . Berdasarkan hal tersebut berikan saya insight/summary dalam beberapa point dan simpan poin-poin tadi dalam bentuk array yg berisi map poin, dan deskripsi serta batasi 5 poin saja dan tiap point hanya satu kalimat saja",
          ),
          DataPart(mimeType, fileBytes),
        ]);
        final geminiResponseSummary = await geminiModel.generateContent([
          analysisResultSummary,
        ]);
        final List<String> summaryList = parseSummary(
          geminiResponseSummary.text ?? "",
        );
        combinedSummary.addAll(summaryList);

        final analysisResultProblemSolution = Content.multi([
          TextPart(
            "Analisa file kompetisi ini. $problemStatement . Berdasarkan hal tersebut berikan saya Problem–Solution Fit Analysis atau Analisis tingkat kecocokan solusi terhadap masalah dalam beberapa point dan simpan poin-poin tadi dalam bentuk array yg berisi map poin, dan deskripsi serta batasi 5 poin saja dan tiap point hanya satu kalimat saja",
          ),
          DataPart(mimeType, fileBytes),
        ]);
        final geminiResponseProblemSolution = await geminiModel.generateContent(
          [analysisResultProblemSolution],
        );
        final List<String> problemSolutionList = parseSummary(
          geminiResponseProblemSolution.text ?? "",
        );
        combinedProblemSolution.addAll(problemSolutionList);
      }
      final data = {
        "common_pattern": combinedProblemSolution.take(5).toList(),
        "summary": combinedSummary.take(5).toList(),
      };
      await firestoreInstance.collection("Submissions").doc(submissionId).set({
        "ai_analyzed": data,
      }, SetOptions(merge: true));

      return InsightAIModel.fromMap(data).toEntity();
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

      return announcementId;
    } catch (e) {
      throw Exception("Error score tidak berhasil ditambahkan $e");
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
      return finalis.docs.map((e) => e.data()).toList();
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

      return submissions.docs.map((e) => e.data()).toList();
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

        allSubs.addAll(subSnap.docs.map((e) => e.data()).toList());
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

      return submissionDoc.data()!;
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
}
