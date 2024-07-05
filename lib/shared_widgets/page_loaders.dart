import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:truck_moves/constant.dart';

class PageLoader {
  static showLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.25),
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => Future.value(false),
          child: loader(),
        );
      },
    );
  }

  static loader() {
    return Center(
      child: SizedBox(
        height: 50.w,
        width: 50.w,
        child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotateMultiple,
            colors: [
              primaryColor,
            ],
            strokeWidth: 3.0),
      ),
    );
  }

  static showTransparentLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => Future.value(false),
          child: Container(
            color: Colors.transparent,
          ),
        );
      },
    );
  }
}
