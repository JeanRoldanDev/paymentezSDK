import 'dart:async';
import 'dart:developer';

import 'package:app_example/page_inappwebview.dart';
import 'package:app_example/page_webview.dart';
import 'package:app_example/radio_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paymentez_sdk/models/request/card/user_card.dart';
import 'package:paymentez_sdk/paymentez_controller.dart';
import 'package:paymentez_sdk/paymentez_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff028d64),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: 'PaymentezSDK Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff028d64)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _paymentezCtrl = PaymentezController(isProd: false);

  int _typeBrowserPluging = 1;
  String urlView = '';

  @override
  void initState() {
    _paymentezCtrl.onResult().listen((event) {
      log('NEW EVENT SDK: $event');
    });
    super.initState();
  }

  String getIdUser() {
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final currentTimeInSeconds = (currentTimeMillis / 1000).floor();
    return currentTimeInSeconds.toString();
  }

  Future<void> initFormAddCard() async {
    final sdk = PaymentezSDK(
      serverApplicationCode: 'TEST',
      serverAppKey: 'TEST',
    );

    final (resp, error) = await sdk.addCard(
      CardRequest(
        user: UserCard(id: getIdUser(), email: 'jhon@doe.com'),
        locale: 'es',
        requireBillingAddress: false,
      ),
    );
    if (error != null) {
      return;
    }

    if (resp!.tokenizeURL != null) {
      setState(() {
        urlView = resp.tokenizeURL!;
      });
    }
  }

  void onSave() {
    _paymentezCtrl.onSaveCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight / 2),
            child: Image.asset(
              'assets/banner.png',
              height: 80,
            ),
          ),
          RadioGroup(
            onChanged: (value) {
              setState(() {
                _typeBrowserPluging = value;
              });
            },
          ),
          Expanded(
            child: _typeBrowserPluging == 1
                ? PageInappWebview(
                    url: urlView,
                    paymentezCtrl: _paymentezCtrl,
                  )
                : PageWebView(
                    url: urlView,
                    paymentezCtrl: _paymentezCtrl,
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: initFormAddCard,
            tooltip: 'IniFormAddCard',
            backgroundColor: const Color(0xff028d64),
            child: const Icon(Icons.auto_fix_high_rounded),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            onPressed: onSave,
            tooltip: 'OnSave',
            backgroundColor: const Color(0xff028d64),
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
