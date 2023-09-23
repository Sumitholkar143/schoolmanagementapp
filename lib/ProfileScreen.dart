import 'package:flutter/material.dart';
import 'package:schoolmanagment/DatabaseOp.dart';
import 'package:schoolmanagment/LoginScreen.dart';
import 'package:schoolmanagment/Sharedpref/SharedPreferencesfile.dart';
import 'package:schoolmanagment/notification/Notification_ser.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();
  static String name = "Sumit";
}

class _ProfileScreenState extends State<ProfileScreen> {
  NotificationServices notificationServices = NotificationServices();
  String name = 'Loading...';
  String clas = 'Loading...';
  String enrollmentNo = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      print(value);
      DatabaseOp.addTokentoServer(value);
    });
    notificationServices.firebaseInit(context);
    fetchProfileDetails();
  }

  Future<void> fetchProfileDetails() async {
    name = await SharedPreferencesfile.getName();
    phone = await SharedPreferencesfile.getNumber();
    email = await SharedPreferencesfile.getEmail();
    enrollmentNo = await SharedPreferencesfile.getEnroll();
    clas = await SharedPreferencesfile.getClass();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage:
                  AssetImage('schoolmanagment/assets/student.jpeg'),
            ),
            SizedBox(height: 16.0),
            Text(
              name, // Display the fetched name here
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(clas),
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text('Enrolment No'),
              subtitle: Text(enrollmentNo),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text(phone),
            ),
            SizedBox(height: 16.0),
            TextButton(
                onPressed: () async {
                  await SharedPreferencesfile.deleteAll();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(title: '')),
                      (Route route) => false);
                },
                child: Text('Log Out'))
          ],
        ),
      ),
      // Other UI elements to display other details
      // ...
    );
  }
}
