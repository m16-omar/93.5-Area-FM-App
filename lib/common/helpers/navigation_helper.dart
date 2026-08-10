import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  NavigationHelper._();

  static void navigateTo(BuildContext context, String location, {Object? extra}) {
    context.push(location, extra: extra);
  }

  static void replaceWith(BuildContext context, String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  static void pop(BuildContext context, [Object? result]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }
}
