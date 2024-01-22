import 'dart:convert';

enum PrintType {
  plainText,
  json,
}

enum PrintColor {
  white,
  red,
  green,
  yellow,
}

void customPrint(Object? object, {PrintType type = PrintType.plainText, PrintColor color = PrintColor.white}) {
  if (type == PrintType.json) object = JsonEncoder.withIndent(' ').convert(object);

  if (color == PrintColor.red) return print('\x1B[31m$object\x1B[0m');
  if (color == PrintColor.green) return print('\x1B[32m$object\x1B[0m');
  if (color == PrintColor.yellow) return print('\x1B[33m$object\x1B[0m');
  return print(object);
}
