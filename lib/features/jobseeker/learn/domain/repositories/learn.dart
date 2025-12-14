import 'package:dartz/dartz.dart';

abstract class LearnRepository {
  Future<Either> getCourses();
  Future<Either> getAllCourseChapters(String courseId);
  Future<Either> getCourseChapter(String courseId, int chapterOrder);
  Future<Either> getSubchapters(String courseId, int chapterOrder);
  Future<Either> getModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  );
  Future<Either> getQuiz(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  );
  Future<Either> addFinishedModule(String moduleId);
  Future<Either> addFinishedSubchapter(String subchapterId);
  Future<Either> addUserScore(double score);
  Future<Either> addFinishedChapter(String chapterId);
  Future<Either> addOnprogresChapter(String chapterId);
}
