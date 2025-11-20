import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';

abstract class LearnService {
  Future<Either> getCourses();
  Future<Either> getCourseChapter(String courseId, int chapterOrder);
  Future<Either> getSubchapters(String courseId, int chapterOrder);
  Future<Either> getModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  );
  Future<Either> getQuizzes(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  );
  Future<Either> addFinishedModule(String moduleId);
  Future<Either> addUserScore(double score);
  Future<Either> getFinishedModules();
}

class LearnServiceImpl extends LearnService {
  @override
  Future<Either> getCourses() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCourses = await firestoreInstance
          .collection('Courses')
          .orderBy('order_index', descending: false)
          .get();

      return Right(getCourses.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getCourseChapter(String courseId, int chapterOrder) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var getCourses = await firestoreInstance
          .collection('Courses')
          .doc(courseId)
          .collection('course_chapters')
          .where('order_index', isEqualTo: chapterOrder)
          .orderBy('order_index', descending: false)
          .get();

      return Right(getCourses.docs.first.data());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getSubchapters(String courseId, int chapterOrder) async {
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
      return Right(subchapters);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getModules(
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
      return Right(modules);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getQuizzes(
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
      return Right(quizzes);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addFinishedModule(String moduleId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser?.uid)
          .update({
            'finished_module': FieldValue.arrayUnion([moduleId]),
          });

      return Right("Changes was successful");
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addUserScore(double score) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser?.uid)
          .update({'courses_score': FieldValue.increment(score)});

      return Right("Score was successful added");
    } catch (e) {
      return const Left("Please try again");
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
