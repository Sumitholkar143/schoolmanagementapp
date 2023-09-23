import 'package:flutter/material.dart';
import 'package:schoolmanagment/DatabaseOp.dart';
import 'package:schoolmanagment/ProgresBar/ProgreesBar.dart';

class Notice {
  final String title;
  final String description;
  final String date;

  Notice(this.title, this.description, this.date);
}

class NoticeScreen extends StatefulWidget {
  final List<Notice> notices = [];
  var noties = DatabaseOp.getAllNotice();
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  bool visiblity = true;
  String loading = 'loading...';
  List<Notice> notices = [];
  Future<void> allNotice() async {
    var notice = await DatabaseOp.getAllNotice();
    int i = 0;
    while (notice.length > i) {
      var a = await notice.elementAt(i);
      notices.add(new Notice(a['title'], a['notice'], a['date']));
      i++;
    }
    loading = '';

    setState(() {
      visiblity = false;
    });
    print(notices);
  }

  @override
  void initState() {
    super.initState();
    allNotice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Notices'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: notices.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildNoticeCard(notices[index]);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: visiblity,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                        ),
                        Center(
                          child:
                              AnimatedCircularProgressBar() //CircularProgressIndicator(color: Colors.blue,)
                          ,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeCard(Notice notice) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          notice.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notice.description),
        trailing: Text(
          notice.date,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
