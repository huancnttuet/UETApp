import 'package:flutter/material.dart';
import 'package:uet_app/Screens/Home/home_screen.dart';
import 'package:uet_app/Screens/login/components/body.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uet_app/components/Toast/bottom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  postRequest(String username, String password) async {
    setState(() {
      _isLoading = true;
    });
    var url = 'http://huaan.live:8000/users/signin';

    Map data = {
      "data": {"username": username, "pwd": password}
    };
    //encode Map to JSON
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      print("${response.statusCode}");
      print("${response.body}");

      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        print(resData['statusCode']);
        if (resData['statusCode'] == 200) {
          BottomToast.showToast(context, "Đăng nhập thành công");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        } else {
          BottomToast.showToast(context, "Thông tin chưa chính xác");
        }
      } else {
        BottomToast.showToast(context, "Lỗi mạng");
      }
    } on Exception catch (_) {
      BottomToast.showToast(context, "Lỗi mạng");
      print('never reached');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Body(
              press: handlePress,
            ),
    );
  }

  handlePress(BuildContext context, String username, String password) {
    try {
      if (username != '' && password != '') {
        postRequest(username, password);
      }
    } on Exception catch (_) {
      print('never reached');
    }
  }
}
