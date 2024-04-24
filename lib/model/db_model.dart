class Model {
  // Kolom pada tabel
  final int id;
  final String title;
  final String image;
  final String description;
  final String createdAt;
  final String? updatedAt;

  Model({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.createdAt,
    this.updatedAt
  });

  factory Model.fromSqfliteDatabase(Map<String, dynamic> map) => Model(
    id: map['id']?.toInt() ?? 0,
    title: map['title'] ?? '',
    image: map['image'] ?? '',
    description: map['description'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updatedAt: map['updated_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['updated_at']).toIso8601String(),
  );
}