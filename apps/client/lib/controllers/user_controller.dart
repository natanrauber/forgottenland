// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/rxmodels/user_rxmodel.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class UserController extends Controller {
  RxBool isLoggedIn = false.obs;

  RxUser? data;

  TextController emailCtrl = TextController();
  TextController passwordCtrl = TextController();

  Future<MyHttpResponse> login() async {
    isLoading.value = true;

    final MyHttpResponse response = await MyHttpClient().post(
      '${PATH.forgottenLandApi}/login',
      <String, dynamic>{
        'email': emailCtrl.text,
        'password': passwordCtrl.text,
        'device': (await DeviceInfoPlugin().deviceInfo).data.toString(),
      },
    );

    if (response.success) {
      document.cookie = 'session_id=${response.dataAsMap['data']['session_id']}';
      isLoggedIn.value = true;
      data = User.fromJson(response.dataAsMap['data'] as Map<String, dynamic>).obs;
    }

    isLoading.value = false;
    return response;
  }

  Future<Response<dynamic>?> logout() async {
    isLoading.value = true;
    data = null;
    isLoggedIn.value = false;
    document.cookie = 'session_id=';
    isLoading.value = false;
    return null;
  }

  Future<MyHttpResponse?> retrieveSession() async {
    if (isLoggedIn.value) return null;
    if (isLoading.isTrue) return null;

    final String? sessionId = _retrieveSessionId();
    if (sessionId == null) return null;

    isLoading.value = true;

    final MyHttpResponse response = await MyHttpClient().post(
      '${PATH.forgottenLandApi}/revive',
      <String, dynamic>{
        'session_id': sessionId,
      },
    );

    if (response.success) {
      isLoggedIn.value = true;
      data = User.fromJson(response.dataAsMap['data'] as Map<String, dynamic>).obs;
    }

    isLoading.value = false;
    return response;
  }

  String? _retrieveSessionId() {
    final String? cookies = document.cookie;

    if (cookies == null || cookies.isEmpty) return null;

    final Iterable<MapEntry<String, dynamic>> entity = cookies.split('; ').map(
      (String item) {
        final List<String> split = item.split('=');
        return MapEntry<String, dynamic>(split[0], item.replaceAll('${split[0]}=', ''));
      },
    );
    final Map<String, dynamic> cookieMap = Map<String, dynamic>.fromEntries(entity);
    final String? sessionId = cookieMap['session_id'] as String?;

    if (sessionId == null || sessionId.isEmpty) return null;
    return sessionId;
  }
}
