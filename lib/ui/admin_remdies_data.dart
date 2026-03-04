import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lightweaver/core/constants/text_style.dart';
import 'package:lightweaver/core/model/remedy_details.dart';

class AdminRemedyForm extends StatefulWidget {
  const AdminRemedyForm({super.key});

  @override
  State<AdminRemedyForm> createState() => _AdminRemedyFormState();
}

class _AdminRemedyFormState extends State<AdminRemedyForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final accupunctureController = TextEditingController();
  final botanicalNameController = TextEditingController();
  final elementalLightCodeController = TextEditingController();
  final spiritualThemesController = TextEditingController();
  final usageDosageController = TextEditingController();
  final topicalBeautyController = TextEditingController();
  final emotionalController = TextEditingController();
  final physicalController = TextEditingController();
  final mentalController = TextEditingController();
  final physicalStatesEnergeticInfluenceController = TextEditingController();
  final emotionalSymptomsController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<String> complementaryEssences = [];
  final List<String> recommendedFor = [];
  final List<String> keywords = [];

  bool isLoading = false; // ✅ Loader state

  void _addToListDialog(String title, List<String> targetList) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Add $title"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter $title item"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      targetList.add(controller.text.trim());
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  Future<void> _saveRemedy() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true); // ✅ Start loading

    try {
      final remedyJson =
          RemedyDetailsModel(
            name: nameController.text,
            description: descriptionController.text,
            category: categoryController.text,
            accupuncture: accupunctureController.text,
            botanicalName: botanicalNameController.text,
            elementalLightCode: elementalLightCodeController.text,
            spiritualThemes: spiritualThemesController.text,
            usageDosage: usageDosageController.text,
            topicalBeauty: topicalBeautyController.text,
            emotionalIssues: emotionalController.text,
            physicalStates: physicalController.text,
            mentalConditions: mentalController.text,
            physicalStatesEnergeticInfluence: physicalStatesEnergeticInfluenceController.text,
            emotionalSymptoms: emotionalSymptomsController.text,
            complementaryEssences: complementaryEssences,
            recommendedFor: recommendedFor,
            keywords: keywords,
          ).toJson();

      final categoriesRef = FirebaseFirestore.instance.collection(
        'remedy_categories',
      );
      final catName = categoryController.text.trim();

      final querySnapshot =
          await categoriesRef
              .where('categoryName', isEqualTo: catName)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        await categoriesRef.add({
          'categoryName': catName,
          'remedies': [remedyJson],
        });
      } else {
        final categoryDoc = querySnapshot.docs.first.reference;
        await categoryDoc.update({
          'remedies': FieldValue.arrayUnion([remedyJson]),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remedy saved successfully!')),
      );

      /// ✅ Clear all fields
      nameController.clear();
      categoryController.clear();
      accupunctureController.clear();
      botanicalNameController.clear();
      elementalLightCodeController.clear();
      spiritualThemesController.clear();
      usageDosageController.clear();
      topicalBeautyController.clear();
      emotionalController.clear();
      physicalController.clear();
      mentalController.clear();
      physicalStatesEnergeticInfluenceController.clear();
      emotionalSymptomsController.clear();
      descriptionController.clear();

      setState(() {
        complementaryEssences.clear();
        recommendedFor.clear();
        keywords.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving remedy: $e')));
    } finally {
      setState(() => isLoading = false); // ✅ Stop loading
    }
  }

  Widget _buildListDisplay(String title, List<String> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$title (${list.length})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addToListDialog(title, list),
            ),
          ],
        ),
        Wrap(
          children:
              list
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      onDeleted: () {
                        setState(() => list.remove(item));
                      },
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Remedy Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              20.verticalSpace,
              Text("Category Name", style: style18B),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Table of Contents", style: style18B),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Botanical Name", style: style18B),
              TextFormField(
                controller: botanicalNameController,
                decoration: const InputDecoration(
                  labelText: 'Botanical Name',
                  border: OutlineInputBorder(),
                ),
              ),

              20.verticalSpace,
              Text("Elemental Light Code", style: style18B),
              TextFormField(
                controller: elementalLightCodeController,
                decoration: const InputDecoration(
                  labelText: 'Elemental Light Code',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Spiritual Themes	", style: style18B),

              TextFormField(
                controller: spiritualThemesController,
                decoration: const InputDecoration(
                  labelText: 'Spiritual Themes',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,

              Text("Recommended For", style: style18B),
              _buildListDisplay('Recommended For', recommendedFor),
              20.verticalSpace,
              Text("Complementary Essences", style: style18B),
              _buildListDisplay(
                'Complementary Essences',
                complementaryEssences,
              ),

              20.verticalSpace,
              Text("Usage / Dosage", style: style18B),
              TextFormField(
                controller: usageDosageController,
                decoration: const InputDecoration(
                  labelText: 'Usage / Dosage',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Acupuncture site", style: style18B),
              TextFormField(
                controller: accupunctureController,
                decoration: const InputDecoration(
                  labelText: 'Accupuncture',
                  border: OutlineInputBorder(),
                ),
              ),

              20.verticalSpace,
              Text("Emotional Issues", style: style18B),
              TextFormField(
                controller: emotionalController,
                decoration: const InputDecoration(
                  labelText: 'Emotional Issues',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Physical States/Energetic Influence", style: style18B),
              TextFormField(
                controller: physicalStatesEnergeticInfluenceController,
                decoration: const InputDecoration(
                  labelText: 'Physical States/Energetic Influence',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Emotional Symptoms", style: style18B),
              TextFormField(
                controller: emotionalSymptomsController,
                decoration: const InputDecoration(
                  labelText: 'Emotional Symptoms',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Physical States", style: style18B),
              TextFormField(
                controller: physicalController,
                decoration: const InputDecoration(
                  labelText: 'Physical States',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Mental/Spiritual Blocks", style: style18B),
              TextFormField(
                controller: mentalController,
                decoration: const InputDecoration(
                  labelText: 'Mental/Spiritual Blocks',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              Text("Topical Beauty", style: style18B),
              TextFormField(
                controller: topicalBeautyController,
                decoration: const InputDecoration(
                  labelText: 'Topical Beauty',
                  border: OutlineInputBorder(),
                ),
              ),
              // 20.verticalSpace,
              // TextFormField(
              //   controller: mentalController,
              //   decoration: const InputDecoration(
              //     labelText: 'Mental Conditions',
              //     border: OutlineInputBorder(),
              //   ),
              // ),

              // 20.verticalSpace,
              // _buildListDisplay('Keywords', keywords),
              // 20.verticalSpace,

              // TextFormField(
              //   controller: descriptionController,
              //   decoration: const InputDecoration(
              //     labelText: 'Description',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 30),

              // ✅ Show loader instead of button while saving
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _saveRemedy,
                    child: const Text('Save Remedy'),
                  ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
