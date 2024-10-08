import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/ui/mp/jobs/bottom_button.dart';
import 'package:truck_moves/ui/mp/jobs/job_details_app_bar.dart';
import 'package:truck_moves/ui/mp/jobs/map_view.dart';
import 'package:truck_moves/utils/extensions.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    Job job = context.watch<JobProvider>().currentlyRunningJob!;
    return Scaffold(
      appBar: const JobDetailsAppBar(),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerLabel("Trip Details", "trip_details"),
              _dataItem("Pickup Address", job.pickupLocation),
              _dataItem("Pickup Date", job.pickupDate?.format ?? ""),
              _dataItem("Delivery Address", job.dropOfLocation),
              _dataItem(
                  "Delivery Date", job.estimatedDeliveryDate?.format ?? ""),
              if ((job.pickupCoordinates?.isNotEmpty ?? true) &&
                  (job.dropOfCoordinates?.isNotEmpty ?? true))
                MapView(
                  pickupCords: job.pickupCoordinates!,
                  deliveryCords: job.dropOfCoordinates!,
                  pickupLocation: job.pickupLocation,
                  deliveryLocation: job.dropOfLocation,
                  wayPoints: job.wayPoints,
                  trailers: job.trailers,
                ),
              _headerLabel("Vehicle Details", "truck-side"),
              Row(
                children: [
                  Expanded(
                      child: _dataItem("Make", job.vehicleDetails?.make ?? "-",
                          flex: 1)),
                  Expanded(
                      child: _dataItem("Year", job.vehicleDetails?.year ?? "-",
                          flex: 1)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: _dataItem(
                          "Model", job.vehicleDetails?.model ?? "-",
                          flex: 1)),
                  Expanded(
                      child: _dataItem(
                          "Color", job.vehicleDetails?.colour ?? "-",
                          flex: 1)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: _dataItem("Rego", job.vehicleDetails?.rego ?? "-",
                          flex: 1)),
                  Expanded(
                      child: _dataItem("VIN", job.vehicleDetails?.vin ?? "-",
                          flex: 1)),
                ],
              ),
              if (job.vehicleDetails?.notes.isNotEmpty ?? false)
                _noteView(job.vehicleDetails?.notes ?? []),
              if (job.trailers.isNotEmpty)
                _headerLabel("Trailer Details", "trailer"),
              ListView.builder(
                key: Key('builder ${selected.toString()}'),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: job.trailers.length,
                itemBuilder: (ctx, i) => Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: i == selected,
                    onExpansionChanged: (state) {
                      if (state) {
                        setState(() {
                          selected = i;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    },
                    title: Row(
                      children: [
                        Text(
                          "Trailer",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF5DB075),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 22.5.h,
                          width: 22.5.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF5DB075),
                          ),
                          child: Text(
                            "${i + 1}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    iconColor: const Color(0xFF5DB075),
                    collapsedIconColor: const Color(0xFF5DB075),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    dense: true,
                    children: [
                      _dataItem(
                          "Hookup Type",
                          job.trailers[i].hookupTypeNavigation.type
                              .replaceAll("_", " "),
                          topPadding: 0),
                      _dataItem(
                          "Hookup Location", job.trailers[i].hookupLocation),
                      _dataItem(
                          "Dropoff Location", job.trailers[i].dropOffLocation),
                      _dataItem("Rego", job.trailers[i].rego),
                      _dataItem("Type", job.trailers[i].type),
                      if (job.trailers[i].notes.isNotEmpty)
                        _noteView(job.trailers[i].notes),
                      SizedBox(
                        height: 12.h,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      )),
      bottomNavigationBar: const BottomButton(),
    );
  }

  _headerLabel(String label, String icon) {
    return Padding(
      padding: EdgeInsets.only(top: 25.h),
      child: Container(
        height: 45.h,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: primaryColor),
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SvgPicture.asset(
              "assets/icons/$icon.svg",
              width: 22.5.h,
              height: 22.5.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

  _noteView(List<String> notes) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes",
            style: TextStyle(
              fontSize: 15.sp,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          ...notes.map(
            (e) => Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\u2022",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _dataItem(String title, String data, {double? topPadding, int? flex}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: flex ?? 1,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            " : ",
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF5DB075),
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            flex: flex ?? 2,
            child: Text(
              data,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
