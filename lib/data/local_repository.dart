import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getTemporaryDirectory();
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

Future<String> readLocalInventoryFile() async {
  try {
    final file = await _localFile;
    String body = await file.readAsString();
    return body;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}

Future<File> writeItem(response) async {
  try {
    final file = await _localFile;
    // Write the file.
    return file.writeAsString('$response', mode: FileMode.append);
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<File> writeInventoryFromServer(response) async {
  final file = await _serverFile;
  // Write the file.
  return file.writeAsString('$response', mode: FileMode.write);
}
