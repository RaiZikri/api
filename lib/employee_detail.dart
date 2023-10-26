// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names
// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:api/employee_model.dart';
import 'restapi.dart';
import 'config.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({Key? key}) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  DataService ds = DataService();
  String profpic = '';
  late ValueNotifier<int> _notifier;
  List<EmployeeModel> employee = [];

  Future<void> selectIdEmployee(String id) async {
    List data = jsonDecode(await ds.selectId(token, project, 'employee', appid, id));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();
    profpic = employee[0].profpic;
  }

  Future<void> pickImage(String id) async {
    try {
      var picked = await FilePicker.platform.pickFiles(withData: true);
      if (picked != null) {
        var response = await ds.upload(token, project, picked.files.first.bytes!,
            picked.files.first.extension.toString());
        var file = jsonDecode(response);
        await ds.updateId(
            'profpic', file['file_name'], token, project, 'employee', appid, id);
        _notifier.value++;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    _notifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Detail"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => pickImage(args[0]),
              child: const Icon(
                Icons.camera_alt,
                size: 26.0,
              ),
            ),
          ),
          // Other actions here
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: selectIdEmployee(args[0]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const Text('none');
              }
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.active:
              {
                return const Text('Active');
              }
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else {
                  return ListView(
                    children: [
                      // Your UI components based on employee data
                    ],
                  );
                }
              }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}
