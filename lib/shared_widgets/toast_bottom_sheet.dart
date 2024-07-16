import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:truck_moves/constant.dart';

showToastSheet({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onTap,
  bool isError = false,
  String? icon,
}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => ToastBottomSheet(
            title: title,
            message: message,
            onTap: onTap,
            isError: isError,
            icon: icon,
          ));
}

class ToastBottomSheet extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isError;
  final String title;
  final String message;
  final String? icon;
  const ToastBottomSheet(
      {super.key,
      this.onTap,
      required this.title,
      required this.message,
      this.isError = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 428.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.h),
            topRight: Radius.circular(10.h),
          )),
      child: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SvgPicture.asset(
            "assets/icons/${icon ?? (isError ? "fail" : "success")}.svg",
            height: 225.w,
            width: 275.w,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 20.h, bottom: 25.h, left: 16.w, right: 16.w),
            child: GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                decoration: BoxDecoration(color: primaryColor),
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                      color: const Color(0xFF010101),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
