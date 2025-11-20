class RubrikItemEntity {
  final String kriteria;
  final int bobot;

  RubrikItemEntity({required this.kriteria, required this.bobot});

  Map<String, dynamic> toMap() {
    return {"kriteria": kriteria, "bobot": bobot};
  }

  factory RubrikItemEntity.fromMap(Map<String, dynamic> map) {
    return RubrikItemEntity(
      kriteria: map["kriteria"] ?? "",
      bobot: map["bobot"] ?? 0,
    );
  }
}
