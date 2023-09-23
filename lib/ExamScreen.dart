import 'package:flutter/material.dart';

class ExamScreen extends StatelessWidget {
  final List<Map<String, String>> exams = [
    {
      'subject': 'Mathematics',
      'date': 'Aug 10, 2023',
      'time': '10:00 AM - 12:00 PM',
    },
    {
      'subject': 'Science',
      'date': 'Aug 12, 2023',
      'time': '02:00 PM - 04:00 PM',
    },
    // Add more exam data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exam Dashboard',
        ),
      ),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return ListTile(
            title: Text(exam['subject']!,
                style: TextStyle(fontWeight: FontWeight.w600)),
            focusColor: Colors.yellow.shade400,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${exam['date']}'),
                Text('Time: ${exam['time']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
