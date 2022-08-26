import 'package:flutter/material.dart';

// Tools

import 'dart:io';
import './file_system.dart';
import './book.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';

void loadJpg(Book bookPage) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path.toString());
    debugPrint(file.path);
    if (getExtension(file.path) != "cbr") {}
    extractFileToDisk('test.zip', 'out');

    Future<File> fileCopied = file.copy("./images/image_new.jpg");
    File fileCopiedTrue = await fileCopied;
    String fileCopiedPath = fileCopiedTrue.path;
    debugPrint("New File Path : $fileCopiedPath");
    bookPage.addPage(fileCopiedPath);
  }
}

// snippets for icons and buttons

var iconSample =
    const Icon(Icons.airport_shuttle, color: Colors.lightBlue, size: 50.0);

var containerSample = Container(
    color: Colors.cyan,
    padding: const EdgeInsets.all(30.0),
    child: const Text('inside container'));

var textSample = Text(
  'hello again, bibi!',
  style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    color: Colors.grey[600],
    fontFamily: 'IndieFlower',
  ),
);

var floatingButtonSample = FloatingActionButton(
  onPressed: () {},
  backgroundColor: Colors.red[500],
  child: const Text('click'),
);

var iconButtonBar1 = (BuildContext context) => IconButton(
      icon: const Icon(Icons.add_alert),
      tooltip: 'Show Snackbar',
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('This is a snackbar')));
      },
    );

var iconButtonBar2 = (BuildContext context) => IconButton(
      icon: const Icon(Icons.navigate_next),
      tooltip: 'Go to the next page',
      onPressed: () {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Next page'),
              ),
              body: const Center(
                child: Text(
                  'This is the next page',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            );
          },
        ));
      },
    );
