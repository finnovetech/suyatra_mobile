import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExternalUrls extends StatefulWidget {
  final String url;
  const WebViewExternalUrls({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewExternalUrls> createState() => _WebViewExternalUrlsState();
}

class _WebViewExternalUrlsState extends State<WebViewExternalUrls> {


  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
      // body: WebView(
      //   initialUrl: widget.url,
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}
