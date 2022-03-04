import 'package:url_launcher/url_launcher.dart';

class LauchUrl {
  static void lauchPDFUrl(String url) async {
    url = 'http://112.137.129.30/viewgrade/' + url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
