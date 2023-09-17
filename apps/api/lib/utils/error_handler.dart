import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:shelf/shelf.dart';

Response handleError(Object e) {
  if (e.toString().contains('Results contain 0 rows')) return ApiResponseNoContent();
  return ApiResponseError(e);
}
