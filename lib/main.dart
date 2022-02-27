import 'package:flutter/material.dart';
import 'package:uet_app/Screens/Home/home_screen.dart';
import 'package:uet_app/Screens/Login/login_sreen.dart';
import 'package:uet_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print(token);

  runApp(MyApp(
    home: token == null ? LoginScreen() : HomeScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp({
    Key key,
    @required this.home,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UET APP',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: home,
    );
  }
}
