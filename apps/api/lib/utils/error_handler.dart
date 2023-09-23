import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

Response handleError(Object e) {
  if (e.toString().contains('Results contain 0 rows')) return ApiResponse.noContent();
  return ApiResponse.error(e);
}
