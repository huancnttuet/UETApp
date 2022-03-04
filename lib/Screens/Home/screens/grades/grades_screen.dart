import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uet_app/Screens/Home/screens/grades/grades_details.dart';
import 'package:uet_app/components/Toast/bottom_toast.dart';
import 'package:http/http.dart' as http;
import 'package:uet_app/utils/LauchUrl/lauch_url.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key key}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  bool _isLoading = false;
  List<dynamic> subjects = [];
  List<dynamic> subjectsTemp = [];
  List<dynamic> subjectsDisplay = [];
  int display_number = 10;
  List<dynamic> list_hint = [];
  SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    getAll();
  }

  Future<bool> checkCached() async {
    pref = await SharedPreferences.getInstance();
    if (pref.getString('grades_all') != null) {
      List<dynamic> cachedData = json.decode(pref.getString('grades_all'));
      // print(pref.getString('grades_all'));
      if (cachedData.length > 0) {
        setState(() {
          subjects = cachedData;
          subjectsTemp = cachedData;
          subjectsDisplay = subjects.length > display_number
              ? subjects.sublist(0, display_number)
              : subjects;
          _isLoading = false;
        });
        return true;
      }
    }
    return false;
  }

  void getAll() async {
    setState(() {
      _isLoading = true;
    });

    if (await checkCached()) {
      return;
    }

    final querryParams = {'term': '76', 'type_education': '0'};
    final uri =
        Uri.https('flaskapp-postgre.herokuapp.com', '/score', querryParams);
    print(uri.toString());
    try {
      var response =
          await http.get(uri, headers: {"Content-Type": "application/json"});
      // print("${response.statusCode}");
      // print("${response.body}");
      var resData = json.decode(response.body);

      setState(() {
        subjects = resData['subject_list'];
        subjectsDisplay = subjects.length > display_number
            ? subjects.sublist(0, display_number)
            : subjects;
        pref.setString('grades_all', json.encode((resData['subject_list'])));
      });
    } on Exception catch (_) {
      BottomToast.showToast(context, "Lỗi mạng");
      print('never reached');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getHintInput(input) async {
    final querryParams = {'input': input};
    final uri = Uri.https(
        'flaskapp-postgre.herokuapp.com', '/score/getHintInput', querryParams);
    try {
      var response =
          await http.get(uri, headers: {"Content-Type": "application/json"});
      print("${response.statusCode}");
      print("${response.body}");
      var resData = json.decode(response.body);

      setState(() {
        list_hint = resData['list_hint'];
      });
    } on Exception catch (_) {
      BottomToast.showToast(context, "Lỗi mạng");
      print('never reached');
    } finally {}
  }

  void handleSearch(String text) {
    List<dynamic> results =
        subjectsTemp.where(((e) => e[0].contains(text))).toList();
    setState(() {
      subjects = results;
      subjectsDisplay = subjects.length > display_number
          ? subjects.sublist(0, display_number)
          : subjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Xem điểm'),
        Container(
          // margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
          decoration: BoxDecoration(
            color: Colors.lightGreenAccent,
            borderRadius: BorderRadius.circular(29.5),
          ),
          child: Column(children: [
            TextField(
              onChanged: (text) {
                if (text == '') {
                  setState(() {
                    subjects = subjectsTemp;
                    list_hint = [];
                  });
                } else {
                  // getHintInput(text);
                  handleSearch(text);
                }
              },
              decoration: InputDecoration(
                hintText: "Tìm kiếm",
                icon: SvgPicture.asset("assets/icons/search.svg"),
                // border: InputBorder.none,
              ),
            ),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list_hint.length,
                  itemBuilder: ((context, index) {
                    return TextButton(
                        onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GradesDetails(
                                  title: list_hint[index],
                                );
                              }))
                            },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(list_hint[index])));
                  })),
            ),
          ]),
        ),
        _isLoading
            ? Container(
                margin: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text('Đang tải ...'),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subjectsDisplay.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= subjectsDisplay.length) {
                          // setState(() {
                          //   display_number += 10;
                          //   subjectsDisplay = subjects.length > display_number
                          //       ? subjects.sublist(0, display_number)
                          //       : subjects;
                          // });
                          return Center(child: CircularProgressIndicator());
                        }
                        return GestureDetector(
                          onTap: () {
                            LauchUrl.lauchPDFUrl(subjectsDisplay[index][2]);
                          },
                          child: Card(
                            child: ListTile(
                              leading: Text(subjectsDisplay[index][1]),
                              title: Text(subjectsDisplay[index][0]),
                              subtitle: Text(subjectsDisplay[index][3] != null
                                  ? subjectsDisplay[index][3]
                                  : 'Chưa có điểm'),
                              // isThreeLine: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
