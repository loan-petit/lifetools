import 'package:flutter/material.dart';

/// Application UI configuration depending on screen constraints and orientation.
class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  static double bodyHorizontalMargin = 0;

  static double sizeMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  /// Initialize the class based on provided screen [constraints] and [orientation].
  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      sizeMultiplier = 1.1;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
        sizeMultiplier = 1;
      }
    } else {
      bodyHorizontalMargin = constraints.maxWidth / 5;
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
      sizeMultiplier = 1.3;
    }

    blockSizeHorizontal = _screenWidth / 100;
    blockSizeVertical = _screenHeight / 100;
  }
}
