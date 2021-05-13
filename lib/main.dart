import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<String>(
          initialData: '',
          future: InAppWebViewController.getDefaultUserAgent(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == '') {
              return Text('loading');
            }

            return InAppWebView(
              key: webViewKey,
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      userAgent:
                          '${snapshot.data} MochiCloud MochiCloudGeneric')),
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://storage.googleapis.com/autoplus-alpha/mochi-cloud-demo/js_bridge_demo.html')),
              onWebViewCreated: (controller) {
                controller.addJavaScriptHandler(
                    handlerName: 'toggleAutoRefresh',
                    callback: (args) {
                      print('toggleAutoRefresh: $args');
                    });
                controller.addJavaScriptHandler(
                    handlerName: 'onMochipaySettingSuccess',
                    callback: (args) {
                      print('onMochipaySettingSuccess: $args');
                    });
                controller.addJavaScriptHandler(
                    handlerName: 'onMochipaySettingFail',
                    callback: (args) {
                      print('onMochipaySettingFail: $args');
                    });
              },
              onLoadStart: (controller, url) {
                controller
                    .injectJavascriptFileFromAsset(
                        assetFilePath: 'assets/bridge.js')
                    .then((value) => {print("js loaded")});
              },
            );
          }),
    );
  }
}
