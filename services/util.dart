import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

bool areDatesEqual(DateTime dt1, DateTime dt2) {
  return (dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day);
}

bool isDateAllowed(DateTime date, List<DateTime> allowedDates) {
  for (DateTime dt in allowedDates) {
    if (areDatesEqual(date, dt)) {
      return true;
    }
  }
  return false;
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}

Future<Uint8List> getUint8List(GlobalKey markerKey) async {
  RenderRepaintBoundary boundary = markerKey.currentContext.findRenderObject();
  var image = await boundary.toImage(pixelRatio: 2.0);
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData.buffer.asUint8List();
}
