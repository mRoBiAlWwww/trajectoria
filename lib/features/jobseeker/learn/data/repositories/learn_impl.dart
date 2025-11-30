import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/data/datasources/learn_service.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/course.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/module.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/subchapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class LearnRepositoryImpl extends LearnRepository {
  final LearnService service;
  LearnRepositoryImpl({required this.service});

  @override
  Future<Either> getCourses() async {
    try {
      final result = await service.getCourses();
      return Right(
        List.from(
          result,
        ).map((e) => CourseModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCourseChapter(String courseId, int chapterOrder) async {
    try {
      final result = await service.getCourseChapter(courseId, chapterOrder);
      return Right(CourseChapterModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getSubchapters(String courseId, int chapterOrder) async {
    try {
      final result = await service.getSubchapters(courseId, chapterOrder);
      return Right(
        List.from(
          result,
        ).map((e) => SubChapterModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  ) async {
    try {
      final result = await service.getModules(
        courseId,
        chapterOrder,
        subChapterId,
      );
      return Right(
        List.from(
          result,
        ).map((e) => ModuleModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getQuiz(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  ) async {
    try {
      final result = await service.getQuizzes(
        courseId,
        chapterOrder,
        subChapterId,
        moduleId,
      );
      return Right(
        List.from(result).map((e) => QuizModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> addFinishedModule(String moduleId) async {
    try {
      final result = await service.addFinishedModule(moduleId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> addUserScore(double score) async {
    try {
      final result = await service.addUserScore(score);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
