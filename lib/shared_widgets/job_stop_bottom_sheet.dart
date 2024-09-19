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
  int? selectedJobStatus;
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
              SizedBox(
                height: 5.h,
              ),
              _btn(
                  title: "Stop for the night",
                  icon: "assets/icons/bed.svg",
                  jobStatus: 7),
              SizedBox(
                height: 10.h,
              ),
              _btn(
                  title: "Delivered to final location",
                  icon: "assets/icons/truck.svg",
                  jobStatus: 9),
              SizedBox(
                height: 10.h,
              ),
              _btn(
                  title: "Delivered to store location",
                  icon: "assets/icons/store.svg",
                  jobStatus: 15),
              SizedBox(
                height: 20.h,
              ),
              SubmitButton(
                onTap: () {
                  Navigator.pop(context, selectedJobStatus);
                },
                label: "Confirm",
                radius: 10.h,
              ),
              SizedBox(
                height: 15.h,
              )
            ],
          ),
        ));
  }

  _btn({required String title, required String icon, required int jobStatus}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedJobStatus = jobStatus;
        });
      },
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xFF416188)),
                borderRadius: BorderRadius.circular(10.h)),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 35.h,
                  width: 35.h,
                  fit: BoxFit.fill,
                  colorFilter:
                      ColorFilter.mode(Colors.grey[350]!, BlendMode.srcIn),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedJobStatus == jobStatus)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(2.0)
                    .add(EdgeInsets.symmetric(horizontal: 16.w)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.h),
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 8.w),
                    color: Colors.black.withOpacity(.25),
                    child: Icon(
                      Icons.check_rounded,
                      size: 40.h,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
