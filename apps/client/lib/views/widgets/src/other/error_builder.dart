import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';

class ErrorBuilder extends Container {
  ErrorBuilder.notFound()
      : super(
          height: 110,
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          child: const Text('Character not found'),
        );

  ErrorBuilder.notAcceptable()
      : super(
          height: 110,
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          child: const Text('Character is not in Rookgaard'),
        );

  ErrorBuilder.serverError({void Function()? onTapRetry})
      : super(
          height: 110,
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const Text('Internal server error'),
              if (onTapRetry != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onTapRetry,
                    child: const Text(
                      'Try again',
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
}
