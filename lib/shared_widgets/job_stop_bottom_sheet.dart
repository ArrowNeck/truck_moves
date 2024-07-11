import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';

class JobStopBottomSheet extends StatefulWidget {
  const JobStopBottomSheet({super.key});

  @override
  State<JobStopBottomSheet> createState() => _JobStopBottomSheetState();
}

class _JobStopBottomSheetState extends State<JobStopBottomSheet> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 428.w,
        decoration: BoxDecoration(
            color: bgColor,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    _btn(
                        title: "Stop for the \nnight",
                        icon: "assets/icons/bed-1.svg",
                        select: 0),
                    SizedBox(
                      width: 12.w,
                    ),
                    _btn(
                        title: "Delivered to final \nlocation",
                        icon: "assets/icons/truck.svg",
                        select: 1),
                  ],
                ),
              ),
              SubmitButton(
                onTap: () {
                  Navigator.pop(context,
                      selected == 1); // if this true mean job is completed.
                },
                label: "Confirm",
                radius: 10.h,
              ),
              SizedBox(
                height: 12.h,
              )
            ],
          ),
        ));
  }

  Expanded _btn(
      {required String title, required String icon, required int select}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = select;
          });
        },
        child: Stack(
          children: [
            Container(
              height: 200.h,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: const Color(0xFF416188)),
                  borderRadius: BorderRadius.circular(10.h)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset(
                    icon,
                    height: 80.w,
                    width: 80.w,
                    fit: BoxFit.fill,
                    colorFilter:
                        ColorFilter.mode(Colors.grey[350]!, BlendMode.srcIn),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (selected == select)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.h),
                    child: Container(
                      color: Colors.black38,
                      child: Icon(
                        Icons.check_rounded,
                        size: 80.w,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
