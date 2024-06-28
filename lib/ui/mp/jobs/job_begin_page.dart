import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/config.dart';
import 'package:truck_moves/models/job_header.dart';
import 'package:truck_moves/shared_widgets/app_bar.dart';
import 'package:truck_moves/shared_widgets/confirmation_popup.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';
import 'package:truck_moves/ui/mp/jobs/pre_departure_checklist.dart';
import 'package:truck_moves/utils/hero_dialog_route.dart';

class JobBeginPage extends StatefulWidget {
  final JobHeader job;
  const JobBeginPage({super.key, required this.job});

  @override
  State<JobBeginPage> createState() => _JobBeginPageState();
}

class _JobBeginPageState extends State<JobBeginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(label: widget.job.id.toString()),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Row(
              children: [
                Text(
                  "Job No",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Container(
                  height: 30.h,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.h)),
                  child: Text(
                    widget.job.id.toString(),
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Text(
              "Hello Leon Ware,",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                "Today you are driving a from ${widget.job.pickupLocation}, Australia to ${widget.job.dropOfLocation},Australia.",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              "When you are ready to begin tap Submit",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: SubmitButton(
                onTap: () {
                  Navigator.push(
                      context,
                      HeroDialogRoute(
                        builder: (_) => ConfirmationPopup(
                          title: "Prechecking",
                          message:
                              "Before you depart you must complete the pre-departure checklist. Tap continue to begin.",
                          leftBtnText: "Cancel",
                          rightBtnText: "Continue",
                          onRightTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PreDepartureChecklist(
                                        job: widget.job)));
                          },
                        ),
                      ));
                },
                label: "Submit",
                // width: 275.w,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      )),
    );
  }
}
