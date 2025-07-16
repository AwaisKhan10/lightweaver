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
        Text(
          '${remedyDetails!.name}' ?? "",
          style: style18B.copyWith(color: primaryColor),
        ),
        20.verticalSpacingDiagonal,
        Text('Start Formula', style: style14B.copyWith(color: primaryColor)),
        10.verticalSpace,
        Text(
          textAlign: TextAlign.start,
          '${remedyDetails!.description}' ?? '',
          style: style12.copyWith(color: lightGreyColor),
        ),
        20.verticalSpace,

        Text('Symptoms ', style: style14B.copyWith(color: primaryColor)),
        10.verticalSpace,
        (remedyDetails!.symptoms?.isEmpty ?? true)
            ? SizedBox()
            : _customTabs(
              index: 0,

              title: '${remedyDetails.symptoms}' ?? "",
              onTap: () {},
            ),
        20.verticalSpace,
        Wrap(
          children: [
            Text('Created By: ', style: style14B.copyWith(color: primaryColor)),
            Text(
              ' ${remedyDetails!.createdBy ?? ""}',
              style: style14.copyWith(color: blackColor),
            ),
          ],
        ),
        20.verticalSpace,
        Text('Properties', style: style14B.copyWith(color: primaryColor)),
        10.verticalSpace,
        (remedyDetails.properties?.isEmpty ?? true)
            ? SizedBox()
            : SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: remedyDetails.properties!.length,
                itemBuilder: (context, index) {
                  return _associatedChakras(
                    '${remedyDetails.properties![index]}',
                    darkBlueColor,
                  );
                },
              ),
            ),

        20.verticalSpace,
        Text(
          'Associated Chakras',
          style: style14B.copyWith(color: primaryColor),
        ),
        10.verticalSpace,
        (remedyDetails.chakras?.isEmpty ?? true)
            ? SizedBox()
            : SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: remedyDetails.chakras!.length,
                itemBuilder: (context, index) {
                  return _associatedChakras(
                    '${remedyDetails.chakras![index]}',
                    darkPurpleColor,
                  );
                },
              ),
            ),

        20.verticalSpace,

        // Text('KeyWords ', style: style14B.copyWith(color: primaryColor)),
        if (remedyDetails.keywords != null &&
            remedyDetails.keywords!.isNotEmpty) ...[
          Wrap(
            children: [
              Text(
                'Key words:',
                style: style14B.copyWith(
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
              Text(
                " ${remedyDetails.keywords!.join(', ')}",
                style: style14.copyWith(color: blackColor),
              ),
            ],
          ),
        ],
        30.verticalSpace,

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

///
///  associated charks  ///   also for properties section
///
Container _associatedChakras(String title, Color backgroundColor) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(title, style: style12.copyWith(color: whiteColor)),
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

///
///    top tab item
///
Widget _customTabs({
  required int index,

  required String title,
  required final VoidCallback onTap,
}) {
  return Text("$title" ?? "", style: style14.copyWith(color: blackColor));
}
