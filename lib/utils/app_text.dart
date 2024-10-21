import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextNormal {
  static Text labelNormal(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
    double? wordSpacing,
    double? letterSpacing,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: 'Bigail',
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1.0,
        wordSpacing: wordSpacing ?? 1,
        letterSpacing: letterSpacing ?? 1,
      ),
    );
  }

  static Text labelW400(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
    FontStyle? fontStyle,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
          fontFamily: 'Bigail',
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
          color: colors,
          fontStyle: fontStyle ?? FontStyle.normal,
          height: height ?? 1.0),
    );
  }

  static Text labelW500(String title, double fontSize, Color colors,
      {String? familiy,
      TextAlign? textAlign,
      TextOverflow? overflow,
      int? maxLines,
      FontStyle? fontStyle,
      double? height,
      bool? softWarp,
      double? letterSpacing}) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: 'Bigail',
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: colors,
        fontStyle: fontStyle ?? FontStyle.normal,
        height: height ?? 1.0,
      ),
    );
  }

  static Text labelW600(String title, double fontSize, Color colors,
      {String? familiy,
      TextAlign? textAlign,
      TextOverflow? overflow,
      int? maxLines,
      double? height,
      FontStyle? fontStyle,
      double? letterSpacing}) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.abel(
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: colors,
        fontStyle: fontStyle ?? FontStyle.normal,
        height: height ?? 1.0,
      ),
    );
  }

  static Text labelW700(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: 'Bigail',
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1.0,
      ),
    );
  }

  static Text labelW800(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: 'Bigail',
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static Text labelW900(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: 'Bigail',
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static Text labelBold(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: 'Bigail',
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1.0,
      ),
    );
  }
}
