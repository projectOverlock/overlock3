import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_state.dart';
import 'router/back_dispatcher.dart';
import 'router/router_delegate.dart';
import 'router/shopping_parser.dart';
import 'router/ui_pages.dart';


bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  //ShoppingBackButtonDispatcher backButtonDispatcher;

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

    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final QuerySnapshot result = await _firestore
        .collection('users')
        .where(_auth.currentUser.uid)
        .get();

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) => _auth.currentUser.updateProfile(displayName: value['name']));

    await prefs.setString('id', _auth.currentUser.uid);
    await prefs.setString('name', _auth.currentUser.displayName);
    await prefs.setString('photoUrl', _auth.currentUser.photoURL);

  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);

    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: MaterialApp.router(
        title: 'Navigation App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
       // backButtonDispatcher: backButtonDispatcher,
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );
    
  }
}
