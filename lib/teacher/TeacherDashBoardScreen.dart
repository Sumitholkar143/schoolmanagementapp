import 'package:flutter/material.dart';
import 'package:schoolmanagment/Sharedpref/SharedPreferencesfile.dart';
import 'package:schoolmanagment/teacher/PresentAbsentScreen.dart';
import 'package:schoolmanagment/teacher/StudentList.dart';
import 'package:schoolmanagment/teacher/TeacherNoticeScreen.dart';
import 'package:schoolmanagment/teacher/TeacherPaneelScreen.dart';

import '../LoginScreen.dart';

class TeacherDashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await SharedPreferencesfile.deleteAll();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen(title: '')),
                (Route route) => false);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        appBar: AppBar(
          title: Text(
            'Teacher Dashboard',
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
                    title: 'Homework',
                    icon: Icons.menu_book_sharp,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherPanel()));
                    }),
                DashboardCard(
                    title: 'Notice',
                    icon: Icons.mail_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherNoticeScreen()));
                    }),
                DashboardCard(
                    title: 'Students',
                    icon: Icons.people_alt_sharp,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentList()));
                    }),
                DashboardCard(
                    title: 'Upload A ',
                    icon: Icons.co_present_rounded,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PresentAbsentScreen()));
                    })
              ])),
        ));
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
