import 'package:flutter/material.dart';

// pickFiles
import 'package:file_picker/file_picker.dart';
// zip extraction
import 'package:archive/archive_io.dart';
// File Manipulation
import 'dart:io';

// getExtension getFileName
import 'package:flutter_application/file_system.dart';

AppBar generalBar(BuildContext context) {
  int redColor = 500;

  return AppBar(
    title: const Text('Imagina'),
    centerTitle: true,
    backgroundColor: Colors.red[redColor],
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.file_upload_rounded),
        tooltip: 'Load File',
        onPressed: () {
          loadBook(context);
        },
      ),
      IconButton(
        icon: const Icon(Icons.info_outline_rounded),
        tooltip: 'Files Information',
        onPressed: () {},
      ),
    ],
  );
}

void loadBook(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return;
  }
  File file = File(result.files.single.path.toString());
  debugPrint(file.path);

  String fileExtension = getExtension(file.path);
  if (fileExtension != "cbz") {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Issue when loading file'),
        content: Text('Unkown Extension $fileExtension'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  Future<File> fileCopied = file.copy("./images/${getFileName(file.path)}.zip");
  File fileCopiedTrue = await fileCopied;
  String fileCopiedPath = fileCopiedTrue.path;
  debugPrint("New File Path : $fileCopiedPath");

  extractFileToDisk(fileCopiedPath, './images/');
}
