// File Manipulation
import 'dart:io';

void copyFile(String filePathA, String filePathB) async {
  File file = File(filePathA);
  await file.copy(filePathB);
}

String getExtension(String file) {
  int index = file.lastIndexOf('.');

  if (index == -1) {
    return "";
  }

  return file.substring(index + 1);
}

String getFileName(String filePath) {
  // A file name is between a slash and a dot
  int indexStart = filePath.lastIndexOf('/');
  int indexEnd = filePath.lastIndexOf('.');

  if (indexEnd == -1) {
    indexEnd = filePath.length;
  }

  return filePath.substring(indexStart + 1, indexEnd);
}

String getFolderName(String filePath) {
  int indexStart;
  int indexEnd;

  // A folder name is between a slash and a slash
  int lastSlash = filePath.lastIndexOf('/');

  if (lastSlash == -1) {
    return filePath;
  } else if (lastSlash == filePath.length - 1) {
    indexEnd = lastSlash;
    indexStart = filePath.substring(0, lastSlash).lastIndexOf('/');
  } else {
    indexStart = lastSlash;
    indexEnd = filePath.length;
  }

  return filePath.substring(indexStart, indexEnd);
}

// The extension must not start with a "."
List<String> getFileList(String directory, {String? extension}) {
  List<String> filePathList = [];

  List<FileSystemEntity> fileList = Directory(directory).listSync();

  for (FileSystemEntity fileEntity in fileList) {
    String filePath = fileEntity.toString();

    // We only returns files
    if (!filePath.contains("File: ")) {
      continue;
    }

    // Remove first "File: '"
    filePath = filePath.replaceFirst("File: '", "");
    // Remove last "'"
    filePath = filePath.substring(0, filePath.length - 1);

    if (getExtension(filePath) == extension) {
      filePathList.add(filePath);
    }
  }

  filePathList.sort();

  return filePathList;
}

List<String> getFolderList(String directory) {
  List<String> folderPathList = [];

  List<FileSystemEntity> systemEntityList = Directory(directory).listSync();

  for (FileSystemEntity systemEntity in systemEntityList) {
    String path = systemEntity.toString();

    // We only returns directories
    if (!path.contains("Directory: ")) {
      continue;
    }

    // Remove first "Directory: '"
    path = path.replaceFirst("Directory: '", "");
    // Remove last "'"
    path = path.substring(0, path.length - 1);

    folderPathList.add(path);
  }

  folderPathList.sort();

  return folderPathList;
}
