import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trajectoria/common/helper/parser/capitalize.dart';
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
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('analyzeSubmission');

      final result = await callable.call(<String, dynamic>{
        'submissionId': submissionId,
        'problemStatement': problemStatement,
        'fileUrls': fileUrls,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      final model = InsightAIModel.fromMap(data);
      return model.toEntity();
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

  /// Closes a competition and issues certificates to the top N participants.
  /// Delegated to a Cloud Function so the write to Certificates is server-side.
  @override
  Future<String> closeCompetition(
    String competitionId,
    String competitionName,
    String companyName, {
    int topN = 10,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('closeCompetition');

      await callable.call(<String, dynamic>{
        'competitionId': competitionId,
        'competitionName': competitionName,
        'companyName': companyName,
        'topN': topN,
      });

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
