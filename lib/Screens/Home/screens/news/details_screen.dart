import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uet_app/utils/LauchUrl/lauch_url.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key key, this.title, this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    InAppWebViewController webView;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
          height: size.height,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(useOnDownloadStart: true),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onDownloadStart: (controller, url) async {
              print("onDownloadStart $url");
              LauchUrl.lauchUrl(url.toString());
            },
          )),
    );
  }
}
