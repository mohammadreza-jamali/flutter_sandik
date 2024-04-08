import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/core/application/navigation_service.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/constants/app_style.dart';
import 'package:flutter_sandik/locator.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ConstWidget {
  ConstWidget() {
    _context = locator<NavigationService>().navigatorKey.currentContext;

    _preference = SharedPreferenceManager.getInstanse();
  }
  late BuildContext? _context;
  late SharedPreferenceManager _preference;

  static showAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text("head").tr(),
      content: Text("content").tr(),
      actions: [
        TextButton(
          child: Text("cancel").tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text("ok").tr(),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  showSuccessDialog(String message) {
    showCustomAlertDialog(_context!,
        header: Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          decoration: BoxDecoration(
              color: AppStyle.deepGreen,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
          child: Material(
              shape: CircleBorder(),
              color: Colors.white,
              child: Icon(
                Icons.done,
                color: AppStyle.deepGreen,
                size: 60,
              )),
        ),
        body: Container(child: Text(message).tr()),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(_context!).pop();
              },
              child: Text("Ok").tr())
        ]);
  }

  showFailedDialog(String message) {
    showCustomAlertDialog(_context!,
        header: Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          decoration: BoxDecoration(
            color: AppStyle.deepRed,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Icon(
            Icons.new_releases,
            color: Colors.white,
            size: 70,
          ),
        ),
        body: Container(
            child: Text(
          message,
          style: TextStyle(color: Theme.of(_context!).cardColor),
        ).tr()),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(_context!).pop();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    color: Theme.of(_context!).textTheme.headline1!.color),
              ).tr())
        ]);
  }

  static showCustomAlertDialog(BuildContext context,
      {Widget? header, Widget? body, List<Widget>? actions}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            titlePadding: EdgeInsets.all(0),
            title: header != null ? header : null,
            content: body != null ? body : null,
            actions: actions != null ? actions : null));
  }

  static showTost(String message, {Color? backgroundColor, double? fontsize}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor ?? AppStyle.deepGreen,
        textColor: AppStyle.mainColor,
        fontSize: fontsize ?? 16.0);
  }

  static showBottomModal(BuildContext context, Widget child,
      {AnimationController? controller}) {
    showModalBottomSheet<void>(
      transitionAnimationController: controller,
      context: context,
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
