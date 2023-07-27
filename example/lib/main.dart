import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqlserver_conn/sql_conn.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Test",
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Future<void> connect(BuildContext ctx) async {
    debugPrint("Connecting...");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("LOADING"),
            content: CircularProgressIndicator(),
          );
        },
      );
      await SqlserverConn.connect(
          ip: "your_ip",
          port: "your_port",
          databaseName: "your database name",
          username: "your username",
          password: "your password");
      debugPrint("Connected!");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> read(String query) async {
    var res = await SqlserverConn.readData(query);
    debugPrint(res.toString());
  }

  Future<void> write(String query) async {
    var res = await SqlserverConn.writeData(query);
    debugPrint(res.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => connect(context),
                  child: const Text("Connect")),
              ElevatedButton(
                  onPressed: () =>
                      read("EXEC dbo.PrGetVSOCatalogPLU @PCatID = 1"),
                  child: const Text("Read")),
              ElevatedButton(
                  onPressed: () => write("DELETE FROM IP_List WHERE LOC='vv1'"),
                  child: const Text("Write")),
              ElevatedButton(
                  onPressed: () => write(
                      "CREATE TABLE Persons (PersonID int, LastName varchar(255), FirstName varchar(255), Address varchar(255),City varchar(255))"),
                  child: const Text("Create Table")),
              ElevatedButton(
                  onPressed: () => write("DROP TABLE Persons"),
                  child: const Text("Delete Table")),
              ElevatedButton(
                  onPressed: () => SqlserverConn.disconnect(),
                  child: const Text("Disconnect"))
            ],
          ),
        ));
  }
}
