import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lightweaver/core/constants/text_style.dart';
import 'package:lightweaver/core/model/remedy_details.dart';

class AdminFlowerEssenceForm extends StatefulWidget {
  const AdminFlowerEssenceForm({super.key});

  @override
  State<AdminFlowerEssenceForm> createState() => _AdminFlowerEssenceFormState();
}

class _AdminFlowerEssenceFormState extends State<AdminFlowerEssenceForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final latinNameController = TextEditingController();
  final positiveQualitiesController = TextEditingController();
  final imbalancesController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;
  List<String> existingCategories = [];
  bool isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => isLoadingCategories = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('remedy_categories')
          .get();
      
      final categories = snapshot.docs
          .map((doc) => doc.data()['categoryName'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();
      
      setState(() {
        existingCategories = categories;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> _saveFlowerEssence() async {
    if (!_formKey.currentState!.validate()) return;

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    if (categoryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or select a category')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final remedyJson = RemedyDetailsModel(
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        category: categoryController.text.trim(), // Use selected/entered category
        latinName: latinNameController.text.trim().isEmpty
            ? null
            : latinNameController.text.trim(),
        positiveQualities: positiveQualitiesController.text.trim().isEmpty
            ? null
            : positiveQualitiesController.text.trim(),
        imbalances: imbalancesController.text.trim().isEmpty
            ? null
            : imbalancesController.text.trim(),
        imageUrl: imageUrlController.text.trim().isEmpty
            ? null
            : imageUrlController.text.trim(),
      ).toJson();

      final categoriesRef =
          FirebaseFirestore.instance.collection('remedy_categories');
      final catName = categoryController.text.trim(); // Use selected/entered category

      final querySnapshot = await categoriesRef
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
        const SnackBar(content: Text('Flower Essence saved successfully!')),
      );

      // Clear all fields
      nameController.clear();
      categoryController.clear();
      latinNameController.clear();
      positiveQualitiesController.clear();
      imbalancesController.clear();
      imageUrlController.clear();
      descriptionController.clear();
      
      // Reload categories to include new one if created
      await _loadCategories();
      
      // Navigate back to refresh the remedy list
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving Flower Essence: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    latinNameController.dispose();
    positiveQualitiesController.dispose();
    imbalancesController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flower Essence'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Center(
                child: Text(
                  'Flower Essence Details',
                  style: style20B.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              30.verticalSpace,

              // Category (Required)
              Text(
                'Category *',
                style: style16B,
              ),
              5.verticalSpace,
              isLoadingCategories
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Expanded(
                          child: existingCategories.isEmpty
                              ? TextFormField(
                                  controller: categoryController,
                                  decoration: const InputDecoration(
                                    labelText: 'Category Name',
                                    hintText: 'Enter category name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a category';
                                    }
                                    return null;
                                  },
                                )
                              : Autocomplete<String>(
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return existingCategories;
                                    }
                                    return existingCategories.where((category) =>
                                        category.toLowerCase().contains(
                                            textEditingValue.text.toLowerCase()));
                                  },
                                  onSelected: (String category) {
                                    setState(() {
                                      categoryController.text = category;
                                    });
                                  },
                                  fieldViewBuilder: (
                                    BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted,
                                  ) {
                                    // Sync the autocomplete controller with categoryController
                                    if (textEditingController.text != categoryController.text) {
                                      textEditingController.text = categoryController.text;
                                    }
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: 'Category Name',
                                        hintText: 'Select or enter category',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Please enter or select a category';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        categoryController.text = value;
                                      },
                                    );
                                  },
                                ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _loadCategories,
                          tooltip: 'Refresh Categories',
                        ),
                      ],
                    ),
              20.verticalSpace,

              // Name (Required)
              Text(
                'Name *',
                style: style16B,
              ),
              5.verticalSpace,
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Flower Essence Name',
                  hintText: 'Enter name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              20.verticalSpace,

              // Latin Name
              Text(
                'Latin Name',
                style: style16B,
              ),
              5.verticalSpace,
              TextFormField(
                controller: latinNameController,
                decoration: const InputDecoration(
                  labelText: 'Latin Name',
                  hintText: 'Enter Latin name',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              20.verticalSpace,

              // Positive Qualities
              Text(
                'Positive Qualities',
                style: style16B,
              ),
              5.verticalSpace,
              TextFormField(
                controller: positiveQualitiesController,
                decoration: const InputDecoration(
                  labelText: 'Positive Qualities',
                  hintText: 'Enter positive qualities',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              20.verticalSpace,

              // Imbalances
              Text(
                'Imbalances',
                style: style16B,
              ),
              5.verticalSpace,
              TextFormField(
                controller: imbalancesController,
                decoration: const InputDecoration(
                  labelText: 'Imbalances',
                  hintText: 'Enter imbalances',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              20.verticalSpace,

              // Image URL
              Text(
                'Image URL',
                style: style16B,
              ),
              5.verticalSpace,
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,

              // Description
              Text(
                'Description',
                style: style16B,
              ),
              5.verticalSpace,
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              30.verticalSpace,

              // Save Button
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveFlowerEssence,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 15.h,
                          ),
                        ),
                        child: Text(
                          'Save Flower Essence',
                          style: style16B.copyWith(color: Colors.white),
                        ),
                      ),
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

