import 'package:flutter/material.dart';

// pickFiles
import 'package:file_picker/file_picker.dart';
// zip extraction
import 'package:archive/archive_io.dart';
// File Manipulation
import 'dart:io';

import './global.dart';
import './file_system.dart';
import './book.dart';

void main() => runApp(const MaterialApp(
      // Remove the debug band
      debugShowCheckedModeBanner: false,
      home: CurrentPage(),
    ));

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

int getNumberOfElement(double ratio) {
  if (ratio >= 4) {
    return 7;
  } else if (ratio >= 3) {
    return 6;
  } else if (ratio >= 2.2) {
    return 5;
  } else if (ratio >= 1.6) {
    return 4;
  } else if (ratio >= 1.2) {
    return 3;
  } else if (ratio >= 0.6) {
    return 2;
  } else {
    return 1;
  }
}

class Animate {
  late AnimationController controller;
  late Animation animation;

  Animate(double begin, double end, int duration, var thisValue,
      Function setStateFunction) {
    // Defining controller with animation duration of two seconds
    controller = AnimationController(
        vsync: thisValue, duration: const Duration(milliseconds: 400));

    animation = Tween<double>(begin: 25.0, end: 0.0).animate(controller);

    // Rebuilding the screen when animation goes ahead
    controller.addListener(() {
      setStateFunction(() {});
    });
  }
}

class CurrentPage extends StatefulWidget {
  const CurrentPage({super.key});

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  Widget currentWidget = Container();

  int redColor = 500;

  void changeWidget(Widget newWidget) {
    setState(() {
      currentWidget = newWidget;
    });
  }

  @override
  void initState() {
    super.initState();

    currentWidget = Home(changeWidget);
  }

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
      ),
      body: currentWidget,
    );
  }
}

class Home extends StatefulWidget {
  final void Function(Widget) changeWidget;

  const Home(void Function(Widget) changeWidgetArg, {super.key})
      : changeWidget = changeWidgetArg;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Animate> animations = [];

  Books books = Books(gBooksPath);

  bool isImageHovered = false;

  bool showSnackbar = false;

  int? currentAnimationIndex;

  @override
  void initState() {
    super.initState();

    // Animate baseValue = Animate(25.0, 0.0, 400, this, setState);
    animations = [
      for (int i = 0; i < books.number; ++i)
        Animate(25.0, 0.0, 400, this, setState)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: LayoutBuilder(builder: (context, constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;
        double ratio = parentWidth / parentHeight;
        return GridView.count(
          primary: false,
          crossAxisCount: getNumberOfElement(ratio),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 3,
          children: List.generate(books.number, (index) {
            return Container(
              padding: EdgeInsets.all(animations[index].animation.value),
              child: IconButton(
                onPressed: () {
                  widget.changeWidget(
                      BookPage(widget.changeWidget, books[index]));
                },
                icon: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: MouseRegion(
                        onEnter: (PointerEvent details) {
                          currentAnimationIndex = index;
                          animations[index].controller.forward();
                        },
                        onExit: (PointerEvent details) {
                          animations[index].controller.reverse();
                        },
                        child: Image.file(books.getTitlePage(index)))),
              ),
            );
          }),
        );
      }),
    );
  }
}

class BookPage extends StatefulWidget {
  final Book book;
  final void Function(Widget) changeWidget;

  const BookPage(void Function(Widget) changeWidgetArg, this.book, {super.key})
      : changeWidget = changeWidgetArg;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, size: 50.0),
          tooltip: 'Previous Page',
          onPressed: () {
            setState(() {
              widget.book.previousPage();
            });
          },
        ),
        Image.file(widget.book.getCurrentPage()),
        Image.file(widget.book.getNextPage()),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right, size: 50.0),
          tooltip: 'Next Page',
          onPressed: () {
            setState(() {
              widget.book.nextPage();
            });
          },
        ),
      ],
    );
  }
}
