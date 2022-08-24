import 'package:flutter/material.dart';

// pickFiles
import 'package:file_picker/file_picker.dart';
// File
import 'dart:io';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));

int redColor = 500;
bool showSnackbar = false;

class Page {
  List<String> imageList = [];
  int currentIndex = 0;

  Page() {
    // directory = (await getApplicationDocumentsDirectory()).path;
    List<FileSystemEntity> newList = Directory("./images/").listSync();

    for (FileSystemEntity fileEntity in newList) {
      String filePath = fileEntity.toString();
      filePath = filePath.replaceFirst("File: '", "");
      // Remove last "'"
      filePath = filePath.substring(0, filePath.length - 1);

      imageList.add(filePath);
    }

    imageList.sort();
  }

  void add(String filePath) {
    imageList.add(filePath);
  }

  void next() {
    currentIndex = getNextIndex();
  }

  void previous() {
    currentIndex = (currentIndex - 1) % (imageList.length);
  }

  String getCurrent() {
    return imageList[currentIndex];
  }

  String getNext() {
    return imageList[getNextIndex()];
  }

  int getNextIndex() {
    return (currentIndex + 1) % (imageList.length);
  }
}

Page bookPage = Page();

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagina'),
        centerTitle: true,
        backgroundColor: Colors.red[redColor],
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.file_upload_rounded),
            tooltip: 'Load File',
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                File file = File(result.files.single.path.toString());
                debugPrint(file.path);

                Future<File> fileCopied = file.copy("./images/image_new.jpg");
                File fileCopiedTrue = await fileCopied;
                String fileCopiedPath = fileCopiedTrue.path;
                debugPrint("New File Path : $fileCopiedPath");
                bookPage.add(fileCopiedPath);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Files Information',
            onPressed: () {
              if (!showSnackbar) {
                String info = "List : ".toString() +
                    bookPage.imageList.toString() +
                    "\n".toString() +
                    "Current : ".toString() +
                    bookPage.getCurrent() +
                    "\n".toString() +
                    "Next : ".toString() +
                    bookPage.getNext();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(info)));
              } else {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              }

              showSnackbar = !showSnackbar;
            },
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_left, size: 50.0),
            tooltip: 'Previous Page',
            onPressed: () {
              bookPage.previous();
            },
          ),
          Image.asset(bookPage.getCurrent()),
          Image.asset(bookPage.getNext()),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right, size: 50.0),
            tooltip: 'Next Page',
            onPressed: () {
              bookPage.next();
            },
          ),
        ],
      ),
    );
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
  backgroundColor: Colors.red[redColor],
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
