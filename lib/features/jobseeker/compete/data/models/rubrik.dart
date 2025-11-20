import 'package:trajectoria/features/jobseeker/compete/domain/entities/rubrik.dart';

class RubrikItemModel {
  final String kriteria;
  final int bobot;

  RubrikItemModel({required this.kriteria, required this.bobot});

  factory RubrikItemModel.fromMap(Map<String, dynamic> map) {
    return RubrikItemModel(kriteria: map['kriteria'], bobot: map['bobot']);
  }

  Map<String, dynamic> toMap() {
    return {'kriteria': kriteria, 'bobot': bobot};
  }

  RubrikItemEntity toEntity() {
    return RubrikItemEntity(kriteria: kriteria, bobot: bobot);
  }

  factory RubrikItemModel.fromEntity(RubrikItemEntity e) {
    return RubrikItemModel(kriteria: e.kriteria, bobot: e.bobot);
  }
}
