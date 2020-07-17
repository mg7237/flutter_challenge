import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PrivacyPolicy extends StatelessWidget {
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter WebView Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => new WebviewScaffold(
              url: "https://mg7237.github.io/mycv/privacy.html",
              appBar: new AppBar(
                title: const Text('Privacy Policy'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Waiting.....'),
                ),
              ),
            ),
      },
    );
  }
}
