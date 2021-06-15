
import 'package:flutter/material.dart';
import 'router_delegate.dart';

class ShoppingBackButtonDispatcher extends RootBackButtonDispatcher {
  final ShoppingRouterDelegate _routerDelegate;

  ShoppingBackButtonDispatcher(this._routerDelegate)
      : super();

  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}
