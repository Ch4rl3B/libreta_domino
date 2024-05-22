import 'package:flutter/material.dart';
import 'package:libreta_domino/core/styles/app_colors.dart';

class ColorSchemes {
  static ColorScheme light = ColorScheme.fromSwatch(
    brightness: Brightness.light,
    primarySwatch: AppColors.primarySwatch,
    backgroundColor: Colors.white,
    cardColor: AppColors.cardColor,
  );

  static ColorScheme dark = ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: AppColors.primarySwatch,
  );
}
