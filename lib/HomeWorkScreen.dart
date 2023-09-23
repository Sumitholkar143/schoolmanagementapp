import 'package:flutter/material.dart';
import 'package:schoolmanagment/Sharedpref/SharedPreferencesfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DatabaseOp.dart';
import 'ProgresBar/ProgreesBar.dart';

class HomeWorkScreen extends StatefulWidget {
  State<HomeWorkScreen> createState() => _HomeWorkScreenState();
}

class HomeworkTask {
  final String title;
  final String description;
  bool isCompleted;

  HomeworkTask(
      {required this.title,
      required this.description,
      this.isCompleted = false});
}

List<HomeworkTask> homeworkTasks1 = [];

class _HomeWorkScreenState extends State<HomeWorkScreen> {
  List<HomeworkTask> homeworkTasks = [];
  bool visiblity = true;
  @override
  void initState() {
    super.initState();
    allHomework();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              itemCount: homeworkTasks.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text(homeworkTasks[index].title),
                    subtitle: Text(homeworkTasks[index].description),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15,
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
    );
  }

  Future<void> allHomework() async {
    var notice = await getAllHomework();
    print(notice);
    int i = 0;
    while (notice.length > i) {
      var a = await notice.elementAt(i);
      homeworkTasks.add(
          new HomeworkTask(title: a['title'], description: a['description']));
      i++;
    }
    print(homeworkTasks);

    setState(() {
      visiblity = false;
    });
    //  print(notices);
  }
}

Future<List<Map<String, dynamic>>> getAllHomework() async {
  await DatabaseOp.setDbName(await SharedPreferencesfile.getClass());
  await DatabaseOp.setCollectionName("Homework");
  try {
    await DatabaseOp.createConnection();
  } catch (e) {
    print(e.toString());
  }
  print(DatabaseOp.databaseOp.collection.toString());
  print(await SharedPreferencesfile.getClass());
  var document = await DatabaseOp.databaseOp.collection.find().toList();
  Map<String, dynamic> a = {'title': '11th'};
  // await DatabaseOp.databaseOp.collection.insert(a);

  return document;
}
