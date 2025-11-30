import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';

abstract class LearnService {
  Future<List<Map<String, dynamic>>> getCourses();
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
  Future<String> addUserScore(double score);
  Future<Either> getFinishedModules();
}

class LearnServiceImpl extends LearnService {
  @override
  Future<List<Map<String, dynamic>>> getCourses() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCourses = await firestoreInstance
          .collection('Courses')
          .orderBy('order_index', descending: false)
          .get();

      return getCourses.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list course $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCourseChapter(
    String courseId,
    int chapterOrder,
  ) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCourses = await firestoreInstance
          .collection('Courses')
          .doc(courseId)
          .collection('course_chapters')
          .where('order_index', isEqualTo: chapterOrder)
          .orderBy('order_index', descending: false)
          .get();

      return getCourses.docs.first.data();
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
          .collection('Courses')
          .doc(courseId)
          .collection('course_chapters')
          .where('order_index', isEqualTo: chapterOrder)
          .get();

      QuerySnapshot<Map<String, dynamic>> subchaptersSnapshot =
          await firestoreInstance
              .collection('Courses')
              .doc(courseId)
              .collection('course_chapters')
              .doc(getCourses.docs.first.id)
              .collection('sub_chapters')
              .orderBy('order_index', descending: false)
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
          .collection('Courses')
          .doc(courseId)
          .collection('course_chapters')
          .where('order_index', isEqualTo: chapterOrder)
          .get();

      QuerySnapshot<Map<String, dynamic>> subchapterSnapshot =
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(courseId)
              .collection('course_chapters')
              .doc(getCourses.docs.first.id)
              .collection('sub_chapters')
              .where('subchapter_id', isEqualTo: subChapterId)
              .get();

      QuerySnapshot<Map<String, dynamic>> modulesSnapshot =
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(courseId)
              .collection('course_chapters')
              .doc(getCourses.docs.first.id)
              .collection('sub_chapters')
              .doc(subchapterSnapshot.docs.first.id)
              .collection('modules')
              .orderBy('order_index', descending: false)
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
          .collection('Courses')
          .doc(courseId)
          .collection('course_chapters')
          .where('order_index', isEqualTo: chapterOrder)
          .get();

      QuerySnapshot<Map<String, dynamic>> subchapterSnapshot =
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(courseId)
              .collection('course_chapters')
              .doc(getCourses.docs.first.id)
              .collection('sub_chapters')
              .where('subchapter_id', isEqualTo: subChapterId)
              .get();

      QuerySnapshot<Map<String, dynamic>> modulesSnapshot =
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(courseId)
              .collection('course_chapters')
              .doc(getCourses.docs.first.id)
              .collection('sub_chapters')
              .doc(subchapterSnapshot.docs.first.id)
              .collection('modules')
              .where('module_id', isEqualTo: moduleId)
              .get();
      debugPrint(courseId);
      debugPrint(getCourses.docs.first.id);
      debugPrint(subchapterSnapshot.docs.first.id);
      debugPrint(modulesSnapshot.docs.first.id);
      QuerySnapshot<Map<String, dynamic>> quizzesSnapshot =
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(courseId)
              .collection('course_chapters')
              .doc(getCourses.docs.first.id)
              .collection('sub_chapters')
              .doc(subchapterSnapshot.docs.first.id)
              .collection('modules')
              .doc(modulesSnapshot.docs.first.id)
              .collection('quizzes')
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
          .collection('Jobseeker')
          .doc(currentUser?.uid)
          .update({
            'finished_module': FieldValue.arrayUnion([moduleId]),
          });

      return "Modul yang selesai berhasil ditambahkan ke daftar";
    } catch (e) {
      throw Exception("Error modul gagal ditambahkan ke daftar $e");
    }
  }

  @override
  Future<String> addUserScore(double score) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser?.uid)
          .update({'courses_score': FieldValue.increment(score)});

      return "Skor berhasil ditambahkan";
    } catch (e) {
      throw Exception("Error skor gagal ditambahkan $e");
    }
  }

  //hanya sementara
  @override
  Future<Either> getFinishedModules() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      var returnedData = await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser?.uid)
          .get();

      return Right(JobSeekerModel.fromMap(returnedData.data()!).toEntity());
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
