class HealthCategory {
  final String id;
  final String name;
  final String description;

  HealthCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  // convert to dart

  factory HealthCategory.fromJson(Map<String, dynamic> json) {
    return HealthCategory(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      description: json["description"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "description": description};
  }
}
