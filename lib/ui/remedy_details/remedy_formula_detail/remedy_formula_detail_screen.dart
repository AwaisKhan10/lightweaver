// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lightweaver/core/constants/app_assest.dart';
import 'package:lightweaver/core/constants/colors.dart';
import 'package:lightweaver/core/constants/text_style.dart';
import 'package:lightweaver/core/enums/view_state_model.dart';
import 'package:lightweaver/core/model/remedy_details.dart';
import 'package:lightweaver/ui/notifications/notification_screen.dart';
import 'package:lightweaver/ui/remedy_details/remedy_details_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class RemedyFormulaDetailScreen extends StatelessWidget {
  final RemedyDetailsModel? remedyDetailsModel;
  RemedyFormulaDetailScreen({required this.remedyDetailsModel});
  @override
  Widget build(BuildContext context) {
    print("remedyDetailsModel=> ${remedyDetailsModel.toString()}");
    return Consumer<RemedyDetailsViewModel>(
      builder:
          (context, model, child) => ModalProgressHUD(
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              body:
                  remedyDetailsModel == null
                      ? Center(
                        child: Text(
                          'No Remedy Details Available',
                          style: style20B.copyWith(color: blackColor),
                        ),
                      )
                      : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Image.asset(AppAssets().remedy2),
                                Positioned(
                                  left: 15,
                                  top: 30,
                                  child: GestureDetector(
                                    onTap: () {
                                      print('rout to notification screen');
                                      Get.to(NotificationScreen());
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: primaryColor,
                                      radius: 15,
                                      child: GestureDetector(
                                        onTap: () {
                                          navigator!.pop();
                                        },
                                        child: CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: primaryColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_back,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 15,
                                  top: 30,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(NotificationScreen());
                                    },
                                    child: Image.asset(
                                      AppAssets().notificationIcon,
                                      scale: 4,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  top: 200,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(NotificationScreen());
                                    },
                                    child: Text(
                                      'Remedy Details',
                                      style: style25B.copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            firstTab(remedyDetailsModel!),
                          ],
                        ),
                      ),
            ),
          ),
    );
  }
}

///
///  first tab
///
firstTab(RemedyDetailsModel? remedyDetails) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${remedyDetails!.name}' ?? "",
                    style: style18B.copyWith(color: primaryColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  20.verticalSpacingDiagonal,

                  remedyDetails.botanicalName!.isNotEmpty
                      ?
                      /// Botanical Name
                      Text(
                        'Botanical Name',
                        style: style16B.copyWith(color: primaryColor),
                      )
                      : SizedBox(),
                  5.verticalSpace,

                  remedyDetails.botanicalName!.isNotEmpty
                      ? Text(remedyDetails.botanicalName ?? "-", style: style12)
                      : SizedBox(),
                  remedyDetails.elementalLightCode!.isEmpty
                      ? 20.verticalSpace
                      : SizedBox(),

                  remedyDetails.elementalLightCode!.isNotEmpty
                      ?
                      /// Elemental Light Code
                      Text(
                        'Elemental Light Code',
                        style: style16B.copyWith(color: primaryColor),
                      )
                      : SizedBox(),
                  remedyDetails.elementalLightCode!.isNotEmpty
                      ? 5.verticalSpace
                      : SizedBox(),
                  remedyDetails.elementalLightCode!.isNotEmpty
                      ? Text(remedyDetails.elementalLightCode ?? "-")
                      : SizedBox(),
                  remedyDetails.elementalLightCode!.isEmpty
                      ? 20.verticalSpace
                      : SizedBox(),
                ],
              ),
            ),
            CircleAvatar(
              radius: 80.r,
              backgroundColor: primaryColor,
              backgroundImage: NetworkImage(remedyDetails.imageUrl ?? ""),
            ),
          ],
        ),

        /// Spiritual Themes
        Text('Spiritual Themes', style: style16B.copyWith(color: primaryColor)),
        5.verticalSpace, Text(remedyDetails.spiritualThemes ?? "-"),
        16.verticalSpace,

        /// Recommended For
        Text('Recommended For', style: style16B.copyWith(color: primaryColor)),
        5.verticalSpace,
        (remedyDetails.recommendedFor?.isEmpty ?? true)
            ? Text("-")
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  remedyDetails.recommendedFor!.map((item) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ", style: style14.copyWith(color: blackColor)),
                        Expanded(
                          child: Text(
                            item,
                            style: style14.copyWith(color: blackColor),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),

        /// Complementary Essences
        Text(
          'Complementary Essences',
          style: style16B.copyWith(color: primaryColor),
        ),
        5.verticalSpace,
        (remedyDetails.complementaryEssences?.isEmpty ?? true)
            ? Text("-")
            : Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  remedyDetails.complementaryEssences!.map((item) {
                    return Chip(
                      label: Text(item),
                      backgroundColor: Colors.grey.shade200,
                    );
                  }).toList(),
            ),

        20.verticalSpace,

        /// Usage/Dosage
        Text('Usage/Dosage', style: style16B.copyWith(color: primaryColor)),
        5.verticalSpace,
        Text(remedyDetails.usageDosage ?? "-"),
        16.verticalSpace,

        /// Acupuncture site
        Text('Acupuncture site', style: style16B.copyWith(color: primaryColor)),
        5.verticalSpace,
        Text(remedyDetails.accupuncture ?? "-"),
        16.verticalSpace,

        /// Emotional/Physical/Mental
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emotional/Physical/Mental',
              style: style16B.copyWith(color: primaryColor),
            ),
            8.verticalSpace,
            if (remedyDetails.emotionalIssues != null &&
                remedyDetails.emotionalIssues!.isNotEmpty)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Emotional Issues: ',
                      style: style14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    TextSpan(
                      text: remedyDetails.emotionalIssues!,
                      style: style14.copyWith(
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            if (remedyDetails.physicalStates != null &&
                remedyDetails.physicalStates!.isNotEmpty) ...[
              8.verticalSpace,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Physical States/Energetic Influence: ',
                      style: style14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    TextSpan(
                      text: remedyDetails.physicalStates!,
                      style: style14.copyWith(
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (remedyDetails.mentalConditions != null &&
                remedyDetails.mentalConditions!.isNotEmpty) ...[
              8.verticalSpace,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Mental/Spiritual Conditions: ',
                      style: style14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    TextSpan(
                      text: remedyDetails.mentalConditions!,
                      style: style14.copyWith(
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        // 5.verticalSpace,
        // Text(remedyDetails.emotionalPhysicalMental?.join(", ") ?? "-"),
        20.verticalSpace,

        /// Topical / Beauty
        Text('Topical / Beauty', style: style16B.copyWith(color: primaryColor)),
        5.verticalSpace,
        Text(remedyDetails.topicalBeauty ?? "-"),
        20.verticalSpace,
        // Text('Start Formula', style: style14B.copyWith(color: primaryColor)),
        // 10.verticalSpace,
        // Text(
        //   textAlign: TextAlign.start,
        //   '${remedyDetails!.description}' ?? '',
        //   style: style12.copyWith(color: lightGreyColor),
        // ),
        // 20.verticalSpace,

        // remedyDetails.image != null && remedyDetails.image!.isNotEmpty
        //     ? ClipRRect(
        //       borderRadius: BorderRadiusGeometry.circular(20),
        //       child: Image.network(
        //         remedyDetails.image!,
        //         fit: BoxFit.cover,
        //         height: 400,
        //         width: double.infinity,
        //         loadingBuilder: (context, child, loadingProgress) {
        //           if (loadingProgress == null) return child;
        //           return Shimmer.fromColors(
        //             baseColor: Colors.grey.shade300,
        //             highlightColor: Colors.grey.shade100,
        //             child: Container(
        //               height: 400,
        //               width: double.infinity,
        //               color: Colors.white,
        //             ),
        //           );
        //         },
        //         errorBuilder: (context, error, stackTrace) {
        //           return Center(child: Icon(Icons.image, size: 40));
        //         },
        //       ),
        //     )
        //     : Shimmer.fromColors(
        //       baseColor: Colors.grey.shade300,
        //       highlightColor: Colors.grey.shade100,
        //       child: Container(
        //         height: 300,
        //         width: double.infinity,
        //         color: Colors.white,
        //       ),
        //     ),

        // 20.verticalSpace,
        // Text('Acupuncture ', style: style14B.copyWith(color: primaryColor)),
        // 10.verticalSpace,
        // Text(
        //   remedyDetails.accupuncture ?? '',
        //   style: style12.copyWith(color: blackColor),
        //   textAlign:
        //       TextAlign.justify, // optional: for neat paragraph formatting
        // ),

        // 20.verticalSpace,
        // Text('Dosage ', style: style14B.copyWith(color: primaryColor)),
        // 10.verticalSpace,
        // (remedyDetails!.symptoms?.isEmpty ?? true)
        //     ? SizedBox()
        //     : _customTabs(
        //       index: 0,

        //       title: '${remedyDetails.symptoms}' ?? "",
        //       onTap: () {},
        //     ),
        // 20.verticalSpace,
        // Wrap(
        //   children: [
        //     Text('Created By: ', style: style14B.copyWith(color: primaryColor)),
        //     Text(
        //       ' ${remedyDetails!.createdBy ?? ""}',
        //       style: style14.copyWith(color: blackColor),
        //     ),
        //   ],
        // ),
        // 20.verticalSpace,
        // Text('Properties', style: style14B.copyWith(color: primaryColor)),
        // 10.verticalSpace,
        // (remedyDetails.properties?.isEmpty ?? true)
        //     ? SizedBox()
        //     : SizedBox(
        //       height: 50,
        //       child: ListView.builder(
        //         scrollDirection: Axis.horizontal,
        //         shrinkWrap: true,
        //         itemCount: remedyDetails.properties!.length,
        //         itemBuilder: (context, index) {
        //           return _associatedChakras(
        //             '${remedyDetails.properties![index]}',
        //             darkBlueColor,
        //           );
        //         },
        //       ),
        //     ),

        // 20.verticalSpace,
        // Text('GemElixirs', style: style14B.copyWith(color: primaryColor)),
        // 10.verticalSpace,
        // (remedyDetails.chakras?.isEmpty ?? true)
        //     ? SizedBox()
        //     : SizedBox(
        //       height: 50,
        //       child: ListView.builder(
        //         shrinkWrap: true,
        //         scrollDirection: Axis.horizontal,
        //         itemCount: remedyDetails.chakras!.length,
        //         itemBuilder: (context, index) {
        //           return _associatedChakras(
        //             '${remedyDetails.chakras![index]}',
        //             darkPurpleColor,
        //           );
        //         },
        //       ),
        //     ),

        // 20.verticalSpace,

        // Text('KeyWords ', style: style14B.copyWith(color: primaryColor)),
        if (remedyDetails.keywords != null &&
            remedyDetails.keywords!.isNotEmpty) ...[
          Text(
            'Keywords:',
            style: style16B.copyWith(
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          8.verticalSpace,
          Text(
            remedyDetails.keywords!.join(', '),
            style: style14.copyWith(color: blackColor),
          ),

          90.verticalSpace,
        ],

        ///
        ///      related remedies section
        ///
        // Text('Related Remedies', style: style14.copyWith(color: primaryColor)),

        // (remedyDetails.related?.isEmpty ?? true)
        //     ? SizedBox()
        //     : SizedBox(
        //       height: 60,
        //       child: ListView.builder(
        //         scrollDirection: Axis.horizontal,
        //         shrinkWrap: true,
        //         itemCount: remedyDetails.related!.length,
        //         itemBuilder: (context, index) {
        //           return _relatedRemedies(
        //             AppAssets().profile,
        //             '${remedyDetails.related![index]}',
        //           );
        //         },
        //       ),
        //     ),
      ],
    ),
  );
}

// ///
// ///   related remedies
// ///
// Container _relatedRemedies(String imageUrl, String title) {
//   return Container(
//     margin: EdgeInsets.all(10),
//     alignment: Alignment.centerLeft,

//     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(9999),
//       color: whiteColor,
//       boxShadow: [
//         BoxShadow(
//           blurRadius: 10,
//           spreadRadius: 2,
//           offset: Offset(0, 1),
//           color: Color(0xffAFAFAF).withOpacity(0.25),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           backgroundColor: whiteColor,
//           radius: 10.r,
//           backgroundImage: AssetImage(imageUrl),
//         ),
//         4.horizontalSpace,
//         Text(title, style: style12),
//       ],
//     ),
//   );
// }
