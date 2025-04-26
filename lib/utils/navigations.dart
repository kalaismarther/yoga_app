import 'package:flutter/material.dart';

class Nav {
  static Future push(BuildContext context, Widget widgetName) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => widgetName));
  }

  static Future pop(BuildContext context) async {
    return Navigator.pop(context);
  }

  static Future replace(BuildContext context, Widget widgetName) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widgetName));
  }

  static Future clearAndGo(
      BuildContext context, Widget widgetName, String routeName) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widgetName),
      ModalRoute.withName(routeName),
    );
  }
}
