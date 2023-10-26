import 'dart:convert';

import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'restapi.dart';
import 'config.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final searchKeyword = TextEditingController();
  bool searchStatus = false;

  DataService ds = DataService();
  late List data = [];
  late List<EmployeeModel> employee;
  late List<EmployeeModel> search_data;
  late List<EmployeeModel> search_data_pre;

  @override
  void initState() {
    super.initState();
    selectAllEmployee();
  }

  Future<void> selectAllEmployee() async {
    data = jsonDecode(await ds.selectAll(token, project, 'employee', appid));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();
    search_data = List.from(employee);
    search_data_pre = List.from(employee);
    setState(() {});
  }

  void filterEmployee(String enteredKeyWord) {
    if (enteredKeyWord.isEmpty) {
      search_data = List.from(search_data_pre);
    } else {
      search_data = search_data_pre
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchStatus
            ? const Text("Employee List")
            : TextField(
                controller: searchKeyword,
                onChanged: filterEmployee,
                decoration: InputDecoration(
                  hintText: 'Search...',
                ),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'employee_form_add')
                    .then((value) => reloadDataEmployee(value));
              },
              child: const Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
          IconButton(
            icon: Icon(searchStatus ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                searchStatus = !searchStatus;
                if (!searchStatus) {
                  searchKeyword.clear();
                  filterEmployee('');
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: search_data.length,
        itemBuilder: (context, index) {
          final item = search_data[index];

          return ListTile(
            title: Text(item.name),
            onTap: () {
              Navigator.pushNamed(context, 'employee_detail',
                  arguments: [item.id]).then((value) => reloadDataEmployee(value));
            },
          );
        },
      ),
    );
  }

  Future<void> reloadDataEmployee(dynamic value) async {
    await selectAllEmployee();
  }
}
