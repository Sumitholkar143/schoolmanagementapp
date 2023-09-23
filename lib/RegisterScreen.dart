import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolmanagment/LoginScreen.dart';
import 'package:schoolmanagment/notification/Notification_ser.dart';

import 'DatabaseOp.dart';

class RegisterScreen extends StatefulWidget {
  State<RegisterScreen> createState() => _RegisterScreenState();
}

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

class _RegisterScreenState extends State<RegisterScreen> {
  bool phide = true, chide = true, visiblity = false;
  static TextEditingController nameController = TextEditingController();
  static TextEditingController userController = TextEditingController();
  static TextEditingController passController = TextEditingController();
  static TextEditingController cpassController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Builder(builder: (context) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Icon(
                        Icons.person,
                        size: double.tryParse('100'),
                      ),
                    ),
                    Container(
                        width: 500,
                        child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Colors.black87)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Colors.black38)),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                )))),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          width: 500,
                          child: TextField(
                              controller: userController,
                              decoration: InputDecoration(
                                  hintText: "example123",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  labelText: 'Username',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: Colors.black38)),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  )))),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2),
                          borderRadius: BorderRadius.circular(18)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.class_),
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
                            width: 170,
                          ),
                          DropdownButton(
                            borderRadius: BorderRadius.circular(3),
                            value: _selectedClass,
                            isExpanded: false,
                            onChanged: (String? newValue) {
                              print(newValue);
                              setState(() {
                                _selectedClass =
                                    newValue != null ? newValue : 'Q';
                              });
                            },
                            items: _class.map((String location) {
                              return DropdownMenuItem<String>(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                value: location,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          width: 500,
                          child: TextField(
                              controller: numberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Number',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  hintText: '1234567898',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: Colors.black38)),
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: Colors.black,
                                  )))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          width: 500,
                          child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'E mail',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  hintText: 'example@gmail.com',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: Colors.black38)),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  )))),
                    ), //name
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        width: 500,
                        child: TextField(
                            controller: passController,
                            obscureText: phide,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                                labelText: "Paasword",
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Colors.black87)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Colors.black38)),
                                suffixIcon: IconButton(
                                  icon: phide
                                      ? Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.black,
                                        )
                                      : Icon(Icons.visibility_off,
                                          color: Colors.black),
                                  onPressed: () {
                                    phide = !phide;
                                    setState(() {});
                                  },
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ))),
                      ),
                    ), //username
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        width: 500,
                        child: TextField(
                            controller: cpassController,
                            obscureText: chide,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                                labelText: "Confirm Paasword",
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Colors.black87)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Colors.black38)),
                                suffixIcon: IconButton(
                                  icon: chide
                                      ? Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        ),
                                  onPressed: () {
                                    chide = !chide;
                                    setState(() {});
                                  },
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ))),
                      ),
                    ),
                    Visibility(
                        visible: visiblity,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        )), //
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                          width: 500,
                          height: 45,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black)),
                            onPressed: () async {
                              setState(() {
                                visiblity = true;
                              });
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (!await validateAllInput()) {
                                setState(() {
                                  visiblity = false;
                                });
                                return;
                              }
                              print(nameController.value.text);
                              if (passController.value.text !=
                                  cpassController.value.text) {
                                return;
                              }
                              await InsertData(
                                  nameController.value.text,
                                  userController.value.text,
                                  passController.value.text);
                              print("2252525");
                            },
                            child: Text('Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.white)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                          width: 500,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen(title: "")));
                            },
                            child: Text('Already have account sign in',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                )),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> InsertData(String name, String username, String pass) async {
    if (name == "" || username == "" || pass == "") {
      return;
    }
    await DatabaseOp.setDbName(_selectedClass);
    await DatabaseOp.setCollectionName("Student_details");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    if (DatabaseOp.databaseOp.collection == null) {
      visiblity = false;
      setState(() {});
      await Fluttertoast.showToast(
        msg: "Please Check Your Internet Connection",
        gravity: ToastGravity.BOTTOM, // Toast position on the screen.
        backgroundColor: Colors.red.shade900, // Background color of the toast.
        textColor: Colors.black, // Text color of the toast message.
        fontSize: 16.0,
        toastLength: Toast
            .LENGTH_SHORT, // You can use Toast.LENGTH_LONG for a longer duration.

        // Font size of the toast message.
      );
      return;
    }
    print(DatabaseOp.databaseOp.collection);
    final Map<String, dynamic> data = {
      'Student_Name': name,
      'student_Class': _selectedClass,
      'Username': username,
      'Password': pass,
      'Email': emailController.value.text,
      'Number': numberController.value.text,
      'enrol_no':
          "ABC" + ((Random().nextDouble() * 10000000000).toInt()).toString(),
      'token': (await NotificationServices().getDeviceToken()).toString()
      // Add other fields as needed
    };
    await DatabaseOp.insertData(data);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginScreen(title: "")));
  }

  Future<bool> validateAllInput() async {
    if (userController.value.text.isEmpty ||
        nameController.value.text.isEmpty ||
        emailController.value.text.isEmpty ||
        numberController.value.text.isEmpty ||
        passController.value.text.isEmpty) {
      // Show an error message if either title or description is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill All the field'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
      // Return without assigning homework
    }
    return true;
  }
}
