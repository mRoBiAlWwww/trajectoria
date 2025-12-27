import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trajectoria/common/helper/parser/capitalize.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:path/path.dart' as p;

abstract class CompetitionService {
  Future<List<Map<String, dynamic>>> getCompetitions();
  Future<Map<String, dynamic>> getSingleCompetition(String competitionId);
  Future<String> addCompetitionParticipant(String compId);
  Future<String> downloadAndOpenFile(String fileUrl, String fileName);
  Future<List<FileItemModel>> uploadMultiplePdfs();
  Future<String> addSubmission(SubmissionReq submission);
  Future<List<Map<String, dynamic>>> getCompetitionsByTitle(String keyword);
  Future<List<Map<String, dynamic>>> getCompetitionsByCategory(
    String categoryId,
  );
  Future<List<Map<String, dynamic>>> getCompetitionsByFilters(
    List<String> category,
    String deadline,
  );
  Future<List<Map<String, dynamic>>> getCategories();
  Future<String> isAlreadySubmitted(String competitionId);
  Future<Map<String, dynamic>?> getCompetitionParticipants(
    String competitionId,
  );
  Future<Map<String, dynamic>?> getSubmissionByCompetitionParticipantId(
    String competitionParticipantId,
  );
  Future<int> getTotalCompetitionParticipants(String competitionId);
  Future<String> addBookmark(String competitionId);
  Future<String> deleteBookmark(String competitionId);
  Future<Map<String, dynamic>> getUserprofileInfo();
}

class CompetitionServiceImpl extends CompetitionService {
  @override
  Future<List<Map<String, dynamic>>> getCompetitions() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var competitions = await firestoreInstance
          .collection('Competitions')
          .where('status', isEqualTo: "Dirilis")
          .get();

      return competitions.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error gagal mendapatkan daftar kompetisi $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getSingleCompetition(
    String competitionId,
  ) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('Competitions')
          .doc(competitionId)
          .get();
      return userDoc.data()!;
    } catch (e) {
      throw Exception("Error gagal mendapatkan kompetisi $e");
    }
  }

  @override
  Future<String> addCompetitionParticipant(String compId) async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      //ambil id unik current user
      var currentUser = FirebaseAuth.instance.currentUser;

      //ambil id unik collection
      final competitionParticipantId = firestoreInstance
          .collection('Competition_participants')
          .doc()
          .id;

      //add id unik di data
      final Map<String, dynamic> newParticipant = CompetitionParticipantsModel(
        competitionParticipantId: competitionParticipantId,
        competitionId: compId,
        userId: currentUser!.uid,
        createdAt: Timestamp.now(),
      ).toMap();

      //simpan ke db
      await firestoreInstance
          .collection('Competition_participants')
          .doc(competitionParticipantId)
          .set(newParticipant);

      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser.uid)
          .update({
            'competitions_onprogres': FieldValue.arrayUnion([compId]),
          });
      return competitionParticipantId;
    } catch (e) {
      throw Exception("Error gagal menambahkan partisipan kompetisi $e");
    }
  }

  @override
  Future<String> downloadAndOpenFile(String fileUrl, String fileName) async {
    try {
      // 1️⃣ Minta izin (Android lama)
      if (Platform.isAndroid && await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      // 2️⃣ Tentukan lokasi penyimpanan
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      debugPrint('Downloading file...');

      // 3️⃣ Download file
      final dio = Dio();
      await dio.download(fileUrl, filePath);

      debugPrint('Download complete: $fileName');

      // 5️⃣ Buka file otomatis
      await OpenFilex.open(filePath);
      return "Download berhasil dan file berhasil dibuka";
    } catch (e) {
      throw Exception('Error download file gagal: $e');
    }
  }

  @override
  Future<List<FileItemModel>> uploadMultiplePdfs() async {
    try {
      // 1️⃣ pilih beberapa file PDF
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception("Tidak ada format file yg cocok");
      }

      const Set<String> imageExtensions = {
        'jpg',
        'jpeg',
        'png',
        'gif',
        'bmp',
        'webp',
        'heic',
      };

      final files = result.files
          .where((f) {
            if (f.path == null) return false;
            final ext = f.extension?.toLowerCase();
            if (ext == null || ext.isEmpty) {
              return true;
            }

            return !imageExtensions.contains(ext);
          })
          .map((f) => File(f.path!))
          .toList();

      if (files.isEmpty) {
        throw Exception(
          "Format file gambar tidak diizinkan. Silakan pilih format lain.",
        );
      }

      final cloudinary = sl<CloudinaryPublic>();

      debugPrint("📤 Mengupload ${files.length} file...");

      // 2️⃣ upload semua file dalam loop (atau bisa pakai Future.wait)
      final List<FileItemModel> uploadedFiles = [];

      for (var file in files) {
        final fileName = file.path.split('/').last;
        final ext = p.extension(file.path).replaceAll('.', '');

        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path,
            folder: "trajectoria/pdf_file",
            resourceType: CloudinaryResourceType.Raw,
          ),
        );
        uploadedFiles.add(
          FileItemModel(
            fileName: fileName,
            extension: ext,
            url: response.secureUrl,
          ),
        );
      }

      return uploadedFiles;
    } catch (e) {
      throw Exception("Error Upload file gagal $e");
    }
  }

  @override
  Future<String> addSubmission(SubmissionReq submission) async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      //ambil id unik collection
      final submissionId = firestoreInstance.collection('Submission').doc().id;

      final SubmissionModel newSubmission = SubmissionModel(
        submissionId: submissionId,
        competitionParticipantId: submission.competitionParticipantId,
        competitionId: submission.competitionId,
        problemStatement: submission.problemStatement,
        submittedAt: Timestamp.now(),
        answerText: submission.answerText,
        answerFiles: submission.answerFiles,
        aiAnalyzed: InsightAIModel(commonPattern: [], summary: []),
        feedback: "",
        score: 0,
        rank: 0,
        isChecked: false,
        isFinalist: false,
      );
      //simpan ke db
      await firestoreInstance
          .collection('Submissions')
          .doc(submissionId)
          .set(newSubmission.toMap());

      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser!.uid)
          .update({
            'competitions_done': FieldValue.arrayUnion([
              submission.competitionId,
            ]),
          });

      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser.uid)
          .update({
            'competitions_onprogres': FieldValue.arrayRemove([
              submission.competitionId,
            ]),
          });
      return "Pengumupulan tugas berhasil!";
    } catch (e) {
      throw Exception("Error submission gagal ditambahkan $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetitionsByTitle(
    String keyword,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final String capitalizedKeyword = capitalizeWords(keyword);

    if (capitalizedKeyword.isEmpty) {
      debugPrint("Keyword kosong, mengembalikan list kosong.");
      return [];
    }
    try {
      final competitions = await firestoreInstance
          .collection('Competitions')
          .orderBy('title')
          .startAt([capitalizedKeyword])
          .endAt(['$capitalizedKeyword\uf8ff'])
          .where('status', isEqualTo: "Dirilis")
          .get();

      return competitions.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception('Error gagal mendapatkan kompetisi berdasarkan title $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetitionsByCategory(
    String categoryId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    if (categoryId.isEmpty) {
      debugPrint("Keyword kosong, mengembalikan list kosong.");
      return [];
    }
    try {
      final competitions = await firestoreInstance
          .collection('Competitions')
          .where('category_id', isEqualTo: categoryId)
          .where('status', isEqualTo: "Dirilis")
          .get();

      return competitions.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception(
        'Error gagal mendapatkan kompetisi berdasarkan kategori $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetitionsByFilters(
    List<String> category,
    String deadline,
  ) async {
    for (var item in category) {
      debugPrint(item);
    }

    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    if (deadline.isEmpty) {
      deadline = "Terdekat";
    }

    if (category.isEmpty) {
      debugPrint("Keyword kosong, mengembalikan list kosong.");
      return [];
    }
    try {
      final competitions = await firestoreInstance
          .collection('Competitions')
          .where('category_id', whereIn: category)
          .where('status', isEqualTo: "Dirilis")
          .orderBy(
            'deadline',
            descending: deadline == "Terdekat" ? false : true,
          )
          .get();
      return competitions.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception(
        'Error gagal mendapatkan kompetisi berdasarkan filters $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var category = await firestoreInstance.collection('Category').get();

      return category.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception('Error gagal kategori dari tiap kompetisi $e');
    }
  }

  @override
  Future<String> isAlreadySubmitted(String competitionId) async {
    var currentUser = FirebaseAuth.instance.currentUser;

    try {
      final jobseeker = await FirebaseFirestore.instance
          .collection('Jobseeker')
          .doc(currentUser!.uid)
          .get();

      final List<dynamic> onprogresCompetitionIds =
          jobseeker.data()?['competitions_onprogres'] ?? [];

      if (onprogresCompetitionIds.contains(competitionId)) {
        return "onprogres";
      }

      final List<dynamic> done = jobseeker.data()?['competitions_done'] ?? [];

      if (done.contains(competitionId)) {
        return "done";
      }

      return "notparticipation";
    } catch (e) {
      throw Exception('Error mengecek status kompetisi $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCompetitionParticipants(
    String competitionId,
  ) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getCompetitionParticipants = await firestoreInstance
          .collection("Competition_participants")
          .where("user_id", isEqualTo: currentUser!.uid)
          .where("competition_id", isEqualTo: competitionId)
          .get();

      if (getCompetitionParticipants.docs.isEmpty) {
        return null;
      }
      return getCompetitionParticipants.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list partisipan kompetisi $e");
    }
  }

  @override
  Future<Map<String, dynamic>?> getSubmissionByCompetitionParticipantId(
    String competitionParticipantId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getSubmissionParticipant = await firestoreInstance
          .collection("Submissions")
          .where(
            "competition_participants_id",
            isEqualTo: competitionParticipantId,
          )
          .get();
      if (getSubmissionParticipant.docs.isEmpty) {
        return null;
      }
      return getSubmissionParticipant.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list partisipan kompetisi $e");
    }
  }

  @override
  Future<int> getTotalCompetitionParticipants(String competitionId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Competition_participants')
          .where("competition_id", isEqualTo: competitionId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception(
        "Error gagal mendapatkan total jumlah peserta kompetisi $e",
      );
    }
  }

  @override
  Future<String> addBookmark(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser!.uid)
          .update({
            'bookmarks': FieldValue.arrayUnion([competitionId]),
          });

      return "Bookmark telah berhasil ditambahkan dari daftar finalis";
    } catch (e) {
      throw Exception("Error gagal menambahkan Bookmark $e");
    }
  }

  @override
  Future<String> deleteBookmark(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser!.uid)
          .update({
            'bookmarks': FieldValue.arrayRemove([competitionId]),
          });
      return "Bookmark telah berhasil dihapus dari daftar finalis";
    } catch (e) {
      throw Exception("Error gagal menghapus Bookmark $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getUserprofileInfo() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getCompetitionParticipants = await firestoreInstance
          .collection("Jobseeker")
          .where("user_id", isEqualTo: currentUser!.uid)
          .get();

      return getCompetitionParticipants.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list partisipan kompetisi $e");
    }
  }
}
