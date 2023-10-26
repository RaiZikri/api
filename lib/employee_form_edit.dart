import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'employee_model.dart';

import 'restapi.dart';
import 'config.dart';

class EmployeeFormEdit extends StatefulWidget {
  const EmployeeFormEdit({Key? key}) : super(key : key);

  @override
  _EmployeeFormEditState createState() => _EmployeeFormEditState();
}

class _EmployeeFormEditState extends State<EmployeeFormEdit> {
  DataService ds = DataService();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';
  String profpic = '';
  String update_id = '';
  bool loadData = false;

  late Future<DateTime?> selectedDate;
  String date = "-";

  // Employee Data
  List<EmployeeModel> employee = [];

  selectIdEmployee(String id) async {
    List data = [];
    data = jsonDecode(await ds.selectId(token, project, 'Office Swagger', appid, id));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    setState(() {
      name.text = employee[0].name;
      birthday.text = employee[0].birthday;
      email.text = employee[0].email;
      address.text = employee[0].address;
      gender = employee[0].gender;
      update_id = employee[0].id;
      profpic = employee[0].profpic;
    });
  }

  @override
  Widget build(BuildContext context){
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    if (loadData == false) {
      selectIdEmployee(args[0]);

      loadData = true;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Employee Form Edit"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Full Name',
                ),
              ),
            ),
            //Gender
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none
                ),
                value: gender,
                onChanged: (String? newValue){
                  setState(() {
                    gender = newValue!;
                  });
                },
                items: <String> ['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),
            ),
            //Birthday
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: birthday,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Birthday"
                ),
                onTap: () {
                  showDialogPicker(context, birthday.text);
                },
              ),
            ),
            //Phone
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: birthday,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Phone Number",
                ),
              ),
            ),
            //Email Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email Address"
                ),
              ),
            ),
            //Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: address,
                maxLines: 4,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Address"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen, elevation: 0),
                onPressed: () async {
                  bool updateStatus = await ds.updateId(
                    'name~phome~email~address~gender~birthday~profpic', 
                    name.text +
                        '~' +
                        phone.text +
                        '~' +
                        email.text +
                        '~' +
                        address.text +
                        '~' +
                        gender +
                        '~' +
                        birthday.text +
                        '~' +
                        profpic, 
                      token, 
                      project, 
                      'Office Swagger', 
                      appid, 
                      update_id);

                  if (updateStatus) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text("UPDATE"),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context, String curr_birthday) {
    DateTime initialDate;
    if(curr_birthday == ''){
      initialDate = DateTime.now();
    } else {
      var inputFormat = DateFormat('dd-MMM-yyy');
      initialDate = inputFormat.parse(curr_birthday);
    }

    selectedDate = showDatePicker(
      context: context, 
      initialDate:
          DateTime.utc(initialDate.year, initialDate.month, initialDate.day), 
      firstDate: DateTime(1980), 
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), 
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      if (value == null) return;

      final DateFormat formatter = DateFormat('dd-MM-yyy');
      final String formattedDate = formatter.format(value);

      setState(() {
        birthday.text = formattedDate.toString();
      });
    }, onError: (error){
      if(kDebugMode) {
        print(error);
      }
    });
  }
}