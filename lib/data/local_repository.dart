import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../screens/scan_screen.dart';
import '../utils/fade_route.dart';

File jsonFile;
Directory dir;
String local = "local_inventory.json";
String server = "server_inventory.json";
bool fileExists = false;

Future<String> readLocalInventoryFile(context) async {
  existingFile(context);
  try {
    String dir = (await getApplicationDocumentsDirectory()).path;
    Future<String> body = File(dir + "/" + local).readAsString();
    return body;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
} //readLocalInventoryFile

Future<void> writeItem(response) async {
  try {
    final filename = 'local_inventory.json';
    String dir = (await getApplicationDocumentsDirectory()).path;
    File(dir + "/" + filename)
        .writeAsStringSync(response, mode: FileMode.append);
    print("write item try statement: " + dir + "/" + filename);
    return null;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
} //writeItem

Future<void> writeInventoryFromServer(response) async {
  try {
    final filename = 'server_inventory.json';
    String dir = (await getApplicationDocumentsDirectory()).path;
    File(dir + "/" + filename).writeAsStringSync(response);
  } catch (e) {
    print(e.toString());
  }
} //writeInventoryFromServer

void getDirectory() async {
  /*to store files temporary we use getTemporaryDirectory() but we want
    permanent storage so we use getApplicationDocumentsDirectory() */
  await getApplicationDocumentsDirectory().then((Directory directory) {
    dir = directory;
    jsonFile = new File(dir.path + "/" + local);
    fileExists = jsonFile.existsSync();
  });
}

void createFile(Directory dir, String fileName) {
  print("Creating file!");
  File file = new File(dir.path + "/" + fileName);
  file.createSync();
  fileExists = true;
}

void existingFile(context) async {
  getDirectory();
  if (fileExists) {
    print("File exists");
  } else {
    print("File does not exist!");
    createFile(dir, local);
    _alertCreatingFile(context);
  }
}

void _alertCreatingFile(context) {
  new Alert(
    context: context,
    type: AlertType.info,
    title: "Creating file on your phone.",
    desc: "Please transfer to add an item to begin.",
    buttons: [
      DialogButton(
        child: Text(
          "Transfer",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: Colors.teal,
        onPressed: () => Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => Scan(),
        )),
      ),
    ],
  ).show();
} //_alertSuccess
