import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/config.dart';
import 'package:truck_moves/models/job_header.dart';
import 'package:truck_moves/models/pre_check.dart';
import 'package:truck_moves/shared_widgets/app_bar.dart';
import 'package:truck_moves/shared_widgets/network_success_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';

class PreDepartureChecklistPage extends StatefulWidget {
  final int jobId;
  final PreDepartureChecklist? preChecklist;
  const PreDepartureChecklistPage(
      {super.key, required this.jobId, this.preChecklist});

  @override
  State<PreDepartureChecklistPage> createState() =>
      _PreDepartureChecklistPageState();
}

class _PreDepartureChecklistPageState extends State<PreDepartureChecklistPage> {
  late TextEditingController _textController;
  double fuelLevel = 0;
  List<PreCheck> checklist = [];

  @override
  void initState() {
    _textController = TextEditingController(
        text: widget.preChecklist?.notes.firstOrNull?.noteText);
    fuelLevel = widget.preChecklist?.fuelLevel ?? 0;
    checklist = [
      PreCheck(
          id: "water",
          name: "Water (Used Vehicles)",
          isSelect: _getCheckType(widget.preChecklist?.water)),
      PreCheck(
          id: "spareRim",
          name: "Spare Rim",
          isSelect: _getCheckType(widget.preChecklist?.spareRim)),
      PreCheck(
          id: "allLightsAndIndicators",
          name: "All lights & Indicators",
          isSelect: _getCheckType(widget.preChecklist?.allLightsAndIndicators)),
      PreCheck(
          id: "jackAndTools",
          name: "Jack and Tools",
          isSelect: _getCheckType(widget.preChecklist?.jackAndTools)),
      PreCheck(
          id: "ownersManual",
          name: "Owners Manual",
          isSelect: _getCheckType(widget.preChecklist?.ownersManual)),
      PreCheck(
          id: "airAndElectrics",
          name: "Air & Electrics [Secure]",
          isSelect: _getCheckType(widget.preChecklist?.airAndElectrics)),
      PreCheck(
          id: "tyresCondition",
          name: "Tyres Condition",
          isSelect: _getCheckType(widget.preChecklist?.tyresCondition)),
      PreCheck(
          id: "visuallyDipAndCheckTaps",
          name: "Visually Dip Fuel & Check Taps",
          isSelect:
              _getCheckType(widget.preChecklist?.visuallyDipAndCheckTaps)),
      PreCheck(
          id: "windscreenDamageWipers",
          name: "Windscreen Damage / Wipers",
          isSelect: _getCheckType(widget.preChecklist?.windscreenDamageWipers)),
      PreCheck(
          id: "vehicleCleanFreeOfRubbish",
          name: "Vehicle Clean & Free of Rubbish",
          isSelect:
              _getCheckType(widget.preChecklist?.vehicleCleanFreeOfRubbish)),
      PreCheck(
          id: "keysFobTotalKeys",
          name: "Keys / Fob - Total Keys",
          isSelect: _getCheckType(widget.preChecklist?.keysFobTotalKeys)),
      PreCheck(
          id: "checkInsideTruckTrailer",
          name: "Check Inside Truck & Trailer for loose or unrestrained loads",
          isSelect:
              _getCheckType(widget.preChecklist?.checkInsideTruckTrailer)),
      PreCheck(
          id: "oil",
          name: "Oil (Used Vehicles)",
          isSelect: _getCheckType(widget.preChecklist?.oil)),
      PreCheck(
          id: "checkTruckHeight",
          name: "Check Truck Height (4.3m)",
          isSelect: _getCheckType(widget.preChecklist?.checkTruckHeight)),
      PreCheck(
          id: "leftHandDamage",
          name: "Left Hand Damage",
          isSelect: _getCheckType(widget.preChecklist?.leftHandDamage)),
      PreCheck(
          id: "rightHandDamage",
          name: "Right Hand Damage",
          isSelect: _getCheckType(widget.preChecklist?.rightHandDamage)),
      PreCheck(
          id: "frontDamage",
          name: "Front Damage",
          isSelect: _getCheckType(widget.preChecklist?.frontDamage)),
      PreCheck(
          id: "rearDamage",
          name: "Rear Damage",
          isSelect: _getCheckType(widget.preChecklist?.rearDamage)),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _getCheckType(String? value) {
    if (value == "NO") {
      return false;
    }
    if (value == "NA") {
      return null;
    }
    return true;
  }

  _savePreChecklist() async {
    PageLoader.showLoader(context);
    Map<String, dynamic> data = {
      "id": 0,
      "jobId": widget.jobId,
      for (var c in checklist) c.id: c.isSelect.txt,
      "fuelLevel": fuelLevel,
      "notes": [
        {
          "id": 0,
          "jobId": widget.jobId,
          "vehicleId": 0,
          "trailerId": 0,
          "preDeparturechecklistId": 0,
          "visibletoDriver": true,
          "noteText": _textController.text
        }
      ]
    };
    if (mounted) Navigator.pop(context);

    log(data.toString());

    SuccessSheet.show(
      context: context,
      title: "Success",
      message: "Successfully submitted your pre departure checklist",
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(label: "Precheck"),
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
                        color: AppColors.primaryColor,
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
                    cursorColor: AppColors.primaryColor,
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    readOnly: widget.preChecklist != null,
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
              ignoring: widget.preChecklist != null,
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
                          color: AppColors.primaryColor,
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
            )
          ],
        )),
      ),
      bottomNavigationBar: widget.preChecklist == null
          ? SafeArea(
              child: SubmitButton(
              onTap: () {
                _savePreChecklist();
              },
              label: "Submit",
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
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          IgnorePointer(
            ignoring: widget.preChecklist != null,
            child: Container(
                height: 25.h,
                width: 25.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF416188))),
                child: PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  color: AppColors.bgColor,
                  constraints: BoxConstraints(
                    maxWidth: 60.h,
                  ),
                  child: Icon(
                    data.isSelect.icon,
                    color: data.isSelect.clr,
                    size: 20.h,
                  ),
                  onSelected: (int result) {
                    setState(() {
                      data.isSelect = result == 2 ? null : result == 1;
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
                  ],
                )),
          )
        ],
      ),
    );
  }
}

extension GetIcon on bool? {
  IconData get icon {
    if (this == null) {
      return Icons.remove;
    } else if (this!) {
      return Icons.check;
    } else {
      return Icons.close_rounded;
    }
  }
}

extension GetIconColor on bool? {
  Color get clr {
    if (this == null) {
      return Colors.white;
    } else if (this!) {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }
}

extension GetStatusText on bool? {
  String get txt {
    if (this == null) {
      return "NA";
    } else if (this!) {
      return "YES";
    } else {
      return "NO";
    }
  }
}
