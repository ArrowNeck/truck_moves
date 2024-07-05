import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:truck_moves/constant.dart';

class SuccessSheet {
  static show({
    required BuildContext context,
    VoidCallback? onTap,
    required String title,
    required String message,
  }) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (context) => NetworkSuccessBottomSheet(
            onTap: onTap, title: title, message: message));
  }
}

class NetworkSuccessBottomSheet extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String message;
  const NetworkSuccessBottomSheet(
      {super.key, this.onTap, required this.title, required this.message});

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
          Padding(
            padding: EdgeInsets.only(top: 7.5.h, bottom: 15.h),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.h,
                height: 5.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5.h),
                    color: const Color(0xFF7F7F7F)),
              ),
            ),
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
            "assets/icons/success.svg",
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
