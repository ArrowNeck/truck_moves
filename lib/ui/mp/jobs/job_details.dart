import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job_header.dart';
import 'package:truck_moves/shared_widgets/app_bar.dart';
import 'package:truck_moves/shared_widgets/confirmation_popup.dart';
import 'package:truck_moves/ui/mp/jobs/add_purchase.dart';
import 'package:truck_moves/ui/mp/jobs/map_view.dart';
import 'package:truck_moves/ui/mp/jobs/pre_departure_checklist.dart';
import 'package:truck_moves/utils/extensions.dart';
import 'package:truck_moves/utils/hero_dialog_route.dart';

class JobDetails extends StatefulWidget {
  final JobHeader job;
  const JobDetails({super.key, required this.job});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.build(label: widget.job.id.toString(), actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PreDepartureChecklistPage(
                              jobId: widget.job.id,
                              preChecklist: widget.job.preDepartureChecklist,
                            )));
              },
              icon: Icon(
                widget.job.preDepartureChecklist == null
                    ? Icons.assignment_add
                    : Icons.assignment_rounded,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    HeroDialogRoute(builder: (_) => const AddPurchase()));
              },
              icon: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ))
        ]),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerLabel("Trip Details", Icons.location_on_outlined),
                _dataItem("Pickup Address", widget.job.pickupLocation),
                _dataItem("Pickup Date", widget.job.pickupDate?.format ?? ""),
                _dataItem("Delivery Address", widget.job.dropOfLocation),
                _dataItem("Delivery Date", widget.job.pickupDate?.format ?? ""),
                const MapView(),
                _headerLabel("Vehicle Details", Icons.car_crash_outlined),
                _dataItem("Make", "Japan"),
                _dataItem("Model", "BD-96i"),
                _dataItem("Rego", "ABC-24568"),
                _dataItem("VIN", "VIN 10235"),
                _dataItem("Year", "2018"),
                _dataItem("Color", "Black"),
                _headerLabel("Trailer Details", Icons.fire_truck_outlined),
                _dataItem("Hookup Type", "HU Single"),
                _dataItem("Hookup Location",
                    "1A Baylis St, Wagga Wagga NSW 2650, Australia"),
                _dataItem("Dropoff Location",
                    "1A Baylis St, Wagga Wagga NSW 2650, Australia"),
                _dataItem("Rego", "TI-10235"),
                _dataItem("Type", "Unknown"),
              ],
            ),
          ),
        )),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (widget.job.preDepartureChecklist == null) {
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
                                builder: (_) => PreDepartureChecklistPage(
                                      jobId: widget.job.id,
                                      preChecklist:
                                          widget.job.preDepartureChecklist,
                                    )));
                      },
                    ),
                  ));
            } else {
              Navigator.push(
                  context,
                  HeroDialogRoute(
                    builder: (_) => ConfirmationPopup(
                      title: "Acknowledgement",
                      message:
                          "I acknowledge that I am not under the influence of drugs or alcohol and am fit to drive.",
                      leftBtnText: "Cancel",
                      rightBtnText: "Agreed",
                      onRightTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => PreDepartureChecklistPage(
                        //               jobId: widget.job.id,
                        //               preChecklist:
                        //                   widget.job.preDepartureChecklist,
                        //             )));
                      },
                    ),
                  ));
            }
          },
          child: BottomAppBar(
            height: 60.h,
            color: Colors.green,
            child: Center(
              child: Text(
                'Start'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }

  _headerLabel(String label, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(top: 25.h),
      child: Container(
        height: 45.h,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(8.h)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 25.h,
            )
          ],
        ),
      ),
    );
  }

  _dataItem(String title, String data) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 15.sp,
                color: primaryColor,
                fontWeight: FontWeight.w600),
            children: [
              TextSpan(
                text: " : ",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF5DB075),
                    fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: data,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ]),
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text(
      //       title,
      //       style: TextStyle(
      //           fontSize: 15.sp,
      //           color: primaryColor,
      //           fontWeight: FontWeight.w500),
      //       textAlign: TextAlign.left,
      //     ),
      //     SizedBox(
      //       height: 2.h,
      //     ),
      //     Text(
      //       data,
      //       style: TextStyle(
      //           fontSize: 14.sp,
      //           color: Colors.white,
      //           fontWeight: FontWeight.w400),
      //       textAlign: TextAlign.left,
      //     ),
      //   ],
      // ),
    );
  }
}
