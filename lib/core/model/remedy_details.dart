class RemedyDetailsModel {
  String? name;
  String? description;
  List<String>? symptoms;
  String? image;
  String? imageUrl;
  List<String>? keywords;
  List<String>? related;
  List<String>? forCondition;
  String? category;
  List<String>? properties;
  List<String>? chakras;
  String? element;
  String? createdBy;
  String? accupuncture;
  RemedyDetailsModel({
    this.name,
    this.description,
    this.symptoms,
    this.image,
    this.keywords,
    this.related,
    this.forCondition,
    this.category,
    this.properties,
    this.chakras,
    this.element,
    this.createdBy,
    this.imageUrl,
    this.accupuncture,
  });

  factory RemedyDetailsModel.fromJson(Map<String, dynamic> json) {
    return RemedyDetailsModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      symptoms: _parseStringOrList(json['dosage']),
      image: json['image'] as String?,
      keywords: _parseStringOrList(json['keywords/Tags']),
      related: _parseStringOrList(json['related']),
      forCondition: _parseStringOrList(json['for']),
      category: json['category'] as String?,
      properties: _parseStringOrList(json['essences/properties']),
      chakras: _parseStringOrList(json['chakras']),
      element: json['element'] as String?,
      createdBy: json['createdBy'] as String?,
      imageUrl: json['imageUrl'] as String?,
      accupuncture: json['accupuncture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'dosage': symptoms,
      'image': image,
      'keywords/Tags': keywords,
      'related': related,
      'for': forCondition,
      'category': category,
      'essences/properties': properties,
      'chakras': chakras,
      'element': element,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
      'accupuncture': accupuncture,
    };
  }

  /// Helper method to safely parse String or List into List<String>
  static List<String>? _parseStringOrList(dynamic input) {
    if (input == null) return null;

    if (input is String) {
      // Handle comma-separated strings
      return input
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (input is List) {
      return input.map((e) => e.toString()).toList();
    }

    return null;
  }
}
