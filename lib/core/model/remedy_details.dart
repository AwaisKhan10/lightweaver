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

  // Newly added fields
  String? botanicalName;
  String? elementalLightCode;
  String? spiritualThemes;
  List<String>? recommendedFor;
  List<String>? complementaryEssences;
  String? usageDosage;
  String? topicalBeauty;

  // Split emotional/physical/mental into three separate fields
  String? emotionalIssues;
  String? physicalStates;
  String? mentalConditions;

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
    this.botanicalName,
    this.elementalLightCode,
    this.spiritualThemes,
    this.recommendedFor,
    this.complementaryEssences,
    this.usageDosage,
    this.topicalBeauty,
    this.emotionalIssues,
    this.physicalStates,
    this.mentalConditions,
  });

  factory RemedyDetailsModel.fromJson(Map<String, dynamic> json) {
    return RemedyDetailsModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      symptoms: _parseStringOrList(json['symptoms'] ?? json['dosage']),
      image: json['image'] as String?,
      keywords: _parseStringOrList(json['keywords'] ?? json['keywords/Tags']),
      related: _parseStringOrList(json['related']),
      forCondition: _parseStringOrList(json['for']),
      category: json['category'] as String?,
      properties: _parseStringOrList(
        json['properties'] ?? json['essences/properties'],
      ),
      chakras: _parseStringOrList(json['chakras']),
      element: json['element'] as String?,
      createdBy: json['createdBy'] as String?,
      imageUrl: json['imageUrl'] as String?,
      accupuncture: json['accupuncture'] as String?,
      botanicalName: json['botanicalName'] as String?,
      elementalLightCode: json['elementalLightCode'] as String?,
      spiritualThemes: json['spiritualThemes'] as String?,
      recommendedFor: _parseStringOrList(json['recommendedFor']),
      complementaryEssences: _parseStringOrList(json['complementaryEssences']),
      usageDosage: json['usageDosage'] as String?,
      topicalBeauty: json['topicalBeauty'] as String?,

      /// Newly added split fields
      emotionalIssues: json['emotionalIssues'] as String?,
      physicalStates: json['physicalStates'] as String?,
      mentalConditions: json['mentalConditions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'symptoms': symptoms,
      'image': image,
      'keywords': keywords,
      'related': related,
      'for': forCondition,
      'category': category,
      'properties': properties,
      'chakras': chakras,
      'element': element,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
      'accupuncture': accupuncture,
      'botanicalName': botanicalName,
      'elementalLightCode': elementalLightCode,
      'spiritualThemes': spiritualThemes,
      'recommendedFor': recommendedFor,
      'complementaryEssences': complementaryEssences,
      'usageDosage': usageDosage,
      'topicalBeauty': topicalBeauty,

      /// New split fields
      'emotionalIssues': emotionalIssues,
      'physicalStates': physicalStates,
      'mentalConditions': mentalConditions,
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
