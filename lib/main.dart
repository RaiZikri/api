import 'package:flutter/material.dart';

import 'package:api/employee_form_add.dart';
import 'package:api/employee_form_edit.dart';
import 'employee_list.dart';
import 'package:api/employee_detail.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee',
      home: const EmployeeList(),
      routes: {
        'employee_list': (context) => const EmployeeList(),
        'employee_form_add': (context) => const EmployeeFormAdd(),
        'employee_form_edit': (context) => const EmployeeFormEdit(),
        'employee__detail': (context) => const EmployeeDetail(),
      },
    );
  }
}