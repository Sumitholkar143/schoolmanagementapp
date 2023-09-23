import 'package:flutter/material.dart';
import 'package:schoolmanagment/Sharedpref/SharedPreferencesfile.dart';

class ResultScreen extends StatefulWidget {
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String name = 'loading...';
  String rollno = 'loading...';
  Future<void> getDetails() async {
    name = await SharedPreferencesfile.getName();
    rollno = await SharedPreferencesfile.getEnroll();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Result'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Student Name: $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'EnRoll Number: $rollno',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24.0),
            Table(
              border: TableBorder.all(width: 1.0, color: Colors.black),
              children: [
                TableRow(children: [
                  TableCell(child: Center(child: Text('Subject'))),
                  TableCell(child: Center(child: Text('Marks'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('Mathematics'))),
                  TableCell(child: Center(child: Text('90'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('Science'))),
                  TableCell(child: Center(child: Text('85'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('History'))),
                  TableCell(child: Center(child: Text('78'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('English'))),
                  TableCell(child: Center(child: Text('95'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('Obtained Marks'))),
                  TableCell(child: Center(child: Text('348'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('Percentage'))),
                  TableCell(child: Center(child: Text('87%'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: Text('Grade'))),
                  TableCell(
                      child: Center(
                          child: Text(
                    'A',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
                ])
              ],
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Add functionality for going back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
