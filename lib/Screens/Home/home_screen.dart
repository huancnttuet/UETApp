import 'package:flutter/material.dart';
import 'package:uet_app/Screens/Home/components/body.dart';
import 'package:uet_app/Screens/Home/screens/grades/grades_screen.dart';
import 'package:uet_app/Screens/Home/screens/news/news_screen.dart';
import 'package:uet_app/Screens/Home/screens/settings/settings_screen.dart';
import 'package:uet_app/configs/const.dart';
import 'package:uet_app/models/BottomNavBar/bottom_navbar_model.dart';
import 'package:uet_app/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return BottomNavBarModel();
      },
      child: Scaffold(
        // appBar: AppBar(),
        body: Consumer<BottomNavBarModel>(
          builder: (BuildContext context, value, Widget child) {
            switch (value.currentScreen) {
              case 1:
                return NewsScreen();
              case 2:
                return GradesScreen();
              case 3:
                return SettingsScreen();
              default:
                return NewsScreen();
            }
          },
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
