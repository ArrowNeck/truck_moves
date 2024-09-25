import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/ui/mp/jobs/job_details.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.read<JobProvider>().canAccessThisJob(jobId: job.id)) {
          context.read<JobProvider>()
            ..setCurrentlyRunningJob(job)
            ..setPreviousStatus(job.status);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const JobDetails(),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
            color: job.status > 3 ? Colors.red.shade400 : Colors.transparent,
            border: Border.all(color: const Color(0xFF416188))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: "Job No",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: " - ",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: const Color(0xFF5DB075),
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: job.id.toString(),
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    )
                  ]),
            ),
            Divider(
              color: const Color(0xFF416188),
              height: 24.h,
            ),
            _fromToRow(label: "Truck From", data: job.pickupLocation),
            _fromToRow(label: "Truck To", data: job.dropOfLocation),
            SizedBox(
              height: 8.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      width: 20.h,
                      height: 20.h,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      job.pickupDate == null
                          ? ""
                          : DateFormat("dd.MM.yyyy").format(job.pickupDate!),
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
                Expanded(
                    child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/truck-front.svg",
                      width: 22.5.h,
                      height: 22.5.h,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      job.vehicleDetails?.model ?? "",
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14.sp,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  _fromToRow({required String label, required String data}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Text(
            " - ",
            style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF5DB075),
                fontWeight: FontWeight.w500),
          ),
          Expanded(
              flex: 5,
              child: Text(
                data,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ))
        ],
      ),
    );
  }
}
