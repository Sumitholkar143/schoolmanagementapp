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

class TeacherPanel extends StatefulWidget {
  @override
  _TeacherPanelState createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  int position = 0;
  String selectedClass = '5'; // Default class selection
  String title = '';
  String description = '';
  bool visiblity = false;
  List<HomeworkAssignment> assignments = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Panel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedClass,
                onChanged: (String? newValue) async {
                  setState(() {
                    selectedClass = newValue!;
                    visiblity = true;
                  });
                  assignments = [];
                  var notice = await getAllHomework();
                  print(notice);
                  int i = 0;
                  while (notice.length > i) {
                    var a = await notice.elementAt(i);
                    assignments.add(new HomeworkAssignment(
                        className: selectedClass,
                        title: a['title'],
                        description: a['description']));
                    i++;
                  }
                  setState(() {
                    visiblity = false;
                  });
                },
                items: List<String>.generate(12, (index) => '${index + 1}')
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('Class $value'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Selected Class: Class $selectedClass',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Homework Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Homework Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: assignHomework,
                child: Text('Assign Homework'),
              ),
              SizedBox(height: 20),
              const Text(
                'Assigned Homework:',
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
              ListView.builder(
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
                              'You Want to delete this Homework ' +
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
                                  await DatabaseOp.deleteHomework(
                                      selectedClass: selectedClass,
                                      Description:
                                          assignments[index].description);

                                  setState(() {
                                    assignments.removeAt(index);
                                  });
                                  await Fluttertoast.showToast(
                                    msg: "Homework Deleted",
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
                        title: Text(
                            'Class ${assignments[index].className} - ${assignments[index].title}'),
                        subtitle: Text(assignments[index].description),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> assignHomework() async {
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
      description = '';
    });
  }

  Future<void> addHomeworkToDB() async {
    DatabaseOp.databaseOp.connectionString =
        "mongodb+srv://sumitkuswah789:TuOS4izoCeNVsm7j@cluster0.8fd5uyn.mongodb.net/";
    await DatabaseOp.setDbName("$selectedClass" + "th");
    await DatabaseOp.setCollectionName("Homework");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    Map<String, dynamic> h = {'title': title, 'description': description};
    await DatabaseOp.insertData(h);
    sendNotificationToAllStudents(
        await DatabaseOp.getAllTokens("${selectedClass}th"),
        description,
        title);
  }

  Future<List<Map<String, dynamic>>> getAllHomework() async {
    DatabaseOp.databaseOp.connectionString =
        "mongodb+srv://sumitkuswah789:TuOS4izoCeNVsm7j@cluster0.8fd5uyn.mongodb.net/";
    await DatabaseOp.setDbName(selectedClass + 'th');
    await DatabaseOp.setCollectionName("Homework");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    var document = await DatabaseOp.databaseOp.collection.find().toList();
    return document;
  }

  Future<void> sendNotificationToAllStudents(
      List<String> a, String d, String t) async {
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
              'title': '$t',
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
}
