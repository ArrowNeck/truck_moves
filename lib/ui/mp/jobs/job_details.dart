import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/app_bar.dart';
import 'package:truck_moves/shared_widgets/confirmation_popup.dart';
import 'package:truck_moves/shared_widgets/job_stop_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/toast_bottom_sheet.dart';
import 'package:truck_moves/ui/mp/jobs/add_purchase.dart';
import 'package:truck_moves/ui/mp/jobs/map_view.dart';
import 'package:truck_moves/ui/mp/jobs/pre_departure_checklist.dart';
import 'package:truck_moves/utils/extensions.dart';
import 'package:truck_moves/utils/hero_dialog_route.dart';

class JobDetails extends StatefulWidget {
  // final Job job;
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  int selected = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle appropriately
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle appropriately
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return _getAddressFromLatLng(position);
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return Future.error("Unable to get your current location for this time.");
    }
  }

  _createLeg() async {
    try {
      PageLoader.showLoader(context);
      String location = await _getCurrentLocation();
      if (!mounted) return;

      final res = await JobService.createLeg(
          jobId: context.read<JobProvider>().currentlyRunningJob!.id,
          location: location);
      if (mounted) Navigator.pop(context);

      res.when(success: (data) {
        context.read<JobProvider>().addLeg(data: data);
        showToastSheet(
            context: context,
            title: "All Set to Drive!",
            icon: "ready",
            message:
                "Your job has been successfully initiated, and you are now ready to begin driving.");
      }, failure: (error) {
        showErrorSheet(context: context, exception: error);
      });
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showToastSheet(
            context: context,
            title: "Error!",
            message: e.toString(),
            isError: true);
      }
    }
  }

  _closeLeg({required bool isJobCompleted}) async {
    try {
      PageLoader.showLoader(context);
      String location = await _getCurrentLocation();
      if (!mounted) return;

      final res = await JobService.closeLeg(
          leg: context.read<JobProvider>().currentlyRunningJob!.legs.last,
          location: location,
          isCompleted: isJobCompleted);
      if (mounted) Navigator.pop(context);

      res.when(success: (data) {
        context
            .read<JobProvider>()
            .updateLeg(data: data, isCompleted: isJobCompleted);
        showToastSheet(
            context: context,
            title: "Stopped Driving!",
            icon: isJobCompleted ? "final-destination" : "stay-night",
            message:
                "You have successfully stopped ${isJobCompleted ? "your current job upon reaching the final destination" : "driving and will stay for the night"}.");
      }, failure: (error) {
        showErrorSheet(context: context, exception: error);
      });
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showToastSheet(
            context: context,
            title: "Error!",
            message: e.toString(),
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Job job = context.watch<JobProvider>().currentlyRunningJob!;
    return Scaffold(
        appBar: MyAppBar.build(label: job.id.toString(), actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PreDepartureChecklistPage(
                            jobId: job.id,
                            preChecklist: job.preDepartureChecklist,
                          )));
            },
            visualDensity: VisualDensity.compact,
            icon: SvgPicture.asset(
              "assets/icons/checklist-${job.status < 5 ? "edit" : "done"}.svg",
              width: 22.5.h,
              height: 22.5.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          if (!(job.status == 9))
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    HeroDialogRoute(
                      builder: (_) => ConfirmationPopup(
                        title: "Breakdown/Delay",
                        message:
                            "Are you sure you want to perform this action?",
                        leftBtnText: "No",
                        rightBtnText: "Yes",
                        onRightTap: () {},
                      ),
                    ));
              },
              visualDensity: VisualDensity.compact,
              icon: SvgPicture.asset(
                "assets/icons/truck-tow.svg",
                width: 22.5.h,
                height: 22.5.h,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  HeroDialogRoute(builder: (_) => const AddPurchase()));
            },
            visualDensity: VisualDensity.compact,
            icon: SvgPicture.asset(
              "assets/icons/purchase.svg",
              width: 22.5.h,
              height: 22.5.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          )
        ]),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerLabel("Trip Details", "trip_details"),
                _dataItem2("Pickup Address", job.pickupLocation),
                _dataItem2("Pickup Date", job.pickupDate?.format ?? ""),
                _dataItem2("Delivery Address", job.dropOfLocation),
                _dataItem2(
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
                        child: _dataItem2(
                            "Make", job.vehicleDetails?.make ?? "-",
                            flex: 1)),
                    Expanded(
                        child: _dataItem2(
                            "Year", job.vehicleDetails?.year ?? "-",
                            flex: 1)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _dataItem2(
                            "Model", job.vehicleDetails?.model ?? "-",
                            flex: 1)),
                    Expanded(
                        child: _dataItem2(
                            "Color", job.vehicleDetails?.colour ?? "-",
                            flex: 1)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _dataItem2(
                            "Rego", job.vehicleDetails?.rego ?? "-",
                            flex: 1)),
                    Expanded(
                        child: _dataItem2("VIN", job.vehicleDetails?.vin ?? "-",
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
                              // "10",
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
                        _dataItem2("Hookup Type",
                            job.trailers[i].hookupTypeNavigation.description,
                            topPadding: 0),
                        _dataItem2(
                            "Hookup Location", job.trailers[i].hookupLocation),
                        _dataItem2("Dropoff Location",
                            job.trailers[i].dropOffLocation),
                        _dataItem2("Rego", job.trailers[i].rego),
                        _dataItem2("Type", job.trailers[i].type),
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
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (job.status == 6) {
              showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      context: context,
                      builder: (context) => const JobStopBottomSheet())
                  .then((select) {
                if (select != null) {
                  _closeLeg(isJobCompleted: select);
                }
              });
            } else if (job.status == 9) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PreDepartureChecklistPage(
                            jobId: job.id,
                            isArrival: true,
                          )));
            } else {
              if (job.preDepartureChecklist == null) {
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
                                        jobId: job.id,
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
                          _createLeg();
                        },
                      ),
                    ));
              }
            }
          },
          child: Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            color: job.status == 6
                ? Colors.redAccent
                : job.status == 9
                    ? primaryColor
                    : Colors.green,
            child: Text(
              (job.status == 6
                      ? "Stop"
                      : job.status == 9
                          ? "Next"
                          : 'Start')
                  .toUpperCase(),
              style: TextStyle(
                color: job.status == 9 ? Colors.black : Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }

  _headerLabel(String label, String icon) {
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
                fontWeight: FontWeight.w600),
          ),
          ...notes.map((e) => Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\u2022",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
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
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // _dataItem(String title, String data, {double? topPadding}) {
  //   return Padding(
  //     padding: EdgeInsets.only(top: topPadding ?? 16.h),
  //     child: RichText(
  //       text: TextSpan(
  //           text: title,
  //           style: TextStyle(
  //               fontSize: 15.sp,
  //               color: primaryColor,
  //               fontWeight: FontWeight.w600),
  //           children: [
  //             TextSpan(
  //               text: " : ",
  //               style: TextStyle(
  //                   fontSize: 15.sp,
  //                   color: const Color(0xFF5DB075),
  //                   fontWeight: FontWeight.w600),
  //             ),
  //             TextSpan(
  //               text: data,
  //               style: TextStyle(
  //                   fontSize: 15.sp,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w600),
  //             )
  //           ]),
  //     ),
  //   );
  // }

  _dataItem2(String title, String data, {double? topPadding, int? flex}) {
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
                      fontWeight: FontWeight.w600),
                )),
            Text(" : ",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF5DB075),
                    fontWeight: FontWeight.w600)),
            Expanded(
              flex: flex ?? 2,
              child: Text(
                data,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ));
  }
}
