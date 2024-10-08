import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/providers/auth_provider.dart';
import 'package:truck_moves/ui/landing/login_page/login_page.dart';
import 'package:truck_moves/ui/mp/home/home_page.dart';
import 'package:truck_moves/utils/cache_manager.dart';
import 'package:truck_moves/utils/custom_http.dart';
import 'package:truck_moves/utils/exceptions/network_exceptions.dart';

showErrorSheet(
    {required BuildContext context,
    required NetworkExceptions exception,
    VoidCallback? onTap,
    String? title,
    String? message,
    bool login = false}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
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
            title ??
                ((NetworkExceptions.getErrorMessage(exception).first ==
                        "Invalid Request")
                    ? "Notice of Job Assign"
                    : (login && unAuth)
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
                  ((NetworkExceptions.getErrorMessage(exception).first ==
                          "Invalid Request")
                      ? "You are no longer assigned to this job, and it will be continued by someone else."
                      : (login && unAuth)
                          ? "The email or password you entered is incorrect. Please check your credentials and try again."
                          : NetworkExceptions.getErrorMessage(exception)[1]),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (NetworkExceptions.getErrorMessage(exception).first ==
              "Invalid Request")
            Padding(
              padding: EdgeInsets.only(
                  top: 20.h, bottom: 25.h, left: 16.w, right: 16.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  decoration: BoxDecoration(color: primaryColor),
                  child: Text(
                    "Close",
                    style: TextStyle(
                        color: const Color(0xFF010101),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          else if (!login && unAuth)
            Padding(
              padding: EdgeInsets.only(
                  top: 20.h, bottom: 25.h, left: 16.w, right: 16.w),
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await CacheManger.removeDriver();
                  if (context.mounted) {
                    CustomHttp.setInterceptor(token: null);
                    context.read<AuthProvider>().removeDriver();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  decoration: BoxDecoration(color: primaryColor),
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
                          border: Border.all(color: primaryColor, width: 2),
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
                          Navigator.pop(context);
                          onTap!();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(0.h),
                              color: primaryColor),
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
