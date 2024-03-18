// ignore_for_file: avoid_print, use_colored_box

import 'package:app_example/enviroment.dart';
import 'package:app_example/page_inappwebview.dart';
import 'package:app_example/page_webview.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _paymentezCtrl = PaymentezController(isProd: false);

  String urlView = '';
  final type = false;

  Future<void> initForm() async {
    final sdk = PaymentezSDK(
      clientApplicationCode: Environment.clientAppCode,
      clientAppKey: Environment.clientAppKey,
      serverAppKey: Environment.clientAppKey,
      serverApplicationCode: Environment.clientAppCode,
    );

    final (resp, error) = await sdk
        .addCard(CardRequest(user: UserCard(id: '1231', email: 'adfadfasd')));
    if (error != null) {
      print('ERROR CALL SERVICES');
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: type
          ? PageWebView(
              url: urlView,
              paymentezCtrl: _paymentezCtrl,
            )
          : PageInappWebview(
              url: urlView,
              paymentezCtrl: _paymentezCtrl,
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: initForm,
            tooltip: 'IniForm',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            onPressed: onSave,
            tooltip: 'OnSave',
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
