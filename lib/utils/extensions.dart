import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get format => DateFormat("yyyy/MM/dd").format(this);
}
