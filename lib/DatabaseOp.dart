import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoolmanagment/ModuleClass/Notice.dart';
import 'package:schoolmanagment/Sharedpref/SharedPreferencesfile.dart';
import 'package:schoolmanagment/notification/Notification_ser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ModuleClass/Student.dart';

class DatabaseOp {
  static DatabaseOp databaseOp = DatabaseOp();
  String connectionString = "url";
  var db, collection;
  String dbName = "";
  String collectionName = "";

  static Future<void> setDbName(String dbname) async {
    databaseOp.dbName = dbname;
  }

  static Future<void> setCollectionName(String cname) async {
    databaseOp.collectionName = cname;
  }

  static Future<void> createConnection() async {
    databaseOp.db =
        await Db.create(databaseOp.connectionString + databaseOp.dbName);
    await databaseOp.db.open();
    inspect(databaseOp.db);
    databaseOp.collection =
        await databaseOp.db.collection(databaseOp.collectionName);
    print(databaseOp.db.isConnected + "12");
  }

  static Future<void> insertData(Map<String, dynamic> data) async {
    await databaseOp.collection.insert(data);
    await Fluttertoast.showToast(
      msg: "Task Complete Succesfully",
      gravity: ToastGravity.BOTTOM, // Toast position on the screen.
      backgroundColor: Colors.green.shade400, // Background color of the toast.
      textColor: Colors.black, // Text color of the toast message.
      fontSize: 16.0,
      toastLength: Toast
          .LENGTH_SHORT, // You can use Toast.LENGTH_LONG for a longer duration.

      // Font size of the toast message.
    );
  }

  static Future<List<Map<String, dynamic>>> readNamePass(
      {String? field1, String? value1, String? field2, String? value2}) async {
    final selector = {};

    if (field1 != null && value1 != null) {
      selector[field1] = value1;
    }

    if (field2 != null && value2 != null) {
      selector[field2] = value2;
    }

    final cursor = databaseOp.collection.find(selector);
    final result = await cursor.toList();
    return result;
  }

  static Future<void> read() async {
    final cursor = await databaseOp.collection.find();
    await cursor.forEach((doc) => print(doc));
  }

  static Future<List<Map<String, dynamic>>> getAllNotice() async {
    await DatabaseOp.setDbName("School");
    await DatabaseOp.setCollectionName("Notice");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    var document = DatabaseOp.databaseOp.collection.find().toList();
    return document;
  }

  static Future<List<Map<String, dynamic>>> getStudent(String className) async {
    await DatabaseOp.setDbName(className);
    await DatabaseOp.setCollectionName("Student_details");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    var document = DatabaseOp.databaseOp.collection.find().toList();
    return document;
  }

  static Future<List<dynamic>> getAttandance() async {
    await DatabaseOp.setDbName(await SharedPreferencesfile.getClass());
    await DatabaseOp.setCollectionName("Student_details");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    var document = await DatabaseOp.databaseOp.collection.findOne(
        where.eq('Student_Name', await SharedPreferencesfile.getName()));
    List<dynamic> pres = await document['present'];

    return pres;
  }

  static Future<List<String>> getAllTokens(String className) async {
    await DatabaseOp.setDbName(className);
    await DatabaseOp.setCollectionName("Student_details");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    var document = await DatabaseOp.databaseOp.collection.find().toList();
    int i = 0;
    List<String> l = [];
    print(document.length);
    while (document.length > i) {
      var a = await document.elementAt(i);

      try {
        if (a['token'] == '') {
          i++;
          continue;
        }
        l.add(a['token']);
      } catch (e) {}
      i++;
    }
    print(await l);
    return l;
  }

  static Future<bool> isTeacher(String username, String pass) async {
    await DatabaseOp.setDbName("School");
    await DatabaseOp.setCollectionName("Teacher");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    final user = await DatabaseOp.databaseOp.collection
        .findOne(where.eq('Username', username));
    if (user != null) {
      String storedHashedPassword = user['Password'];
      if (storedHashedPassword == pass) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isTeach', true);
        return true;
      }
    }
    return false;
  }

  static Future<void> addTokentoServer(String token) async {
    await DatabaseOp.setDbName('Student');
    await DatabaseOp.setCollectionName("Student_details");
    print(DatabaseOp.databaseOp.collection.toString());
    await DatabaseOp.databaseOp.collection.update(
        where.eq('Student_Name', await SharedPreferencesfile.getName()),
        modify.set('token', token));
  }

  static Future<void> deleteHomework(
      {required String selectedClass, required String Description}) async {
    await DatabaseOp.setDbName(selectedClass + 'th');
    await DatabaseOp.setCollectionName("Homework");
    print(await DatabaseOp.databaseOp.collection
        .deleteMany({'description': Description}));
  }

  static Future<bool> uplodAttandance(
      List<Student> a, String _selectedClass) async {
    await DatabaseOp.setDbName(_selectedClass);
    await DatabaseOp.setCollectionName("Student_details");
    for (int i = 0; i < a.length; i++) {
      if (!a[i].isPresent) continue;
      final query = where.eq('Student_Name', a[i].name);
      final update = modify.push(
          'present', DateTime.now().toString().split(' ').elementAt(0));
      await DatabaseOp.databaseOp.collection.update(query, update);
    }
    await Fluttertoast.showToast(
      msg: "aTTANDANCE Uploaded",
      gravity: ToastGravity.BOTTOM, // Toast position on the screen.
      backgroundColor: Colors.green.shade900, // Background color of the toast.
      textColor: Colors.black, // Text color of the toast message.
      fontSize: 16.0,
      toastLength: Toast
          .LENGTH_SHORT, // You can use Toast.LENGTH_LONG for a longer duration.

      // Font size of the toast message.
    );
    return true;
  }

  static Future<void> addPresent(
      Map<String, String> name, String classNmae) async {}
  static Future<bool> deleteNotice({required String Description}) async {
    try {
      await DatabaseOp.setDbName('School');
      await DatabaseOp.setCollectionName("Notice");
      print(await DatabaseOp.databaseOp.collection
          .deleteMany({'notice': Description}));
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> validateUsernameAndPassword(
      String username, String password) async {
    // MongoDB connection details

    final users = DatabaseOp.databaseOp.collection;
    final user = await users.findOne(where.eq('Username', username));
    print("123" + user.toString());
    if (user != null) {
      // Assuming the password is stored securely (e.g., hashed) in MongoDB
      // Compare the hashed password with the provided password
      String storedHashedPassword = user['Password'];

      // You would need to use a secure password comparison method, e.g., bcrypt
      // For this example, we'll compare the plaintext passwords directly
      if (storedHashedPassword == password) {
        // Password is correct, save the details in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        //prefs.setString('email', user['email']);
        prefs.setString('student_Class', user['student_Class']);
        prefs.setString('name', user['Student_Name']);
        prefs.setString('email', user['Email']);
        prefs.setString('enroll', user['enrol_no']);
        prefs.setString('number', user['Number']);
        prefs.setBool("isLogin", true);
        prefs.setBool('isTeach', false);
        prefs.setString('class', user['student_Class']);
        NotificationServices().getDeviceToken().then((value) {
          DatabaseOp.addTokentoServer(value);
        });
        return true; // Credentials are valid
      }
    }

    return false; // Invalid credentials
  }
}
