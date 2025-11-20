import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/data/datasources/learn_service.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/course.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/module.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/subchapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';
import 'package:trajectoria/service_locator.dart';

class LearnRepositoryImpl extends LearnRepository {
  @override
  Future<Either> getCourses() async {
    var competitions = await sl<LearnService>().getCourses();
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CourseModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getCourseChapter(String courseId, int chapterOrder) async {
    var chapters = await sl<LearnService>().getCourseChapter(
      courseId,
      chapterOrder,
    );
    return chapters.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(CourseChapterModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> getSubchapters(String courseId, int chapterOrder) async {
    var subchapters = await sl<LearnService>().getSubchapters(
      courseId,
      chapterOrder,
    );
    return subchapters.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => SubChapterModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  ) async {
    var modules = await sl<LearnService>().getModules(
      courseId,
      chapterOrder,
      subChapterId,
    );
    return modules.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ModuleModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getQuiz(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  ) async {
    var modules = await sl<LearnService>().getQuizzes(
      courseId,
      chapterOrder,
      subChapterId,
      moduleId,
    );
    return modules.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => QuizModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> addFinishedModule(String moduleId) async {
    var modules = await sl<LearnService>().addFinishedModule(moduleId);
    return modules.fold(
      (error) {
        return Left(error);
      },
      (successMessage) {
        return Right(successMessage);
      },
    );
  }

  @override
  Future<Either> addUserScore(double score) async {
    var modules = await sl<LearnService>().addUserScore(score);
    return modules.fold(
      (error) {
        return Left(error);
      },
      (successMessage) {
        return Right(successMessage);
      },
    );
  }
}
