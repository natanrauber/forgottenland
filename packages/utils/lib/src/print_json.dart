import 'dart:convert';
import 'dart:developer';

void printJson(Map<String, dynamic> data) {
  const JsonEncoder encoder = JsonEncoder.withIndent(' ');
  log(encoder.convert(data));
}
