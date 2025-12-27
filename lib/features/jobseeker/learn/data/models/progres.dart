import 'package:trajectoria/features/jobseeker/learn/domain/entities/progres.dart';

class ProgresModel {
  final String courseId;
  final int valueProgres;

  ProgresModel({required this.courseId, required this.valueProgres});

  factory ProgresModel.fromMap(Map<String, dynamic> map) {
    return ProgresModel(
      courseId: map['course_id'] ?? '',
      valueProgres: map['value_progres'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'course_id': courseId,
    'value_progres': valueProgres,
  };

  ProgresEntity toEntity() =>
      ProgresEntity(courseId: courseId, valueProgres: valueProgres);

  factory ProgresModel.fromEntity(ProgresEntity entity) => ProgresModel(
    courseId: entity.courseId,
    valueProgres: entity.valueProgres,
  );
}
