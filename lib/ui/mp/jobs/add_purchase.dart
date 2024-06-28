import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_moves/config.dart';

class AddPurchase extends StatefulWidget {
  const AddPurchase({super.key});

  @override
  State<AddPurchase> createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  XFile? file;

  _pickImage(ImageSource source) async {
    try {
      file = await ImagePicker().pickImage(source: source);
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 428.w,
          ),
          Container(
            width: 350.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              children: [
                Text(
                  "Add Purchase",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: 250.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF416188)),
                      borderRadius: BorderRadius.circular(8.h)),
                  child: file != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.h),
                          child: Stack(
                            children: [
                              Image.file(
                                File(file!.path),
                                height: 250.h,
                                width: 300.w,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    file = null;
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
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.camera),
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.white,
                                size: 25.h,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.gallery),
                              child: Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Colors.white,
                                size: 30.h,
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text("Please take a photo of the receipt",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          splashColor: AppColors.primaryColor.withOpacity(0.4),
                          customBorder: const StadiumBorder(),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 1.5.w)),
                              width: 125.w,
                              height: 45.h,
                              child: SizedBox(
                                width: 90.w,
                                height: 30.h,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ))),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          splashColor: AppColors.primaryColor.withOpacity(0.4),
                          customBorder: const StadiumBorder(),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color: AppColors.primaryColor,
                                  border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 1.5.w)),
                              width: 125.w,
                              height: 45.h,
                              child: SizedBox(
                                width: 90.w,
                                height: 30.h,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ))),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
