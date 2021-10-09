import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:overlock/router/back_dispatcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_state.dart';
import 'router/router_delegate.dart';
import 'router/shopping_parser.dart';
import 'router/ui_pages.dart';

bool USE_FIRESTORE_EMULATOR = false;
FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appState = AppState();
  ShoppingRouterDelegate delegate;
  final parser = ShoppingParser();

  ShoppingBackButtonDispatcher backButtonDispatcher;

  StreamSubscription _linkSubscription;

  _MyAppState() {
    delegate = ShoppingRouterDelegate(appState);
    delegate.setNewRoutePath(SplashPageConfig);
    // backButtonDispatcher = ShoppingBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    if (_linkSubscription != null) _linkSubscription.cancel();
    super.dispose();
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Attach a listener to the Uri links stream
    _linkSubscription = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        delegate.parseRoute(uri);
      });
    }, onError: (Object err) {
      print('Got error $err');
    });


  }



  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => appState,),
        ChangeNotifierProvider<List1Name>(create: (_) => List1Name()),
        ChangeNotifierProvider<List2Name>(create: (_) => List2Name()),
        ChangeNotifierProvider<List3Name>(create: (_) => List3Name()),
        ChangeNotifierProvider<List4Name>(create: (_) => List4Name()),
      ],
      child: MaterialApp.router(
        title: 'Overlock',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // backButtonDispatcher: backButtonDispatcher,
        routerDelegate: delegate,
        routeInformationParser: parser,
        backButtonDispatcher : backButtonDispatcher
      ),
    );
  }
}



class List1Name with ChangeNotifier {


String _List1Name = "육군";

String getList1Name() => _List1Name;

void setList1Name(String value) {
  _List1Name = value;
  notifyListeners(); //must be inserted
}

}
class List2Name with ChangeNotifier {
  String _List2Name = "동기";

  String getList2Name() => _List2Name;

  void setList2Name(String value) {
    _List2Name = value;
    notifyListeners(); //must be inserted
  }

}
class List3Name with ChangeNotifier {
  String _List3Name = "자유";

  String getList3Name() => _List3Name;

  void setList3Name(String value) {
    _List3Name = value;
    notifyListeners(); //must be inserted
  }

}
class List4Name with ChangeNotifier {
  String _List4Name = "0";

  String getList4Name() => _List4Name;

  void setList4Name(String value) {
    _List4Name = value;
    notifyListeners(); //must be inserted
  }

}