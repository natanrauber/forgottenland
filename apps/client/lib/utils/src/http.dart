import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';

class Http {
  factory Http() => _singleton;

  Http._internal() {
    _dio = Dio(getOptions());
  }

  static final Http _singleton = Http._internal();

  Dio _dio = Dio();

  BaseOptions getOptions() => BaseOptions(
        // connectTimeout: 10000,
        // baseUrl: PATH.api,
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        },
      );

  /// print request properties
  static void printRequest(
    String method,
    String url,
    Response<dynamic>? response, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) =>
      customPrint(
        '$method on "$url": ${response?.statusMessage} [${response?.statusCode}]',
        data: <String, dynamic>{
          'headers': headers,
          'body': body,
          'response': response?.data,
        },
      );

  Future<Response<dynamic>?> get(String path, {String baseUrl = PATH.tibiaDataApi}) async {
    Response<dynamic>? response;

    final String url = baseUrl + path;

    try {
      response = await _dio.get(url);
      printRequest('GET', url, response, headers: _dio.options.headers);
    } on DioError catch (e) {
      return HandleError.dio(e);
    } on SocketException catch (e) {
      HandleError.socket(e);
    } catch (e) {
      HandleError.fallback(e);
    }

    return response;
  }

  Future<Response<dynamic>?> post(String path, dynamic data, {String baseUrl = PATH.tibiaDataApi}) async {
    Response<dynamic>? response;

    final String url = baseUrl + path;

    try {
      response = await _dio.post(url, data: data);
      printRequest('GET', url, response, headers: _dio.options.headers, body: data);
    } on DioError catch (e) {
      return HandleError.dio(e);
    } on SocketException catch (e) {
      HandleError.socket(e);
    } catch (e) {
      HandleError.fallback(e);
    }

    return response;
  }

  /// [HTTP request handler]
  static Future<dynamic>? handleRequest(
    BuildContext context, {
    required Future<Response<dynamic>?> Function() request,
    dynamic Function(Response<dynamic>? response)? onSuccess,
    bool showLoading = true,
    bool showError = true,
    dynamic Function(Response<dynamic>? response)? onError,
  }) async {
    /// show loading
    if (showLoading) Alert.loading(context);

    /// call request
    await request.call().then(
      (Response<dynamic>? response) async {
        /// pop loading
        if (showLoading) Alert.pop(context);

        /// successful request
        /// calls onSuccess
        if (response is Response && response.statusCode == 200) {
          return onSuccess?.call(response);
        }

        /// on error
        else {
          /// calls custom error handler
          if (showError && onError != null) {
            onError.call(response);
          }

          /// calls default error handler
          else {
            await handleError(
              context,
              response: response,
              showError: showError,
            );
          }
        }
      },
    );
    return null;
  }

  static Future<void> handleError(
    BuildContext context, {
    required Response<dynamic>? response,
    bool showError = true,
  }) async {
    if (response is Response) {
      /// internal server error
      if (showError && response.statusCode == 500) {
        Alert.show(
          context,
          iconColor: AppColors.red,
          title: 'Internal error',
          content: 'Please try again or contact support.',
          primaryButtonText: 'Close',
        );
      }

      /// default onError with statusMessage
      else if (showError) {
        Alert.show(
          context,
          iconColor: AppColors.red,
          title: 'Internal error',
          content: '${response.statusMessage ?? ''}. Please try again or contact support.',
          primaryButtonText: 'Close',
        );
      }
    }

    /// default onError
    else if (showError) {
      Alert.show(
        context,
        iconColor: AppColors.red,
        title: 'Internal error',
        content: 'Please try again or contact support.',
        primaryButtonText: 'Close',
      );
    }
  }
}
