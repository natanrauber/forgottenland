// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';

class Alert {
  /// show alert dialog
  static Future<void> show(
    BuildContext context, {
    IconData icon = CupertinoIcons.exclamationmark_circle,
    Color iconColor = AppColors.blue,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    Function()? primaryButtonAction,
    Function()? secondaryButtonAction,
    Duration? duration,
  }) async {
    dismissKeyboard(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        /// optional timer
        if (duration != null) {
          Timer(duration, () => Navigator.pop(context));
        }

        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(32),
            titlePadding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
            buttonPadding: EdgeInsets.zero,
            title: Column(
              children: <Widget>[
                /// title icon
                Icon(
                  icon,
                  size: 60,
                  color: iconColor,
                ),

                const SizedBox(height: 12),

                /// title text
                SelectableText(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// content text
                SelectableText(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                /// buttons
                if (primaryButtonText != null || secondaryButtonText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// secondary button
                        if (secondaryButtonText != null)
                          Container(
                            height: 44,
                            width: (MediaQuery.of(context).size.width - 158) / 2,
                            margin: const EdgeInsets.only(right: 30),
                            child: ElevatedButton(
                              onPressed: () => secondaryButtonAction?.call(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  side: const BorderSide(
                                    color: AppColors.blue,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                secondaryButtonText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),

                        /// primary button
                        if (primaryButtonText != null)
                          SizedBox(
                            height: 44,
                            width: (MediaQuery.of(context).size.width - 158) / 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                primaryButtonAction?.call();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                primaryButtonText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// show loading dialog
  static void loading(BuildContext context) {
    dismissKeyboard(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.bgDefault,
        insetPadding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 2) - 45,
        ),
        contentPadding: const EdgeInsets.all(25),
        content: const Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// hide dialog
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
