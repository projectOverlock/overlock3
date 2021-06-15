import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class myTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Container(
        height: 50,

        color: kPrimaryColor,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/splash_overlock1.png',
                      fit: BoxFit.contain,
                      height: 22,
                    ),
                    Text(
                      '  OVERLOCK',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 1),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () => appState.currentAction = PageAction(
                          state: PageState.addPage, page: SettingsPageConfig),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart_sharp,
                          size: 18, color: Colors.white),
                      onPressed: () => appState.currentAction = PageAction(
                          state: PageState.addPage, page: CheckoutPageConfig),
                    )
                  ],
                ),
              )
            ]));
  }
}
