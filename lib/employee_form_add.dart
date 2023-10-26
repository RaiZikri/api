// ignore_for_file: ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'restapi.dart';
import 'config.dart';

class EmployeeFormAdd extends StatefulWidget {
  const EmployeeFormAdd({Key? key}) : super(key: key);

  @override
  _EmployeeFormAddState createState() => _EmployeeFormAddState();
}

class _EmployeeFormAddState extends State<EmployeeFormAdd> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';

  late Future<DateTime?> selectedDate;
  String date = "_";
  DataService ds = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Employee Form Add"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Name TextField
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
            // Gender Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                ),
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                items: ['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            // Birthday TextField with Date Picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: birthday,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Birthday",
                ),
                onTap: () {
                  showDialogPicker(context);
                },
              ),
            ),
            // Phone TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Phone Number",
                ),
              ),
            ),
            // Email TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email Address",
                ),
              ),
            ),
            // Address TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: address,
                maxLines: 4,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Address",
                ),
              ),
            ),
            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    List response = jsonDecode(await ds.insertEmployee(
                        appid, 
                        name.text,
                        phone.text, 
                        email.text, 
                        address.text,
                        gender, 
                        birthday.text,
                         "-"
                         ));
                    //List response = JsonDecoder(await ds.insertEmployee( name, phone, email, address, gender, birthday, profpic));
                    List<EmployeeModel> employee =
                        response.map((e) => EmployeeModel.fromJson(e)).toList();
                    if (employee.length == 1) {
                      Navigator.pop(context, true);
                    } else {
                      if (kDebugMode) {
                        print(response);
                      }
                    }
                  },
                  child: const Text("SUBMIT"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date Picker Dialog
  void showDialogPicker(BuildContext context) {
    var date = DateTime.now();
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime(date.year - 20, date.month, date.day),
      firstDate: DateTime(1980),
      lastDate: DateTime(date.year + 20, date.month, date.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    selectedDate.then((value) {
      setState(() {
        if (value == null) return; // Prevent Error When Null Close
        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);
        birthday.text = formattedDate;
      });
      
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
