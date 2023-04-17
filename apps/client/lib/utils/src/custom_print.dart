import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

/// define [customPrint]
typedef CustomPrintCallback = void Function(
  String? message, {
  Map<String, dynamic> data,
});
CustomPrintCallback customPrint = _customPrintRelease;

/// define [customPrint] modes
enum CustomPrintMode {
  dev,
  debug,
  release,
}

/// configure [customPrint]
///
/// custom print modes:
/// * `dev` print [timeStamp()] + [message]
/// * `debug` print [timeStamp()] + [message] + [data]
/// * `release` do nothing
///
/// [customPrint] auto turns off on `release` mode
void configureCustomPrint(CustomPrintMode mode) {
  if (mode == CustomPrintMode.release) {
    customPrint = _customPrintRelease;
  } else if (mode == CustomPrintMode.dev) {
    customPrint = _customPrintDev;
  } else if (mode == CustomPrintMode.debug) {
    customPrint = _customPrintDebug;
  }
}

void _customPrintRelease(String? message, {dynamic data}) {}

void _customPrintDev(String? message, {dynamic data}) {
  debugPrint('[${MyDateTime.timeStamp()}] $message');
}

void _customPrintDebug(String? message, {Map<String, dynamic>? data}) {
  const JsonEncoder encoder = JsonEncoder.withIndent(' ');
  final String prettyprint = encoder.convert(data);

  debugPrint('\n[${MyDateTime.timeStamp()}]');
  debugPrint(message);
  if (data != null) debugPrint(prettyprint, wrapWidth: 10000);
}
