import 'package:flutter/material.dart';
import 'package:schoolmanagment/NoticeScreen.dart';
import 'package:schoolmanagment/ProfileScreen.dart';
import 'package:schoolmanagment/ResultScreen.dart';
import 'package:schoolmanagment/StudentAttendanceScreen.dart';

import 'ExamScreen.dart';
import 'HomeWorkScreen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: GridView.count(
            controller: ScrollController(
                initialScrollOffset: 0, keepScrollOffset: true),
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              DashboardCard(
                title: 'Student',
                icon: Icons.person,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              DashboardCard(
                title: 'Home Work',
                icon: Icons.school,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeWorkScreen()));
                },
              ),
              DashboardCard(
                title: 'Notice',
                icon: Icons.help,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NoticeScreen()));
                },
              ),
              DashboardCard(
                title: 'Attendance',
                icon: Icons.menu_book_sharp,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentAttendanceScreen(
                              // Current day of the month
                              )));
                },
              ),
              DashboardCard(
                title: 'Exams',
                icon: Icons.assignment,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ExamScreen()));
                  // Implement navigation to the Exams section.
                },
              ),
              DashboardCard(
                title: 'Results',
                icon: Icons.mark_as_unread,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResultScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
