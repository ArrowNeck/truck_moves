import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/models/pre_check.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/toast_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';
import 'package:truck_moves/ui/mp/home/home_page.dart';
import 'package:truck_moves/utils/extensions.dart';
import 'package:truck_moves/utils/image_compress.dart';

class PreDepartureChecklistPage extends StatefulWidget {
  final int jobId;
  final PreDepartureChecklist? preChecklist;
  final bool isArrival;
  const PreDepartureChecklistPage(
      {super.key,
      required this.jobId,
      this.preChecklist,
      this.isArrival = false});

  @override
  State<PreDepartureChecklistPage> createState() =>
      _PreDepartureChecklistPageState();
}

class _PreDepartureChecklistPageState extends State<PreDepartureChecklistPage> {
  late TextEditingController _textController;
  double fuelLevel = 0;
  List<PreCheck> checklist = [];
  List<String> images = [];
  List<String> imagesAlreadyHave = [];

  @override
  void initState() {
    _textController = TextEditingController(
        text: widget.preChecklist?.notes.firstOrNull?.noteText);
    fuelLevel = widget.preChecklist?.fuelLevel ?? 0;
    imagesAlreadyHave = widget.preChecklist?.images ?? [];
    if (imagesAlreadyHave.length > 5) {
      imagesAlreadyHave.removeRange(5, imagesAlreadyHave.length);
    }
    checklist = [
      PreCheck(
          id: "water",
          name: "Water (Used Vehicles)",
          type: (widget.preChecklist?.water).type),
      PreCheck(
          id: "spareRim",
          name: "Spare Rim",
          type: (widget.preChecklist?.spareRim).type),
      PreCheck(
          id: "allLightsAndIndicators",
          name: "All lights & Indicators",
          type: (widget.preChecklist?.allLightsAndIndicators).type),
      PreCheck(
          id: "jackAndTools",
          name: "Jack and Tools",
          type: (widget.preChecklist?.jackAndTools).type),
      PreCheck(
          id: "ownersManual",
          name: "Owners Manual",
          type: (widget.preChecklist?.ownersManual).type),
      PreCheck(
          id: "airAndElectrics",
          name: "Air & Electrics [Secure]",
          type: (widget.preChecklist?.airAndElectrics).type),
      PreCheck(
          id: "tyresCondition",
          name: "Tyres Condition",
          type: (widget.preChecklist?.tyresCondition).type),
      PreCheck(
          id: "visuallyDipAndCheckTaps",
          name: "Visually Dip Fuel & Check Taps",
          type: (widget.preChecklist?.visuallyDipAndCheckTaps).type),
      PreCheck(
          id: "windscreenDamageWipers",
          name: "Windscreen Damage / Wipers",
          type: (widget.preChecklist?.windscreenDamageWipers).type),
      PreCheck(
          id: "vehicleCleanFreeOfRubbish",
          name: "Vehicle Clean & Free of Rubbish",
          type: (widget.preChecklist?.vehicleCleanFreeOfRubbish).type),
      PreCheck(
          id: "keysFobTotalKeys",
          name: "Keys / Fob - Total Keys",
          type: (widget.preChecklist?.keysFobTotalKeys).type),
      PreCheck(
          id: "checkInsideTruckTrailer",
          name: "Check Inside Truck & Trailer for loose or unrestrained loads",
          type: (widget.preChecklist?.checkInsideTruckTrailer).type),
      PreCheck(
          id: "oil",
          name: "Oil (Used Vehicles)",
          type: (widget.preChecklist?.oil).type),
      PreCheck(
          id: "checkTruckHeight",
          name: "Check Truck Height (4.3m)",
          type: (widget.preChecklist?.checkTruckHeight).type),
      PreCheck(
          id: "leftHandDamage",
          name: "Left Hand Damage",
          type: (widget.preChecklist?.leftHandDamage).type),
      PreCheck(
          id: "rightHandDamage",
          name: "Right Hand Damage",
          type: (widget.preChecklist?.rightHandDamage).type),
      PreCheck(
          id: "frontDamage",
          name: "Front Damage",
          type: (widget.preChecklist?.frontDamage).type),
      PreCheck(
          id: "rearDamage",
          name: "Rear Damage",
          type: (widget.preChecklist?.rearDamage).type),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _imageFromCamera() async {
    try {
      List<MediaModel> imgs =
          await MultipleImageCamera.capture(context: context);

      images.addAll(imgs.map((file) => file.file.path).toList());
      if ((imagesAlreadyHave.length + images.length) > 5) {
        images.removeRange((5 - imagesAlreadyHave.length), images.length);
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _uploadImages() async {
    if (checklist.any((x) => x.type > 2)) {
      showToastSheet(
          context: context,
          title: "Checklist Incomplete!",
          message:
              "Checklist Not Completed. Please ensure all required items are checked off before proceeding.",
          isError: true);
    } else {
      if (images.isNotEmpty) {
        PageLoader.showLoader(context);
        List<String> compressImages = await Future.wait(
            images.map((x) async => (await compressFile(x))!).toList());
        final res = await JobService.uploadMultiple(paths: compressImages);
        if (!mounted) return;
        Navigator.pop(context);

        res.when(success: (data) {
          setState(() {
            images = [];
            imagesAlreadyHave.addAll(data);
          });
          _savePreChecklist();
        }, failure: (error) {
          showErrorSheet(context: context, exception: error);
        });
      } else {
        _savePreChecklist();
      }
    }
  }

  _savePreChecklist() async {
    PageLoader.showLoader(context);
    Map<String, dynamic> data = {
      "id": widget.preChecklist?.id ?? 0,
      "jobId": widget.jobId,
      for (var c in checklist) c.id: c.type.txt,
      "fuelLevel": fuelLevel,
      "isPre": !(widget.isArrival),
      "notes": [
        {
          "id": widget.preChecklist?.notes.firstOrNull?.id ?? 0,
          "jobId": null,
          "vehicleId": null,
          "trailerId": null,
          "checklistId":
              widget.preChecklist?.notes.firstOrNull?.checklistId ?? 0,
          "visibletoDriver": true,
          "permitAndPlatesId": null,
          "accommodationId": null,
          "publicTransportId": null,
          "noteText": _textController.text
        },
      ],
      "checkListImages": imagesAlreadyHave
          .map((x) => {"id": 0, "checklistId": 0, "url": x})
          .toList()
    };
    final res = await JobService.saveChecklist(data: data);
    if (!mounted) return;
    Navigator.pop(context);

    res.when(success: (data) {
      if (widget.isArrival) {
        showToastSheet(
          context: context,
          title: "Well Done!",
          message:
              "Congratulations! \nYou have successfully completed job number ${widget.jobId}.",
          icon: "complete",
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
        );
      } else {
        showToastSheet(
          context: context,
          title: "Success!",
          icon: "checklist",
          message:
              "You have successfully ${(context.read<JobProvider>().currentlyRunningJob!.status < 4) ? "submitted" : "updated"} your pre-departure checklist.",
          onTap: () {
            context.read<JobProvider>().addPrechecklist(data: data);
            Navigator.pop(context);
          },
        );
      }
    }, failure: (error) {
      showErrorSheet(context: context, exception: error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        title: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.scaleDown,
          child: Text(
            widget.isArrival ? "Arrival-Checklist" : "Pre-Checklist",
            style: TextStyle(
                fontSize: 23.sp,
                color: Colors.white,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
            child: ListView(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          children: [
            ...checklist.map((e) => _card(e)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF416188))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please report faults that require attention",
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  TextField(
                    controller: _textController,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        decoration: TextDecoration.none),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: primaryColor,
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    readOnly: widget.isArrival
                        ? false
                        : (context
                                .read<JobProvider>()
                                .currentlyRunningJob!
                                .status >
                            4),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF416188)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF416188)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF416188)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: (widget.isArrival
                  ? false
                  : context.read<JobProvider>().currentlyRunningJob!.status >
                      4),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF416188))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fuel Level",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _fuelLevel(color: Colors.red, label: "E", level: 0.0),
                        _fuelLevel(
                            color: Colors.orange, label: "1/4", level: 0.25),
                        _fuelLevel(
                            color: Colors.yellow, label: "1/2", level: 0.5),
                        _fuelLevel(
                            color: Colors.green, label: "3/4", level: 0.75),
                        _fuelLevel(
                            color: Colors.greenAccent[700]!,
                            label: "F",
                            level: 1.0),
                      ],
                    )
                  ],
                ),
              ),
            ),
            (images.isNotEmpty || imagesAlreadyHave.isNotEmpty)
                ? Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF416188))),
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: [
                        ...imagesAlreadyHave.map((url) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.h),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: url,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                                child: SizedBox(
                                      height: 30.h,
                                      width: 30.h,
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        color: Colors.white,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                primaryColor),
                                      ),
                                    )),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            child: SizedBox(
                                      height: 30.h,
                                      width: 30.h,
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.redAccent,
                                      ),
                                    )),
                                  ),
                                  if (!(widget.isArrival
                                      ? false
                                      : context
                                              .read<JobProvider>()
                                              .currentlyRunningJob!
                                              .status >
                                          4))
                                    Positioned(
                                      top: 2.5,
                                      right: 2.5,
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          imagesAlreadyHave.remove(url);
                                        }),
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.redAccent,
                                          size: 30.h,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                        ...images.map((file) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.h),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(file),
                                    // height: 250.h,
                                    // width: 300.w,
                                    fit: BoxFit.fill,
                                  ),
                                  Positioned(
                                    top: 2.5,
                                    right: 2.5,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        images.remove(file);
                                      }),
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.redAccent,
                                        size: 30.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        if ((!(widget.isArrival
                                ? false
                                : context
                                        .read<JobProvider>()
                                        .currentlyRunningJob!
                                        .status >
                                    4)) &&
                            ((images.length + imagesAlreadyHave.length) < 5))
                          IconButton(
                            onPressed: () => _imageFromCamera(),
                            icon: Icon(
                              Icons.add_a_photo_rounded,
                              color: primaryColor,
                              // size: 35.h,
                            ),
                          ),
                      ],
                    ))
                : ((widget.isArrival
                        ? false
                        : context
                                .read<JobProvider>()
                                .currentlyRunningJob!
                                .status >
                            4))
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          _imageFromCamera();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 16.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF416188))),
                          child: Column(
                            children: [
                              Text(
                                "Tap here to take photos",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "(Maximum 5 photos allowed)",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
          ],
        )),
      ),
      bottomNavigationBar: (widget.isArrival ||
              context.read<JobProvider>().currentlyRunningJob!.status < 5)
          ? SafeArea(
              child: SubmitButton(
              onTap: () {
                _uploadImages();
              },
              label: (widget.isArrival ||
                      context.read<JobProvider>().currentlyRunningJob!.status <
                          4)
                  ? "Submit"
                  : "Update",
              marginW: 16.w,
              marginH: 8.h,
            ))
          : null,
    );
  }

  _fuelLevel(
      {required Color color, required String label, required double level}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              fuelLevel = level;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: .15.sw,
                height: .15.sw,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(8.w)),
              ),
              if (fuelLevel == level)
                Icon(
                  Icons.check,
                  size: 30.h,
                  color: Colors.black,
                )
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  _card(PreCheck data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xFF416188))),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data.name,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          IgnorePointer(
            ignoring: widget.isArrival
                ? false
                : (context.read<JobProvider>().currentlyRunningJob!.status > 4),
            child: Container(
                height: 25.h,
                width: 25.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF416188))),
                child: PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  color: bgColor,
                  constraints: BoxConstraints(
                    maxWidth: 60.h,
                  ),
                  child: Icon(
                    data.type.icon,
                    color: data.type.clr,
                    size: 20.h,
                  ),
                  onSelected: (int result) {
                    setState(() {
                      data.type = result;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 1,
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: 25.h,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 0,
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 25.h,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          size: 25.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // PopupMenuItem<int>(
                    //   value: 2,
                    //   child: Center(
                    //     child: Icon(
                    //       Icons.more_horiz_rounded,
                    //       size: 25.h,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
