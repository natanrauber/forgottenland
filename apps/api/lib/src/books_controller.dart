import 'dart:convert';

import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

abstract class IBooksController {
  Future<Response> getAll(Request request);
}

class BooksController implements IBooksController {
  BooksController(this.httpClient);

  final IHttpClient httpClient;

  @override
  Future<Response> getAll(Request request) async {
    try {
      MyHttpResponse response = await httpClient.get(
        'https://raw.githubusercontent.com/s2ward/tibia/main/data/books/book_database.json',
      );
      response.data = jsonDecode(response.data);

      List<dynamic> filteredList = <dynamic>[];
      for (dynamic e in response.dataAsList) {
        if (e is Map<String, dynamic>) {
          if (e['locations'] is List<dynamic>) {
            if ((e['locations'] as List<dynamic>)
                .any((dynamic element) => element is String && element.toLowerCase().contains('rookgaard'))) {
              filteredList.add(e);
            }
          }
        }
      }

      return ApiResponse.success(data: filteredList);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
