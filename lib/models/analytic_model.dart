class AnalyticModel {
  final String id;
  final String name;

  AnalyticModel({
    required this.id,
    required this.name,
  });

  factory AnalyticModel.fromJson(Map<String, dynamic> json) {
    return AnalyticModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
