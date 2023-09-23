import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolmanagment/DatabaseOp.dart';
import 'package:schoolmanagment/RegisterScreen.dart';
import 'package:schoolmanagment/teacher/TeacherDashBoardScreen.dart';
import 'package:schoolmanagment/teacher/TeacherPaneelScreen.dart';

import 'DashBoardScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hide = true, visiblity = false, _isChecked = false;
  int _counter = 0;
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
  static TextEditingController passController = TextEditingController();
  static TextEditingController userController = TextEditingController();
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Login",style: TextStyle(color: Colors.black,wordSpacing:1),),backgroundColor: Color(0XFFD4E7eE),bottomOpacity: 22,),
      body: Container(
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   Color.fromRGBO(246, 211, 101, 0.8),
        //   Color.fromRGBO(253, 160, 133, 0.8)
        // ])),
        height: double.infinity,
        width: double.infinity,
        //color: const Color(0XFFD4E7FE),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 125, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: double.tryParse('100'),
                  ),
                ),
                Container(
                  width: 500,
                  child: TextField(
                      controller: userController,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                              borderSide: const BorderSide(
                                  width: 2.0, color: Colors.black87)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                              borderSide: const BorderSide(
                                  width: 2.0, color: Colors.white)),
                          prefixIcon: Icon(
                            color: Colors.black,
                            Icons.person,
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    width: 500,
                    child: TextField(
                        controller: passController,
                        obscureText: hide,
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
                                    width: 2.0, color: Colors.white)),
                            suffixIcon: IconButton(
                              icon: hide
                                  ? Icon(Icons.visibility)
                                  : Icon((Icons.visibility_off)),
                              onPressed: () {
                                hide = !hide;
                                setState(() {});
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 15,
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
                        width: 180,
                      ),
                      DropdownButton(
                        borderRadius: BorderRadius.circular(3),
                        value: _selectedClass,
                        isExpanded: false,
                        onChanged: (String? newValue) {
                          print(newValue);
                          setState(() {
                            _selectedClass = newValue != null ? newValue : 'Q';
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
                Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Transform.scale(
                        scale: 0.7,
                        child: Checkbox(
                          value: _isChecked,
                          checkColor: Colors.black, // Set the checkbox state
                          onChanged: (bool? newValue) {
                            // Update the checkbox state when it's tapped
                            setState(() {
                              _isChecked = newValue == null ? false : newValue;
                            });
                          },
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                        ),
                      ),
                    ),
                    const Text('Teacher Login')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                      width: 500,
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black)),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();

                          setState(() {
                            visiblity = true;
                          });
                          if (!await validateAllInput()) {
                            setState(() {
                              visiblity = false;
                            });
                            return;
                          }
                          if (_isChecked) {
                            if (await DatabaseOp.isTeacher(
                                userController.value.text,
                                passController.value.text)) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherDashBoardScreen()),
                                  (Route route) => false);
                            }
                            setState(() {
                              visiblity = false;
                            });
                            return;
                          }
                          await validate(userController.value.text,
                              passController.value.text);

                          setState(() {
                            visiblity = false;
                          });
                        },
                        child: Text('LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                    visible: visiblity,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    )),
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
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Text('New user Sign up',
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
      ),
    );
  }

  Future<bool> validateAllInput() async {
    if (userController.value.text.isEmpty ||
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

  Future<void> validate(String username, String password) async {
    String namw = "";
    DatabaseOp.setDbName(_selectedClass);
    DatabaseOp.setCollectionName("Student_details");
    try {
      await DatabaseOp.createConnection();
    } catch (e) {
      print(e.toString());
    }
    print(DatabaseOp.databaseOp.collection);
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
    var isValid =
        await DatabaseOp.validateUsernameAndPassword(username, password);
    if (isValid) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashBoardScreen()),
          (Route route) => false);
    } else {
      await Fluttertoast.showToast(
        msg: "Invalid user id or password",
        gravity: ToastGravity.BOTTOM, // Toast position on the screen.
        backgroundColor: Colors.red.shade900, // Background color of the toast.
        textColor: Colors.black, // Text color of the toast message.
        fontSize: 16.0,
        toastLength: Toast
            .LENGTH_SHORT, // You can use Toast.LENGTH_LONG for a longer duration.

        // Font size of the toast message.
      );
    }
  }
}
