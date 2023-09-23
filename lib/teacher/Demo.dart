import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text('chlick here'),
            onPressed: sendnoti,
          ),
        ),
      ),
    );
  }

  void sendnoti() {}
}
