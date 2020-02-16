import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/local_inventory.json');
}

Future<File> get _serverFile async {
  final path = await _localPath;
  return File('$path/server_inventory.json');
}

Future<File> writeItem(response) async {
  final file = await _localFile;
  // Write the file.
  return file.writeAsString('response', mode: FileMode.append);
}

Future<File> writeInventoryFromServer(response) async {
  final file = await _serverFile;
  // Write the file.
  return file.writeAsString('response', mode: FileMode.append);
}
