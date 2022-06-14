import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'app_state.dart';
import 'routes/router_delegate.dart';
import 'routes/back_dispatcher.dart';
import 'routes/shopping_parser.dart';
import 'routes/ui_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final appState = AppState();
  late ShoppingRouterDelegate delegate;
  final parser = ShoppingParser();
  late ShoppingBackButtonDispatcher backButtonDispatcher;

  late StreamSubscription _linkSubscription;

  MyAppState() {
    delegate = ShoppingRouterDelegate(appState);
    delegate.setNewRoutePath(splashPageConfig);
    backButtonDispatcher = ShoppingBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  @override
  void dispose() {
 _linkSubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Attach a listener to the Uri links stream
    _linkSubscription = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      if (uri != null) {
              setState(() {
        delegate.parseRoute(uri);
      });
      }

    }, onError: (Object err) {
      log('Got error $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: MaterialApp.router(
        title: 'Navigation App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        backButtonDispatcher: backButtonDispatcher,
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );
  }
}
