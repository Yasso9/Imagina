import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:flutter_application/file_system.dart';

extension IntExtensions on int {
  bool isIncluded(int left, int right, {isExclusive = false}) {
    if (left > right) {
      throw Exception('$left is bigger than $right');
    }

    if (isExclusive) {
      return left < this && this < right;
    } else {
      return left <= this && this <= right;
    }
  }
}

class Book {
  List<String> imageList = [];
  int currentIndex = 0;

  Book(String bookFolderPath) {
    imageList = getFileList(bookFolderPath, extension: "jpg");
  }

  void addPage(String filePath) {
    imageList.add(filePath);
  }

  void nextPage() {
    currentIndex = getNextIndex();
  }

  void previousPage() {
    currentIndex = (currentIndex - 1) % (imageList.length);
  }

  File getCurrentPage() {
    return File(imageList[currentIndex]);
  }

  File getNextPage() {
    return File(imageList[getNextIndex()]);
  }

  String getPage(int index) {
    if (!index.isIncluded(0, imageList.length)) {
      throw Exception('$index is out of range (0, ${imageList.length})');
    }

    return imageList[index];
  }

  int getNextIndex() {
    return (currentIndex + 1) % (imageList.length);
  }
}

class Books {
  List<String> list = [];

  Books(String booksFolder) {
    list = getFolderList(booksFolder);
  }

  Book operator [](int index) {
    return Book(list[index]);
  }

  File getTitlePage(int index) {
    if (!index.isIncluded(0, list.length - 1)) {
      debugPrint("$index out of range (0, ${list.length - 1}");
    }

    return File(getFileList(list[index], extension: "jpg")[0]);
  }

  int get number {
    return list.length;
  }
}
