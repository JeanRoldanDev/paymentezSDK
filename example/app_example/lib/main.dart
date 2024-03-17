// ignore_for_file: avoid_print, use_colored_box

import 'package:app_example/enviroment.dart';
import 'package:app_example/page_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

enum WebViewClient { inAppWebView, webView }

class _MyHomePageState extends State<MyHomePage> {
  final typePluging = WebViewClient.inAppWebView;
  String urlView = '';
  InAppWebViewController? ctrl;

  final sdk = PaymentezSDK(
    clientApplicationCode: Environment.clientAppCode,
    clientAppKey: Environment.clientAppKey,
    serverAppKey: Environment.clientAppKey,
    serverApplicationCode: Environment.clientAppCode,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _incrementCounter() async {
    final (resp, error) = await sdk
        .addCard(CardRequest(user: UserCard(id: '1231', email: 'adfadfasd')));
    if (error != null) {
      return;
    }

    if (resp!.tokenizeURL != null) {
      setState(() {
        urlView = resp.tokenizeURL!;
      });
      // await ctrl?.loadUrl(
      //   urlRequest: URLRequest(
      //     url: WebUri(
      //       resp.tokenizeURL!,
      //     ),
      //   ),
      // );
    }
  }

  Future<dynamic> newEvaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {}

  void enviar() {
    const javascript = '''
        let message = { type: "tokenize", data: null };
        window.postMessage(message, "https://ccapi-stg.paymentez.com");
      ''';

    // Ejecuta el JavaScript en el WebView
    ctrl!.evaluateJavascript(source: javascript);
  }

  Future<void> hola() async {
    if (ctrl != null) {
      const yourCode = '''
       window.addEventListener("message", (event) => {
        console.log("nueveo mensaje desde dart");
        console.log(event);
        if (event.origin !== "https://ccapi-stg.paymentez.com") {
          return
        }

        const msg = event.data;
        console.log(msg.data);
        switch (msg.type) {
          case "incomplete_form":
            console.warn("incomplete_form");
            window.flutter_inappwebview.callHandler('getDataFromWebView', { key: 'value' }).then(function(result) {
              console.log("Resultado de Flutter: " + result);
            });
            break;
          case "tokenize_response":
            console.warn("tokenize_response");
            break;
        }
      });
        ''';
      await ctrl!.evaluateJavascript(source: yourCode);

      ctrl!.addJavaScriptHandler(
        handlerName: 'getDataFromWebView',
        callback: (dat) {
          print('LLEGO ALGO: $dat');
        },
      );
    }
  }

  final paymentezCtrl = PaymentezController(isProd: false);
  void test() {
    paymentezCtrl.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: PageInappWebview(
        url: urlView,
        paymentezCtrl: paymentezCtrl,
      ),
      // body: InAppWebView(
      //   onConsoleMessage: (ctrler, consoleMessage) {
      //     log(consoleMessage.message);
      //     // print('=========RECIVE CONSOLE');
      //     // print(ctrler);
      //     // print(consoleMessage.message);
      //     // print(consoleMessage.toJson());
      //     // print(consoleMessage.toMap());
      //     // print(consoleMessage);
      //   },
      //   initialUrlRequest: URLRequest(
      //     url: WebUri(''),
      //   ),
      //   onWebViewCreated: (controller) async {
      //     print('onWebViewCreated');
      //     ctrl = controller;
      //   },
      //   onLoadStart: (controller, url) async {
      //     // print('onLoadStart');
      //   },
      //   onProgressChanged: (controller, progress) {
      //     // print('progress $progress');
      //   },
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            onPressed: hola,
            tooltip: 'Increment',
            child: const Icon(Icons.voice_chat),
          ),
          FloatingActionButton(
            onPressed: enviar,
            tooltip: 'Increment',
            child: const Icon(Icons.message),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            onPressed: test,
            tooltip: 'Increment',
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }
}
