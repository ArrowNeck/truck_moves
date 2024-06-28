import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/config.dart';
import 'package:truck_moves/models/job_header.dart';
import 'package:truck_moves/models/pre_checklist_model.dart';
import 'package:truck_moves/shared_widgets/app_bar.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';
import 'package:truck_moves/ui/mp/jobs/job_details.dart';

class PreDepartureChecklist extends StatefulWidget {
  final JobHeader job;
  const PreDepartureChecklist({super.key, required this.job});

  @override
  State<PreDepartureChecklist> createState() => _PreDepartureChecklistState();
}

class _PreDepartureChecklistState extends State<PreDepartureChecklist> {
  late TextEditingController _textController;
  int fuelLevel = 0;
  List<PreChecklistModel> checklistData = [
    PreChecklistModel(id: 1, name: "Water (Used Vehicles)", isSelect: true),
    PreChecklistModel(id: 2, name: "All lights & Indicators", isSelect: true),
    PreChecklistModel(id: 3, name: "Owners Manual", isSelect: true),
    PreChecklistModel(id: 4, name: "Tyres Condition", isSelect: true),
    PreChecklistModel(
        id: 5, name: "Windscreen Damage / Wipers", isSelect: true),
    PreChecklistModel(id: 6, name: "Keys / Fob - Total Keys", isSelect: true),
    PreChecklistModel(id: 7, name: "Oil (Used Vehicles)", isSelect: true),
    PreChecklistModel(id: 8, name: "Left Hand Damage", isSelect: true),
    PreChecklistModel(id: 9, name: "Front Damage", isSelect: true),
    PreChecklistModel(id: 10, name: "Spare Rim", isSelect: true),
    PreChecklistModel(id: 11, name: "Jack and Tools", isSelect: true),
    PreChecklistModel(id: 12, name: "Air & Electrics [Secure]", isSelect: true),
    PreChecklistModel(
        id: 13, name: "Visually Dip Fuel & Check Taps", isSelect: true),
    PreChecklistModel(
        id: 14, name: "Vehicle Clean & Free of Rubbish", isSelect: true),
    PreChecklistModel(
        id: 15,
        name: "Check Inside Truck & Trailer for loose or unrestrained loads",
        isSelect: true),
    PreChecklistModel(
        id: 16, name: "Check Truck Height (4.3m)", isSelect: true),
    PreChecklistModel(id: 17, name: "Right Hand Damage", isSelect: true),
    PreChecklistModel(id: 18, name: "Rear Damage", isSelect: true),
  ];

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
            ...checklistData.map((e) => _card(e)),
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
            Container(
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
                      _fuelLevel(color: Colors.red, label: "E", level: 1),
                      _fuelLevel(color: Colors.orange, label: "1/4", level: 2),
                      _fuelLevel(color: Colors.yellow, label: "1/2", level: 3),
                      _fuelLevel(color: Colors.green, label: "3/4", level: 4),
                      _fuelLevel(
                          color: Colors.greenAccent[700]!,
                          label: "F",
                          level: 5),
                    ],
                  )
                ],
              ),
            )
          ],
        )),
      ),
      bottomNavigationBar: SafeArea(
          child: SubmitButton(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => JobDetails(
                        job: widget.job,
                      )));
        },
        label: "Submit",
        marginW: 16.w,
        marginH: 8.h,
      )),
    );
  }

  _fuelLevel(
      {required Color color, required String label, required int level}) {
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

  _card(PreChecklistModel data) {
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
          Container(
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
                  data.isSelect.icon(),
                  color: data.isSelect.clr(),
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
              ))
        ],
      ),
    );
  }
}

extension GetIcon on bool? {
  IconData icon() {
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
  Color clr() {
    if (this == null) {
      return Colors.white;
    } else if (this!) {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }
}
