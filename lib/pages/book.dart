import 'package:flutter/material.dart';

import 'package:flutter_application/app_bar.dart';
import 'package:flutter_application/book.dart';

class BookPage extends StatefulWidget {
  final Book book;

  const BookPage(this.book, {super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generalBar(context),
        body: Row(
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
        ));
  }
}
