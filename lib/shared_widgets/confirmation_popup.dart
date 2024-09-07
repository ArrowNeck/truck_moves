import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/constant.dart';

class ConfirmationPopup extends StatelessWidget {
  final String title;
  final String message;
  final String leftBtnText;
  final String rightBtnText;
  final Color? rightBtnColor;
  final VoidCallback? onLeftTap;
  final VoidCallback onRightTap;
  const ConfirmationPopup(
      {super.key,
      this.onLeftTap,
      required this.onRightTap,
      required this.title,
      required this.message,
      required this.leftBtnText,
      required this.rightBtnText,
      this.rightBtnColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 428.w,
            ),
            Container(
              width: 350.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(15.w)),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: primaryColor.withOpacity(0.4),
                            customBorder: const StadiumBorder(),
                            onTap: () {
                              Navigator.pop(context);
                              if (onLeftTap != null) {
                                onLeftTap!();
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: primaryColor, width: 1.5.w)),
                                width: 110.w,
                                height: 45.h,
                                child: SizedBox(
                                  width: 90.w,
                                  height: 30.h,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: Text(
                                      leftBtnText,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: primaryColor.withOpacity(0.4),
                            customBorder: const StadiumBorder(),
                            onTap: () {
                              Navigator.pop(context);
                              onRightTap();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: rightBtnColor ?? primaryColor,
                                    border: Border.all(
                                        color: rightBtnColor ?? primaryColor,
                                        width: 1.5.w)),
                                width: 110.w,
                                height: 45.h,
                                child: SizedBox(
                                  width: 90.w,
                                  height: 30.h,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: Text(
                                      rightBtnText,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: rightBtnColor != null
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
