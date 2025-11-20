import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:trajectoria/common/helper/capitalize.dart';
import 'package:trajectoria/common/helper/parser/parse_sumary.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/finalis.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';

abstract class CreateCompetitionService {
  Future<Either> createCompetition(CompetitionModel newCompetition);
  Future<Either> draftCompetition(CompetitionModel newCompetition);
  Future<Either> getDraftCompetitions();
  Future<Either> getCompetitions();
  Future<Either> getCompetitionById(String competitionId);
  Future<Either> deleteCompetitionById(String competitionId);
  Future<Either> getCompetitionsByTitle(String keyword);
  Future<Either> getJobseekerSubmissions(String competitionId);
  Future<Either> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  });
  Future<Either> getUserInfo(String submissionId);
  Future<Either> scoring(int totalScore, String feedback, String submissionId);
  Future<Either> addToFinalis(
    SubmissionModel finalis,
    String name,
    String imageUrl,
  );
  Future<Either> getFinalis(String competitionId);
  Future<Either> deleteFinalis(String finalisId);
  Future<Either> getJobseekerSubmissionsIncrement(String competitionId);
  Future<Either> getAcrossJobseekerSubmissions();
}

class CreateCompetitionServiceImpl extends CreateCompetitionService {
  @override
  Future<Either> createCompetition(CompetitionModel newCompetition) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    final String capitalizedKeyword = capitalizeWords(newCompetition.title);
    try {
      if (newCompetition.competitionId.isEmpty) {
        final competitionId = firestoreInstance
            .collection('Competitions')
            .doc()
            .id;

        final updatedEntity = newCompetition.copyWith(
          competitionId: competitionId,
          companyId: currentUser!.uid,
          title: capitalizedKeyword,
          status: "Dirilis",
        );
        await firestoreInstance
            .collection('Competitions')
            .doc(competitionId)
            .set(updatedEntity.toMap());
        return Right(competitionId);
      } else {
        debugPrint(newCompetition.status);
        await firestoreInstance
            .collection('Competitions')
            .doc(newCompetition.competitionId)
            .set(newCompetition.toMap());
        return Right(newCompetition.competitionId);
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

  @override
  Future<Either> draftCompetition(CompetitionModel newCompetition) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      final competitionId = firestoreInstance
          .collection('Draft_competitions')
          .doc()
          .id;

      final updatedEntity = newCompetition.copyWith(
        competitionId: competitionId,
        companyId: currentUser!.uid,
      );
      debugPrint("Draft Competition Service Called 1");
      await firestoreInstance
          .collection('Draft_competitions')
          .doc(competitionId)
          .set(updatedEntity.toMap());
      debugPrint("Draft Competition Service Called 2");
      debugPrint(competitionId);
      return Right(competitionId);
    } catch (e) {
      return Left("Error: $e");
    }
  }

  @override
  Future<Either> getDraftCompetitions() async {
    final firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      var drafts = await firestoreInstance
          .collection('Draft_competitions')
          .where('company_id', isEqualTo: currentUser!.uid)
          .get();
      debugPrint(currentUser.uid);
      return Right(drafts.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left("Error: $e");
    }
  }

  @override
  Future<Either> getCompetitions() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      var competitions = await firestoreInstance
          .collection('Competitions')
          .where('company_id', isEqualTo: currentUser!.uid)
          .get();

      return Right(competitions.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getCompetitionById(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var competitions = await firestoreInstance
          .collection('Competitions')
          .where('competition_id', isEqualTo: competitionId)
          .limit(1)
          .get();

      debugPrint("Get Competition By Id Service Called");
      return Right(competitions.docs.first.data());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deleteCompetitionById(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance
          .collection('Competitions')
          .doc(competitionId)
          .delete();

      return Right("Competition was successfully deleted");
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getCompetitionsByTitle(String keyword) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    final String capitalizedKeyword = capitalizeWords(keyword);

    if (capitalizedKeyword.isEmpty) {
      debugPrint("Keyword kosong, mengembalikan list kosong.");
      return Right([]);
    }
    try {
      final competitions = await firestoreInstance
          .collection('Competitions')
          .where('company_id', isEqualTo: currentUser!.uid)
          .orderBy('title')
          .startAt([capitalizedKeyword])
          .endAt(['$capitalizedKeyword\uf8ff'])
          .get();

      debugPrint("jangan");
      debugPrint("Mencari: $capitalizedKeyword");
      debugPrint(competitions.docs.length.toString());
      return Right(competitions.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getJobseekerSubmissions(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      final submissions = await firestoreInstance
          .collection('Submissions')
          .where('competition_id', isEqualTo: competitionId)
          .get();

      return Right(submissions.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getUserInfo(String submissionId) async {
    final firestoreInstance = FirebaseFirestore.instance;

    try {
      final submissionDoc = await firestoreInstance
          .collection('Submissions')
          .doc(submissionId)
          .get();

      if (!submissionDoc.exists) return Left('Submission not found');
      final submissionData = submissionDoc.data()!;

      final competitionParticipantId =
          submissionData['competition_participants_id'];
      debugPrint(competitionParticipantId);

      final participantDoc = await firestoreInstance
          .collection('Competition_participants')
          .doc(competitionParticipantId)
          .get();

      if (!participantDoc.exists) return Left('Participant not found');
      final userId = participantDoc.data()?['user_id'] as String?;

      if (userId == null || userId.isEmpty) return Left('User ID not found');

      final userDoc = await firestoreInstance
          .collection('Jobseeker')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return Right(userDoc.data());
      } else {
        return Left('User not found');
      }
    } catch (e) {
      return Left("error $e");
    }
  }

  @override
  Future<Either> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  }) async {
    final GenerativeModel geminiModel = GenerativeModel(
      apiKey: "AIzaSyBwJNJyzppLKMk954018C035VqnTlbnQf4",
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

        final mimeType = fileUrl.endsWith('.pdf')
            ? 'application/pdf'
            : 'image/jpeg';

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
        'common_pattern': combinedProblemSolution.take(5).toList(),
        'summary': combinedSummary.take(5).toList(),
      };
      await firestoreInstance.collection('Submissions').doc(submissionId).set({
        'ai_analyzed': data,
      }, SetOptions(merge: true));

      return Right(InsightAIModel.fromMap(data).toEntity());
    } catch (e) {
      return Left("Analisa Gagal: $e");
    }
  }

  @override
  Future<Either> scoring(
    int totalScore,
    String feedback,
    String submissionId,
  ) async {
    debugPrint(totalScore.toString());
    debugPrint(feedback);
    debugPrint(submissionId);
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance.collection('Submissions').doc(submissionId).set({
        'score': totalScore,
        'feedback': feedback,
        'isChecked': true,
      }, SetOptions(merge: true));

      return Right("Score was successfully");
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addToFinalis(
    SubmissionModel finalis,
    String name,
    String imageUrl,
  ) async {
    final firestoreInstance = FirebaseFirestore.instance;

    try {
      final alreadyInFinal = await FirebaseFirestore.instance
          .collection('Finalis')
          .where('submissions_id', isEqualTo: finalis.submissionId)
          .get();

      if (alreadyInFinal.docs.isNotEmpty) {
        return Right("User sudah ada di final");
      }

      final finalisId = firestoreInstance.collection('Finalis').doc().id;

      FinalisModel userFinalis = FinalisModel(
        finalisId: finalisId,
        competitionId: finalis.competitionId,
        submissionId: finalis.submissionId,
        imageUrl: imageUrl,
        name: name,
        score: finalis.score,
        submittedAt: finalis.submittedAt,
      );
      await firestoreInstance
          .collection('Finalis')
          .doc(finalisId)
          .set(userFinalis.toMap());
      return Right(finalisId);
    } catch (e) {
      return Left("Error: $e");
    }
  }

  @override
  Future<Either> getFinalis(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var finalis = await firestoreInstance
          .collection('Finalis')
          .where('competition_id', isEqualTo: competitionId)
          .get();
      return Right(finalis.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deleteFinalis(String finalisId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance.collection('Finalis').doc(finalisId).delete();
      return Right("data was successfull delete");
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getJobseekerSubmissionsIncrement(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      final submissions = await firestoreInstance
          .collection('Submissions')
          .where('competition_id', isEqualTo: competitionId)
          .orderBy('score', descending: true)
          .get();

      return Right(submissions.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getAcrossJobseekerSubmissions() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    try {
      final uid = currentUser!.uid;

      final competitionsSnap = await firestoreInstance
          .collection('Competitions')
          .where('company_id', isEqualTo: uid)
          .get();

      final compIds = competitionsSnap.docs.map((e) => e.id).toList();

      if (compIds.isEmpty) {
        return Right([]);
      }

      List<Map<String, dynamic>> allSubs = [];

      for (var i = 0; i < compIds.length; i += 10) {
        final chunk = compIds.sublist(
          i,
          (i + 10 > compIds.length) ? compIds.length : i + 10,
        );

        final subSnap = await firestoreInstance
            .collection('Submissions')
            .where('competition_id', whereIn: chunk)
            .get();

        allSubs.addAll(subSnap.docs.map((e) => e.data()).toList());
      }

      return Right(allSubs);
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
