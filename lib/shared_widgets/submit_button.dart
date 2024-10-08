import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/constant.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final double? height;
  final double? width;
  final double? marginH;
  final double? marginW;
  final double? radius;
  final Color? color;
  final Color? labelColor;
  const SubmitButton({
    super.key,
    required this.onTap,
    required this.label,
    this.height,
    this.width,
    this.marginH,
    this.marginW,
    this.radius,
    this.color,
    this.labelColor,
  });

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
          borderRadius: BorderRadius.circular(radius ?? 25.h),
          color: color ?? primaryColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor ?? const Color(0xFF010101),
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
