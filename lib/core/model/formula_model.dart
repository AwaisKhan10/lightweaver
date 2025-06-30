import 'package:lightweaver/core/model/remedy_details.dart';

class FormulaModel {
  String? id;
  String? userId;
  String? formulaName;
  String? clientName;
  String? clientEmail; // <-- add this
  String? dosage;
  String? notes;
  String? createdAt;
  bool? sent;
  List<RemedyDetailsModel>? remedies;

  FormulaModel({
    this.id,
    this.userId,
    this.formulaName,
    this.clientName,
    this.clientEmail, // <-- add here
    this.dosage,
    this.notes,
    this.createdAt,
    this.sent,
    this.remedies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'userId': userId,
      'formulaName': formulaName,
      'client': clientName,
      'clientEmail': clientEmail, // <-- save it
      'dosage': dosage,
      'notes': notes,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
      'sent': sent ?? false,
      'remedies': remedies?.map((r) => r.toJson()).toList(),
    };
  }

  factory FormulaModel.fromJson(Map<String, dynamic> json) {
    return FormulaModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      formulaName: json['formulaName'] as String?,
      clientName: json['client'] as String?,
      clientEmail: json['clientEmail'] as String?, // <-- parse it
      dosage: json['dosage'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String?,
      sent: json['sent'] as bool? ?? false,
      remedies:
          (json['remedies'] as List<dynamic>?)
              ?.map((item) => RemedyDetailsModel.fromJson(item))
              .toList(),
    );
  }
}
