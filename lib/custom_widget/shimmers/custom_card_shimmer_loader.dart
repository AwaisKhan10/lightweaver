import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lightweaver/core/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomRemedyDetailsShimmerList extends StatelessWidget {
  const CustomRemedyDetailsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // if inside another scroll view
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return const CustomRemedyDetailsCardShimmer();
      },
    );
  }
}

class CustomRemedyDetailsCardShimmer extends StatelessWidget {
  const CustomRemedyDetailsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Container(width: 60.r, height: 60.r, color: Colors.grey),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Container(width: 100.w, height: 16.h, color: Colors.grey),
                  SizedBox(height: 15.h),
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10.h),
                  Container(width: 80.w, height: 14.h, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
