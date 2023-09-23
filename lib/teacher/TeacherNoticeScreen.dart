import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../DatabaseOp.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ProgresBar/ProgreesBar.dart';

class HomeworkAssignment {
  String className;
  String title;
  String description;

  HomeworkAssignment(
      {required this.className,
      required this.title,
      required this.description});
}

class TeacherNoticeScreen extends StatefulWidget {
  @override
  _TeacherNoticeScreenState createState() => _TeacherNoticeScreenState();
}

class _TeacherNoticeScreenState extends State<TeacherNoticeScreen> {
  @override
  void initState() {
    super.initState();
    allNotice();
  }

  Future<void> allNotice() async {
    setState(() {
      visiblity = true;
    });
    var a = await getAllHomework();
    int i = 0;
    while (a.length > i) {
      var b = await a.elementAt(i);
      assignments.add(new HomeworkAssignment(
          className: '', title: b['title'], description: b['notice']));
      i++;
    }
    setState(() {
      visiblity = false;
    });
  }

  TextEditingController titleController = new TextEditingController(),
      descriptionControllar = new TextEditingController();
  int position = 0;
  String selectedClass = '5'; // Default class selection
  String title = '';
  String description = '';
  bool visiblity = false;
  List<HomeworkAssignment> assignments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Panel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Notice Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionControllar,
                onChanged: (value) {
                  description = value;
                },
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notice Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: assignHomework,
                child: Text('Add Notice'),
              ),
              SizedBox(height: 20),
              const Text(
                'All Notices:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Visibility(
                  visible: visiblity,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Center(
                          child:
                              AnimatedCircularProgressBar() //CircularProgressIndicator(color: Colors.blue,)
                          ,
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert'),
                              content: Text(
                                'You Want to delete this Notice ' +
                                    assignments[index].title,
                                style: TextStyle(),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    if (await DatabaseOp.deleteNotice(
                                        Description:
                                            assignments[index].description)) {
                                      setState(() {
                                        assignments.removeAt(index);
                                      });
                                      await Fluttertoast.showToast(
                                        msg: "Notice Deleted",
                                        gravity: ToastGravity
                                            .BOTTOM, // Toast position on the screen.
                                        backgroundColor: Colors.yellow
                                            .shade900, // Background color of the toast.
                                        textColor: Colors
                                            .black, // Text color of the toast message.
                                        fontSize: 16.0,
                                        toastLength: Toast
                                            .LENGTH_SHORT, // You can use Toast.LENGTH_LONG for a longer duration.

                                        // Font size of the toast message.
                                      );
                                    } else {
                                      await Fluttertoast.showToast(
                                        msg: "Try Again",
                                        gravity: ToastGravity
                                            .BOTTOM, // Toast position on the screen.
                                        backgroundColor: Colors.yellow
                                            .shade900, // Background color of the toast.
                                        textColor: Colors
                                            .black, // Text color of the toast message.
                                        fontSize: 16.0,
                                        toastLength: Toast
                                            .LENGTH_SHORT, // You can use Toast.LENGTH_LONG for a longer duration.

                                        // Font size of the toast message.
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(' ${assignments[index].title}'),
                          subtitle: Text(assignments[index].description),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> assignHomework() async {
    titleController.text = "";
    descriptionControllar.text = '';
    if (title.isEmpty || description.isEmpty) {
      // Show an error message if either title or description is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Please fill in both the title and description.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Return without assigning homework
    }
    setState(() {
      visiblity = true;
    });

    HomeworkAssignment assignment = HomeworkAssignment(
      className: selectedClass,
      title: title,
      description: description,
    );
    await addHomeworkToDB();
    setState(() {
      assignments.add(assignment);
      visiblity = false;
      title = '';
    });
    for (int i = 5; i < 13; i++) {
      sendNotificationToAllStudents(
          await DatabaseOp.getAllTokens('${i}th'), description);
    }
    description = '';
  }

  Future<void> addHomeworkToDB() async {
    await DatabaseOp.setDbName('School');
    await DatabaseOp.setCollectionName('Notice');
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    Map<String, dynamic> h = {
      'title': title,
      'notice': description,
      'date': DateTime.now().toString().split(' ').elementAt(0)
    };
    await DatabaseOp.insertData(h);
  }

  Future<List<Map<String, dynamic>>> getAllHomework() async {
    await DatabaseOp.setDbName('School');
    await DatabaseOp.setCollectionName("Notice");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    var document = await DatabaseOp.databaseOp.collection.find().toList();
    Map<String, dynamic> a = {'title': '11th'};
    // await DatabaseOp.databaseOp.collection.insert(a);
    return document;
  }
}

Future<void> sendNotificationToAllStudents(List<String> a, String d) async {
  String serverToken =
      'AAAAlLmfemQ:APA91bEf6RXZOV02jXHl5jSh2wUHZ8bzhMfj-aqztoTUpAW9IaRv5dNLJ2sjX0S1zPEYcm0Np07nptzCX94WbtPXEVrfSpzUBtS16toBzmXW4qkD0F8SxFKQBNcvSYHTmWPSRIM1LJ8F';
  List<String> deviceTokens = a;

  for (String deviceToken in deviceTokens) {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$d',
            'title': 'New Notice',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'extraData': 'Additional data you want to send',
          },
          'to': deviceToken,
        },
      ),
    );

    print('FCM Response for $deviceToken: ${response.body}');
  }
}
