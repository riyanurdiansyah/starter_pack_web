import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../middleware/app_route.dart';

extension PaddingExtension on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}

String convertNumber(int num) {
  return NumberFormat.decimalPattern('id').format(num);
}

// String formatToThousandK(int value) {
//   // Membagi angka menjadi ribuan
//   double thousandValue = value / 1000;
//   // Format angka dengan pemisah ribuan
//   String formattedValue = NumberFormat("#,###", "id_ID").format(thousandValue);
//   return "${formattedValue}K";
// }

Future<DateTime?> globalDate() async {
  final date = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime.now().add(const Duration(days: 365)));
  if (date != null) {
    final time = await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (time != null) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }
  }

  return null;
}

Future<FilePickerResult?> pickFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  return result;
}
