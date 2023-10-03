import 'package:flutter/material.dart';

class FeedScrollController extends ScrollController {
  double _lastOffset = 0;

  void saveCurrentPosition() {
    _lastOffset = offset;
  }

  void restore() {
    position.restoreOffset(_lastOffset);
  }
}
