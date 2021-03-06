import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uet_app/Screens/Home/screens/news/details_screen.dart';
import 'package:uet_app/Screens/Home/screens/news/news_card.dart';
import 'package:http/http.dart' as http;
import 'package:uet_app/components/Toast/bottom_toast.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> newsfeed;
  List<dynamic> student_news;
  bool _isLoading = false;
  SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    pref = await SharedPreferences.getInstance();
    if (pref.getString('newsfeed') != null) {
      List<dynamic> newsfeedCached = json.decode(pref.getString('newsfeed'));
      if (newsfeedCached.length > 0) {
        setState(() {
          newsfeed = newsfeedCached;
        });
      } else {
        await loadDataNewsfeed();
      }
    } else {
      await loadDataNewsfeed();
    }

    if (pref.getString('student_news') != null) {
      List<dynamic> studentnewsCached =
          json.decode(pref.getString('student_news'));
      if (studentnewsCached.length > 0) {
        setState(() {
          student_news = studentnewsCached;
        });
      } else {
        await loadDataNewsStudent();
      }
    } else {
      await loadDataNewsStudent();
    }
  }

  Future<void> loadDataNewsfeed() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    var url = 'http://40.71.102.64:5000/news/getnewsfeed';

    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      // print("${response.statusCode}");
      // print("${response.body}");

      if (response.statusCode == 200) {
        var resData = json.decode(response.body);

        if (resData['code'] == 'SUCCESS') {
          setState(() {
            newsfeed = resData['data'];
          });
          pref.setString('newsfeed', json.encode(resData['data']));
          // BottomToast.showToast(context, "T???i d??? li???u tha??nh c??ng");
        } else {
          BottomToast.showToast(context, "Th??ng tin ch??a chi??nh xa??c");
        }
      } else {
        BottomToast.showToast(context, "L????i ma??ng");
      }
    } on Exception catch (_) {
      BottomToast.showToast(context, "L????i ma??ng");
      print('never reached');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadDataNewsStudent() async {
    setState(() {
      _isLoading = true;
    });
    var url = 'http://40.71.102.64:5000/news/getstudentnews?page=1';

    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print("${response.statusCode}");
      print("${response.body}");

      if (response.statusCode == 200) {
        var resData = json.decode(response.body);

        if (resData['code'] == 'SUCCESS') {
          setState(() {
            student_news = resData['data'];
          });
          pref.setString('student_news', json.encode(resData['data']));
          // BottomToast.showToast(context, "T???i d??? li???u tha??nh c??ng");
        } else {
          BottomToast.showToast(context, "Th??ng tin ch??a chi??nh xa??c");
        }
      } else {
        BottomToast.showToast(context, "L????i ma??ng");
      }
    } on Exception catch (_) {
      BottomToast.showToast(context, "L????i ma??ng");
      print('never reached');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Function handlePress = (data, context) {
    if (data != null)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DetailsScreen(
              url: data['link'],
              title: data['title'],
            );
          },
        ),
      );
  };

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:25.0,bottom: 25),
              child: Text(
                'Ho???t ?????ng ti??u bi???u',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
              height: 275,
              width: MediaQuery.of(context).size.width,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newsfeed != null ? newsfeed.length : 0,
                      padding: EdgeInsets.only(left: 20.0),
                      itemBuilder: (BuildContext context, int index) {
                        return NewsCard(
                            title: newsfeed != null
                                ? newsfeed[index]['title']
                                : '',
                            src: newsfeed[index]['img'],
                            press: () {
                              handlePress(newsfeed[index], context);
                            });
                      }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                'Tin sinh vi??n',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
              height: 275,
              width: MediaQuery.of(context).size.width,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: student_news != null ? student_news.length : 0,
                      padding: EdgeInsets.only(left: 20.0),
                      itemBuilder: (BuildContext context, int index) {
                        return NewsCard(
                          title: student_news != null
                              ? student_news[index]['title']
                              : '',
                          src: student_news[index]['img'],
                          press: () {
                            handlePress(student_news[index], context);
                          },
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    loadDataNewsfeed();
    loadDataNewsStudent();
  }
}
