import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get format => DateFormat("yyyy/MM/dd").format(this);
}

extension ToastTitle on int {
  String get iconName => switch (this) {
        7 => "stay-night",
        9 => "final-destination",
        15 => "",
        _ => "",
      };
}

extension ToastMessage on int {
  String get message => switch (this) {
        7 => "driving and will stay for the night",
        9 => "your current job upon reaching the final destination",
        15 => "",
        _ => "",
      };
}

extension GetIcon on int {
  IconData get icon => switch (this) {
        0 => Icons.close_rounded,
        1 => Icons.check,
        2 => Icons.remove,
        _ => Icons.more_horiz_rounded,
      };
}

extension GetIconColor on int {
  Color get clr => switch (this) {
        0 => Colors.redAccent,
        1 => Colors.greenAccent,
        2 => Colors.white,
        _ => Colors.grey,
      };
}

extension GetStatusText on int {
  String get txt => switch (this) {
        0 => "NO",
        1 => "YES",
        2 => "NA",
        _ => "...",
      };
}

extension GetStatusType on String? {
  int get type => switch (this) {
        "NO" => 0,
        "YES" => 1,
        "NA" => 2,
        _ => 3,
      };
}
