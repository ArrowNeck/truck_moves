import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/constant.dart';

class MyAppBar {
  static AppBar build(
      {required String label,
      Color? bgclr,
      bool enableBackBtn = true,
      List<Widget>? actions}) {
    return AppBar(
      backgroundColor: bgclr ?? bgColor,
      centerTitle: true,
      automaticallyImplyLeading: enableBackBtn,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
      title: FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
              fontWeight: FontWeight.w800),
        ),
      ),
      actions: actions,
    );
  }
}
