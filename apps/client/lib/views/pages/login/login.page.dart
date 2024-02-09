import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/views/widgets/src/buttons/buttons.widget.dart';
import 'package:forgottenland/views/widgets/src/fields/custom_text_field.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController userCtrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'login',
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: _body(),
      );

  Widget _body() => Column(
        children: <Widget>[
          //
          Obx(
            () => Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: userCtrl.isLoggedIn.value ? _logoutBody() : _loginBody(),
            ),
          ),
        ],
      );

  Widget _loginBody() => Column(
        children: <Widget>[
          //
          _emailInput(),

          const SizedBox(height: 20),

          _passwordInput(),

          const SizedBox(height: 20),

          _primaryButton(),
        ],
      );

  Widget _logoutBody() => Column(
        children: <Widget>[
          //
          _userInfo(),

          const SizedBox(height: 20),

          _primaryButton(),
        ],
      );

  CustomTextField _emailInput() => CustomTextField(
        loading: userCtrl.isLoading.isTrue,
        label: 'E-mail',
        controller: userCtrl.emailCtrl,
        keyboardType: TextInputType.emailAddress,
      );

  CustomTextField _passwordInput() => CustomTextField(
        loading: userCtrl.isLoading.isTrue,
        label: 'Password',
        controller: userCtrl.passwordCtrl,
        obscureText: true,
      );

  Widget _userInfo() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            Text('User: ${userCtrl.data?.value.name ?? ''}'),

            const SizedBox(height: 10),

            Text('Status: ${userCtrl.data?.value.subscriber == true ? 'Premmium Account' : 'Free Account'}'),
          ],
        ),
      );

  PrimaryButton _primaryButton() => PrimaryButton(
        text: userCtrl.isLoggedIn.value ? 'Logout' : 'Login',
        onTap: userCtrl.isLoggedIn.value ? userCtrl.logout : userCtrl.login,
      );
}
