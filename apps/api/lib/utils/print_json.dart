import 'dart:convert';

void printJson(Map<String, dynamic> data) {
  const JsonEncoder encoder = JsonEncoder.withIndent(' ');
  print(encoder.convert(data));
}
