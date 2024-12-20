import 'package:flutter/material.dart';
import 'package:starter_pack_web/utils/app_color.dart';

InputDecoration textFieldAuthDecoration(
    {required double fontSize, required String hintText, double? radius}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
    labelStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
    ),
    fillColor: Colors.white.withOpacity(0.8),
    filled: true,
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 14,
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(5)),
    errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(5)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(5)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: colorPrimaryDark,
      ),
      borderRadius: BorderRadius.circular(radius ?? 6),
    ),
  );
}
