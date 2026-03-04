import 'package:lightweaver/core/model/remedy_details.dart';

/// BACH ACUPUNCTURE Model
/// This model is specifically for BACH ACUPUNCTURE category
/// It extends RemedyDetailsModel with BACH ACUPUNCTURE specific fields:
/// - Description
/// - Acupuncture Point
/// - Synthesis
/// - Plant Description
class BachAcupunctureModel {
  String? description;
  String? acupuncturePoint;
  String? synthesis;
  String? plantDescription;
  RemedyDetailsModel? remedyDetails;

  BachAcupunctureModel({
    this.description,
    this.acupuncturePoint,
    this.synthesis,
    this.plantDescription,
    this.remedyDetails,
  });

  /// Check if a RemedyDetailsModel is a BACH ACUPUNCTURE
  static bool isBachAcupuncture(RemedyDetailsModel? remedy) {
    if (remedy == null) return false;
    return remedy.category?.toLowerCase().trim() == 'bach acupuncture';
  }

  /// Convert RemedyDetailsModel to BachAcupunctureModel
  factory BachAcupunctureModel.fromRemedyDetails(RemedyDetailsModel remedy) {
    return BachAcupunctureModel(
      description: remedy.description,
      acupuncturePoint: remedy.acupuncturePoint,
      synthesis: remedy.synthesis,
      plantDescription: remedy.plantDescription,
      remedyDetails: remedy,
    );
  }

  factory BachAcupunctureModel.fromJson(Map<String, dynamic> json) {
    return BachAcupunctureModel(
      description: json['description'] as String?,
      acupuncturePoint: json['acupuncturePoint'] as String?,
      synthesis: json['synthesis'] as String?,
      plantDescription: json['plantDescription'] as String?,
      remedyDetails: json['remedyDetails'] != null
          ? RemedyDetailsModel.fromJson(
              json['remedyDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'acupuncturePoint': acupuncturePoint,
      'synthesis': synthesis,
      'plantDescription': plantDescription,
      'remedyDetails': remedyDetails?.toJson(),
    };
  }
}

