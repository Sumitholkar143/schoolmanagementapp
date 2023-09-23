import 'package:flutter/material.dart';
import 'package:schoolmanagment/DatabaseOp.dart';

import '../ProgresBar/ProgreesBar.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class Student {
  String name, number;
  Student({required this.name, required this.number}) {}
}

class _StudentListState extends State<StudentList> {
  List<Student> students = [];
  bool visiblity = true;
  String _selectedClass = '5th';
  final List<String> _class = [
    '5th',
    '6th',
    '7th',
    '8th',
    '9th',
    '10th',
    '11th',
    '12th'
  ];
  @override
  void initState() {
    super.initState();
    addStudent();
  }

  Future<void> addStudent() async {
    var a = await DatabaseOp.getStudent(_selectedClass);
    for (int i = 0; i < a.length; i++) {
      var b = a.elementAt(i);
      students.add(Student(name: b['Student_Name'], number: b['Number']));
    }
    setState(() {
      visiblity = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student's"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Text(
                    'Class',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 180,
                  ),
                  DropdownButton(
                    focusColor: Colors.blue,
                    borderRadius: BorderRadius.circular(3),
                    value: _selectedClass,
                    isExpanded: false,
                    onChanged: (String? newValue) {
                      students = [];

                      print(newValue);
                      setState(() {
                        visiblity = true;
                        _selectedClass = newValue != null ? newValue : 'Q';
                        addStudent();
                      });
                    },
                    items: _class.map((String location) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          location,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        value: location,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
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
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(students[index].name),
                        subtitle: Text(students[index].number),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
