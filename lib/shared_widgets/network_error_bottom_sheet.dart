import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/config.dart';
import 'package:truck_moves/providers/auth_provider.dart';
import 'package:truck_moves/ui/landing/login_page/login_page.dart';
import 'package:truck_moves/utils/cache_manager.dart';
import 'package:truck_moves/utils/custom_http.dart';
import 'package:truck_moves/utils/exceptions/network_exceptions.dart';

class ErrorSheet {
  static show(
      {required BuildContext context,
      required NetworkExceptions exception,
      VoidCallback? onTap,
      String? title,
      String? message,
      bool login = false}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (context) => NetworkErrorBottomSheet(
              exception: exception,
              onTap: onTap,
              title: title,
              message: message,
              login: login,
              unAuth: NetworkExceptions.getErrorMessage(exception).first ==
                  "Session Expired",
            ));
  }
}

class NetworkErrorBottomSheet extends StatelessWidget {
  final NetworkExceptions exception;
  final VoidCallback? onTap;
  final String? title;
  final String? message;
  final bool login;
  final bool unAuth;
  const NetworkErrorBottomSheet(
      {super.key,
      required this.exception,
      this.onTap,
      this.title,
      this.message,
      this.login = false,
      required this.unAuth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430.w,
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
            title ??
                ((login && unAuth)
                    ? "Access Denied"
                    : NetworkExceptions.getErrorMessage(exception).first),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SvgPicture.asset(
            NetworkExceptions.getErrorMessage(exception)[2],
            height: 225.w,
            width: 275.w,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              message ??
                  ((login && unAuth)
                      ? "The email or password you entered is incorrect. Please check your credentials and try again"
                      : NetworkExceptions.getErrorMessage(exception)[1]),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (!login && unAuth)
            Padding(
              padding: EdgeInsets.only(
                  top: 20.h, bottom: 25.h, left: 16.w, right: 16.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  CacheManger.removeDriver().then((_) {
                    CustomHttp.setInterceptor(token: null);
                    context.read<AuthProvider>().removeDriver();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  decoration: BoxDecoration(color: AppColors.primaryColor),
                  child: Text(
                    "Re-Login",
                    style: TextStyle(
                        color: const Color(0xFF010101),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.h,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(0.h),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 2),
                        ),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                              color: const Color(0xFF010101),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  if (onTap != null && !unAuth) ...[
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onTap!();
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(0.h),
                              color: AppColors.primaryColor),
                          child: Text(
                            "TRY AGAIN",
                            style: TextStyle(
                                color: const Color(0xFF010101),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
            )
        ],
      )),
    );
  }
}
