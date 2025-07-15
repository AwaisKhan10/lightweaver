// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lightweaver/core/constants/app_assest.dart';
import 'package:lightweaver/core/constants/colors.dart';
import 'package:lightweaver/core/constants/text_style.dart';
import 'package:lightweaver/core/model/remedies_categories.dart';

class CustomRemedyDetailsCardWidget extends StatelessWidget {
  final RemedyCategoryModel remedyCategoryModel;
  final bool isSelected;
  final VoidCallback onTap;
  final int index; // Now required and non-nullable

  CustomRemedyDetailsCardWidget({
    super.key,
    required this.remedyCategoryModel,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final remedy = remedyCategoryModel.remedies?[index];

    if (remedy == null) return const SizedBox.shrink(); // Prevent error

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          color: isSelected ? primaryColor : whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundImage: AssetImage(remedy.image ?? AppAssets().profile),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Text(
                    remedy.name ?? 'No Name',
                    style: style16B.copyWith(
                      color: isSelected ? whiteColor : primaryColor,
                    ),
                  ),
                  15.verticalSpace,
                  if (remedy.forCondition != null &&
                      remedy.forCondition!.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'for: ',
                          style: style12.copyWith(
                            color: isSelected ? whiteColor : darkGreyColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            remedy.forCondition!.join(', '),
                            style: style14.copyWith(
                              color: isSelected ? whiteColor : darkGreyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                  ],
                  if (remedy.keywords != null &&
                      remedy.keywords!.isNotEmpty) ...[
                    Wrap(
                      children: [
                        Text(
                          'Key words:',
                          style: style12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isSelected ? whiteColor : lightGreyColor2,
                          ),
                        ),
                        Text(
                          " ${remedy.keywords!.join(', ')}",
                          style: style14.copyWith(
                            color: isSelected ? whiteColor : lightGreyColor2,
                          ),
                        ),
                      ],
                    ),
                  ],
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View details',
                      style: style14B.copyWith(
                        color: isSelected ? whiteColor : primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
