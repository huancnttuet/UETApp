import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uet_app/configs/const.dart';
import 'package:uet_app/configs/constants.dart';
import 'package:uet_app/models/BottomNavBar/bottom_navbar_model.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int screen;
  @override
  void initState() {
    super.initState();
    screen = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomNavItem(
            title: "Tin tức",
            svgScr: "assets/icons/calendar.svg",
            press: () {
              Provider.of<BottomNavBarModel>(context, listen: false).changeScreen(HOMESCREENSTATE['NEWS']);
              setState(() {
                screen = HOMESCREENSTATE['NEWS'];
              });
            },
            isActive: screen == HOMESCREENSTATE['NEWS'],
          ),
          BottomNavItem(
            title: "Xem điểm thi",
            svgScr: "assets/icons/gym.svg",
            press: () {
              Provider.of<BottomNavBarModel>(context, listen: false).changeScreen(HOMESCREENSTATE['GRADES']);
              setState(() {
                screen = HOMESCREENSTATE['GRADES'];
              });
            },
            isActive: screen == HOMESCREENSTATE['GRADES'],
          ),
          BottomNavItem(
            title: "Settings",
            svgScr: "assets/icons/Settings.svg",
            press: () {
              Provider.of<BottomNavBarModel>(context, listen: false).changeScreen(HOMESCREENSTATE['SETTINGS']);
              setState(() {
                screen = HOMESCREENSTATE['SETTINGS'];
              });
            },
            isActive: screen == HOMESCREENSTATE['SETTINGS'],
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String svgScr;
  final String title;
  final Function press;
  final bool isActive;
  const BottomNavItem({
    Key key,
    this.svgScr,
    this.title,
    this.press,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            svgScr,
            color: isActive ? kActiveIconColor : kTextColor,
          ),
          Text(
            title,
            style: TextStyle(color: isActive ? kActiveIconColor : kTextColor),
          ),
        ],
      ),
    );
  }
}
