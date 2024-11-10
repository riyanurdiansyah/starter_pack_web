import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension PaddingExtension on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}

String convertNumber(int num) {
  return NumberFormat.decimalPattern('id').format(num);
}
