// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:lightweaver/core/enums/view_state_model.dart';
import 'package:lightweaver/core/model/formula_model.dart';
import 'package:lightweaver/core/others/base_view_model.dart';
import 'package:lightweaver/core/services/db_services.dart';
import 'package:lightweaver/custom_widget/snack_bar/custom_snack_bar.dart';
import 'package:lightweaver/locator.dart';
import 'package:lightweaver/ui/root_screen/root_screen.dart';
import 'package:pdf/widgets.dart' as pw;

class FormulaHistoryViewModel extends BaseViewModel {
  final _db = locator<DatabaseServices>();
  final _storage = FirebaseStorage.instance;

  ///
  /// Generate PDF & Upload
  ///
  Future<String?> generateAndUploadPDF(FormulaModel formula) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build:
              (context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Formula Name: ${formula.formulaName ?? ""}",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text("Client Name: ${formula.clientName ?? ""}"),
                  pw.Text("Client Email: ${formula.clientEmail ?? ""}"),
                  pw.Text("Dosage: ${formula.dosage ?? ""}"),
                  pw.Text("Notes: ${formula.notes ?? ""}"),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Remedies:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  ...?formula.remedies?.map(
                    (r) => pw.Text("- ${r.name ?? ""}"),
                  ),
                ],
              ),
        ),
      );

      // Convert PDF to bytes
      Uint8List pdfBytes = await pdf.save();

      // Upload to Firebase Storage
      String fileName = 'formula_${formula.id}.pdf';
      final ref = _storage.ref().child('formulas/$fileName');

      final uploadTask = await ref.putData(pdfBytes);

      final url = await uploadTask.ref.getDownloadURL();
      print('✅ PDF uploaded. URL: $url');
      return url;
    } catch (e, s) {
      print('❌ Exception @generateAndUploadPDF: $e');
      print(s.toString());
      return null;
    }
  }

  ///
  /// Send Email with PDF link
  ///
  Future<void> sendEmailWithPdf({required FormulaModel formula}) async {
    setState(ViewState.busy);
    // await _db.updateFormulaSentStatus(formula.id!);
    // Step 1: Generate & upload PDF
    final pdfUrl = await generateAndUploadPDF(formula);
    if (pdfUrl == null) {
      customSnackbar(title: "Failed", message: "❌ PDF upload failed.");

      return;
    }

    // Step 2: Send Email via EmailJS
    const serviceId = 'service_prr6anp';
    const templateId = 'template_mq7poy9';
    const userId = 'bEn5MsbL6D3Fzte-F';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': formula.clientName ?? "",
          'user_email': formula.clientEmail ?? "",
          'message': "Here is your custom formula PDF: $pdfUrl",
        },
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Email sent successfully');
      customSnackbar(title: "Email Sent", message: "✅ Email sent successfully");

      // Step 3: Update Firestore sent status
      if (formula.id != null) {
        await _db.updateFormulaSentStatus(formula.id!);
      }
      print("formula update status==> ${formula.id}");

      Get.offAll(() => RootScreen(selectedScreen: 2));
    } else {
      print('❌ Failed to send email: ${response.body}');
      customSnackbar(title: "Failed", message: "❌ Failed to send email.");
    }
    setState(ViewState.idle);
  }
}
