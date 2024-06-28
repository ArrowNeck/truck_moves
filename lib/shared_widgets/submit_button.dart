import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/config.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final double? height;
  final double? width;
  final double? marginH;
  final double? marginW;
  const SubmitButton(
      {super.key,
      required this.onTap,
      required this.label,
      this.height,
      this.width,
      this.marginH,
      this.marginW});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width ?? 380.w,
        height: height ?? 50.h,
        margin: EdgeInsets.symmetric(
            vertical: marginH ?? 0, horizontal: marginW ?? 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.h),
            color: AppColors.primaryColor),
        child: Text(
          label,
          style: TextStyle(
              color: const Color(0xFF010101),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
