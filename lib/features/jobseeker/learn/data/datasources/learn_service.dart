import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/progres.dart';

abstract class LearnService {
  Future<List<Map<String, dynamic>>> getCourses();
  Future<Map<String, dynamic>> getCourseChapterById(
    String courseId,
    String courseChapterId,
  );
  Future<List<Map<String, dynamic>>> getAllCourseChapters(String courseId);
  Future<Map<String, dynamic>> getCourseChapter(
    String courseId,
    int chapterOrder,
  );
  Future<List<Map<String, dynamic>>> getSubchapters(
    String courseId,
    int chapterOrder,
  );
  Future<List<Map<String, dynamic>>> getModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  );
  Future<List<Map<String, dynamic>>> getQuizzes(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  );
  Future<String> addFinishedModule(String moduleId);
  Future<String> addFinishedSubchapter(String subchapterId);
  Future<String> addUserScore(double score);
  Future<String> addFinishedChapter(String chapterId);
  Future<String> addOnprogresChapter(String chapterId);
  Future<String> addValueProgres(String courseId, int newValue);
}

class LearnServiceImpl extends LearnService {
  @override
  Future<List<Map<String, dynamic>>> getCourses() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCourses = await firestoreInstance
          .collection("Courses")
          .orderBy("order_index", descending: false)
          .get();

      return getCourses.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list course $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCourseChapterById(
    String courseId,
    String courseChapterId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCoursesChapter = await firestoreInstance
          .collection("Courses")
          .doc(courseId)
          .collection("course_chapters")
          .where("chapter_id", isEqualTo: courseChapterId)
          .get();

      return getCoursesChapter.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list course $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllCourseChapters(
    String courseId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCoursesChapter = await firestoreInstance
          .collection("Courses")
          .doc(courseId)
          .collection("course_chapters")
          .orderBy("order_index", descending: false)
          .get();
      return getCoursesChapter.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error gagal mendapatkan chapter dari course $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCourseChapter(
    String courseId,
    int chapterOrder,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCoursesChapter = await firestoreInstance
          .collection("Courses")
          .doc(courseId)
          .collection("course_chapters")
          .where("order_index", isEqualTo: chapterOrder)
          .orderBy("order_index", descending: false)
          .get();

      return getCoursesChapter.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan chapter dari course $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSubchapters(
    String courseId,
    int chapterOrder,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    List<Map<String, dynamic>> subchapters = [];

    try {
      QuerySnapshot<Map<String, dynamic>> getCourses = await firestoreInstance
          .collection("Courses")
          .doc(courseId)
          .collection("course_chapters")
          .where("order_index", isEqualTo: chapterOrder)
          .get();

      QuerySnapshot<Map<String, dynamic>> subchaptersSnapshot =
          await firestoreInstance
              .collection("Courses")
              .doc(courseId)
              .collection("course_chapters")
              .doc(getCourses.docs.first.id)
              .collection("sub_chapters")
              .orderBy("order_index", descending: false)
              .get();

      List<Map<String, dynamic>> lessons = subchaptersSnapshot.docs
          .map((doc) => doc.data())
          .toList();
      subchapters.addAll(lessons);
      return subchapters;
    } catch (e) {
      throw Exception("Error gagal mendapatkan subchapters dari chapter $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    List<Map<String, dynamic>> modules = [];

    try {
      QuerySnapshot<Map<String, dynamic>> getCourses = await firestoreInstance
          .collection("Courses")
          .doc(courseId)
          .collection("course_chapters")
          .where("order_index", isEqualTo: chapterOrder)
          .get();

      QuerySnapshot<Map<String, dynamic>> subchapterSnapshot =
          await FirebaseFirestore.instance
              .collection("Courses")
              .doc(courseId)
              .collection("course_chapters")
              .doc(getCourses.docs.first.id)
              .collection("sub_chapters")
              .where("subchapter_id", isEqualTo: subChapterId)
              .get();

      QuerySnapshot<Map<String, dynamic>> modulesSnapshot =
          await FirebaseFirestore.instance
              .collection("Courses")
              .doc(courseId)
              .collection("course_chapters")
              .doc(getCourses.docs.first.id)
              .collection("sub_chapters")
              .doc(subchapterSnapshot.docs.first.id)
              .collection("modules")
              .orderBy("order_index", descending: false)
              .get();

      List<Map<String, dynamic>> module = modulesSnapshot.docs
          .map((doc) => doc.data())
          .toList();
      modules.addAll(module);
      return modules;
    } catch (e) {
      throw Exception("Error gagal mendapatkan modul dari subchapter $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getQuizzes(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    List<Map<String, dynamic>> quizzes = [];
    try {
      QuerySnapshot<Map<String, dynamic>> getCourses = await firestoreInstance
          .collection("Courses")
          .doc(courseId)
          .collection("course_chapters")
          .where("order_index", isEqualTo: chapterOrder)
          .get();

      QuerySnapshot<Map<String, dynamic>> subchapterSnapshot =
          await FirebaseFirestore.instance
              .collection("Courses")
              .doc(courseId)
              .collection("course_chapters")
              .doc(getCourses.docs.first.id)
              .collection("sub_chapters")
              .where("subchapter_id", isEqualTo: subChapterId)
              .get();

      QuerySnapshot<Map<String, dynamic>> modulesSnapshot =
          await FirebaseFirestore.instance
              .collection("Courses")
              .doc(courseId)
              .collection("course_chapters")
              .doc(getCourses.docs.first.id)
              .collection("sub_chapters")
              .doc(subchapterSnapshot.docs.first.id)
              .collection("modules")
              .where("module_id", isEqualTo: moduleId)
              .get();

      QuerySnapshot<Map<String, dynamic>> quizzesSnapshot =
          await FirebaseFirestore.instance
              .collection("Courses")
              .doc(courseId)
              .collection("course_chapters")
              .doc(getCourses.docs.first.id)
              .collection("sub_chapters")
              .doc(subchapterSnapshot.docs.first.id)
              .collection("modules")
              .doc(modulesSnapshot.docs.first.id)
              .collection("quizzes")
              .get();

      List<Map<String, dynamic>> quiz = quizzesSnapshot.docs
          .map((doc) => doc.data())
          .toList();
      quizzes.addAll(quiz);
      return quizzes;
    } catch (e) {
      throw Exception("Error gagal mendapatkan kuis dari modul $e");
    }
  }

  @override
  Future<String> addFinishedModule(String moduleId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser?.uid)
          .update({
            "finished_module": FieldValue.arrayUnion([moduleId]),
          });

      return "Modul yang selesai berhasil ditambahkan ke daftar";
    } catch (e) {
      throw Exception("Error modul gagal ditambahkan ke daftar $e");
    }
  }

  @override
  Future<String> addFinishedSubchapter(String subchapterId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser?.uid)
          .update({
            "finished_subchapter": FieldValue.arrayUnion([subchapterId]),
          });

      return "Subchapter selesai berhasil ditambahkan ke daftar";
    } catch (e) {
      throw Exception("Error subchapter gagal ditambahkan ke daftar $e");
    }
  }

  @override
  Future<String> addUserScore(double score) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser?.uid)
          .update({"courses_score": FieldValue.increment(score)});

      return "Skor berhasil ditambahkan";
    } catch (e) {
      throw Exception("Error skor gagal ditambahkan $e");
    }
  }

  @override
  Future<String> addFinishedChapter(String chapterId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser!.uid)
          .update({
            "finished_chapter": FieldValue.arrayUnion([chapterId]),
          });

      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser.uid)
          .update({'onprogres_chapter': chapterId});

      return "Chapter selesai berhasil ditambahkan ke daftar";
    } catch (e) {
      throw Exception("Error chapter gagal ditambahkan ke daftar $e");
    }
  }

  @override
  Future<String> addOnprogresChapter(String chapterId) async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser!.uid)
          .update({'onprogres_chapter': chapterId});
      return "Chapter berhasil ditambahkan ke daftar chapter yg sedang dipelajari";
    } catch (e) {
      throw Exception("Error gagal menambahkan partisipan kompetisi $e");
    }
  }

  @override
  Future<String> addValueProgres(String courseId, int newValue) async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      // Dapatkan user
      final userRef = firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser!.uid);
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        // 1. Ambil List mentah
        List<dynamic> rawList = snapshot.data()?["progres"];

        // 2. Convert ke List<ProgresModel> agar mudah diolah
        List<ProgresModel> listData = rawList.map((e) {
          return ProgresModel.fromMap(e as Map<String, dynamic>);
        }).toList();

        // 3. Cari Index menggunakan Object
        int index = listData.indexWhere((item) => item.courseId == courseId);

        if (index == -1) {
          // Buat map baru dan tambahkan ke list
          ProgresModel newProgress = ProgresModel(
            courseId: courseId,
            valueProgres: newValue,
          );

          listData.add(newProgress);
        } else {
          // Ambil map lama
          ProgresModel oldModel = listData[index];

          // Buat model baru dengan nilai yang diupdate
          ProgresModel updatedModel = ProgresModel(
            courseId: oldModel.courseId,
            valueProgres: oldModel.valueProgres + newValue,
          );

          // Kembalikan ke dalam list di posisi index yang sama
          listData[index] = updatedModel;
        }

        // 4. Convert balik ke JSON (Map) untuk disimpan ke Firestore
        List<Map<String, dynamic>> listToSave = listData
            .map((e) => e.toMap())
            .toList();

        // 5. Simpan
        await userRef.update({"progres": listToSave});
      }
      return "Nilai progres berhasil ditambahkan";
    } catch (e) {
      throw Exception("Error gagal menambahkan progres pembelajaran $e");
    }
  }
}
