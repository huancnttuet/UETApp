import 'package:flutter/material.dart';
import 'package:uet_app/Screens/Login/components/background.dart';
import 'package:uet_app/Screens/Signup/signup_screen.dart';
import 'package:uet_app/components/already_have_an_account_acheck.dart';
import 'package:uet_app/components/rounded_button.dart';
import 'package:uet_app/components/rounded_input_field.dart';
import 'package:uet_app/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  const Body({Key key, this.press}) : super(key: key);

  final Function press;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String username = '';
  String password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Đăng nhập",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Tên đăng nhập",
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            RoundedButton(
              text: "Đăng nhập",
              press: () {
                widget.press(context, username, password);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
