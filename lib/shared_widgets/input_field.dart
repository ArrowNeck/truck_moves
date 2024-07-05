import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truck_moves/constant.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;
  final int? maxLength;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final String? Function(String?)? validator;
  const InputField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    required this.textInputType,
    this.obscureText = false,
    this.maxLength,
    this.width,
    this.inputFormatters,
    this.readOnly = false,
    this.validator,
    required this.labelText,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50.h,
      width: widget.width ?? 320.w,
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.readOnly,
        style: TextStyle(
            color: Colors.black87,
            fontSize: 16.sp,
            decoration: TextDecoration.none),
        textAlignVertical: TextAlignVertical.center,
        cursorColor: primaryColor,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText ? isHide : widget.obscureText,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        decoration: InputDecoration(
          // labelText: widget.labelText,
          errorStyle: TextStyle(
            color: Colors.deepOrangeAccent[400],
            fontSize: 12.sp,
          ),
          // floatingLabelStyle: TextStyle(
          //   color: Colors.black87,
          //   fontSize: 15.sp,
          // ),
          counterText: "",
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.h),
            child: Icon(
              widget.prefixIcon,
              color: Colors.black45,
              size: 25.h,
            ),
          ),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: (() => setState(() {
                        isHide = !isHide;
                      })),
                  child: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Icon(
                      isHide
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black45,
                      size: 25.h,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(10.h),
                ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          fillColor: const Color(0xFFF6F6F6),
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: const Color(0xFFBDBDBD),
              fontSize: 16.sp,
              decoration: TextDecoration.none),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              borderRadius: BorderRadius.circular(8.h)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              borderRadius: BorderRadius.circular(8.h)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              borderRadius: BorderRadius.circular(8.h)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent[400]!),
              borderRadius: BorderRadius.circular(8.h)),
        ),
      ),
    );
  }
}
