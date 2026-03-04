import 'package:lightweaver/core/model/remedy_details.dart';

/// Flower Essence Model
/// This model is specifically for Flower Essence category
/// It extends RemedyDetailsModel with Flower Essence specific fields:
/// - Latin Name
/// - Positive Qualities
/// - Imbalances
class FlowerEssenceModel {
  String? latinName;
  String? positiveQualities;
  String? imbalances;
  RemedyDetailsModel? remedyDetails;

  FlowerEssenceModel({
    this.latinName,
    this.positiveQualities,
    this.imbalances,
    this.remedyDetails,
  });

  /// Check if a RemedyDetailsModel is a Flower Essence
  /// This checks if the remedy has flower essence fields (latinName, positiveQualities, or imbalances)
  /// regardless of the category name
  static bool isFlowerEssence(RemedyDetailsModel? remedy) {
    if (remedy == null) return false;
    
    // Check if it has flower essence specific fields
    final hasFlowerEssenceFields = 
        (remedy.latinName != null && remedy.latinName!.isNotEmpty) ||
        (remedy.positiveQualities != null && remedy.positiveQualities!.isNotEmpty) ||
        (remedy.imbalances != null && remedy.imbalances!.isNotEmpty);
    
    // Also check if category is "flower essence" (for backward compatibility)
    final isFlowerEssenceCategory = 
        remedy.category?.toLowerCase().trim() == 'flower essence';
    
    return hasFlowerEssenceFields || isFlowerEssenceCategory;
  }

  /// Convert RemedyDetailsModel to FlowerEssenceModel
  factory FlowerEssenceModel.fromRemedyDetails(RemedyDetailsModel remedy) {
    return FlowerEssenceModel(
      latinName: remedy.latinName,
      positiveQualities: remedy.positiveQualities,
      imbalances: remedy.imbalances,
      remedyDetails: remedy,
    );
  }

  factory FlowerEssenceModel.fromJson(Map<String, dynamic> json) {
    return FlowerEssenceModel(
      latinName: json['latinName'] as String?,
      positiveQualities: json['positiveQualities'] as String?,
      imbalances: json['imbalances'] as String?,
      remedyDetails: json['remedyDetails'] != null
          ? RemedyDetailsModel.fromJson(
              json['remedyDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latinName': latinName,
      'positiveQualities': positiveQualities,
      'imbalances': imbalances,
      'remedyDetails': remedyDetails?.toJson(),
    };
  }
}

