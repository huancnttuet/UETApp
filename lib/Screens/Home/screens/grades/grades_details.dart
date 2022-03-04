import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:uet_app/components/Toast/bottom_toast.dart';
import 'package:uet_app/utils/LauchUrl/lauch_url.dart';

class GradesDetails extends StatefulWidget {
  const GradesDetails({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<GradesDetails> createState() => _GradesDetailsState();
}

class _GradesDetailsState extends State<GradesDetails> {
  List<dynamic> subjects = [];
  bool _isLoading = false;
  @override
  // ignore: must_call_super
  void initState() {
    getSubjects(widget.title);
  }

  void getSubjects(input) async {
    setState(() {
      _isLoading = true;
    });
    final querryParams = {'input': input};
    final uri = Uri.https(
        'flaskapp-postgre.herokuapp.com', '/score/quickSearch', querryParams);
    try {
      var response =
          await http.get(uri, headers: {"Content-Type": "application/json"});
      print("${response.statusCode}");
      print("${response.body}");
      var resData = json.decode(response.body);

      setState(() {
        subjects = resData['list_score'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      LauchUrl.lauchPDFUrl(subjects[index][2]);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Text(subjects[index][1]),
                        title: Text(subjects[index][0]),
                        subtitle: Text(subjects[index][3] != null
                            ? subjects[index][3]
                            : 'Chưa có điểm'),
                        // isThreeLine: true,
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
