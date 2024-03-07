import 'dart:io';

class StatusSaver {
  static const String statusSaverPath =
      "/storage/emulated/0/Pictures/StatusSaver";

  static bool fileExists(String fileName) {
    return File("$statusSaverPath/$fileName").existsSync();
  }

  // static String _getSaveFileName(bool isVideo) {
  //   var now = DateTime.now();
  //   var fileName =
  //       "${isVideo ? "VID" : "IMG"}${now.year.toString().substring(2)}${now.month}${now.day}${now.hour}${now.minute}.${isVideo ? "mp4" : "jpg"}";

  //   int i = 0;
  //   while (fileExists(fileName)) {
  //     if (i != 0) {
  //       fileName = fileName.replaceAll(RegExp(r"\(\d+\)"), "(${++i})");
  //       continue;
  //     }
  //     var fileNameAndExt = fileName.split(".");
  //     fileName = "${fileNameAndExt[0]}(${++i}).${fileNameAndExt[1]}";
  //   }

  //   return fileName;
  // }

  static List<List<FileSystemEntity>> getStatusAsPhotosAndVideos(
      String waStatusFiles) {
    List<FileSystemEntity> statuses = Directory(waStatusFiles).listSync();
    List<FileSystemEntity> photoFiles = [], videoFiles = [];
    for (var element in statuses) {
      if (element.statSync().type == FileSystemEntityType.file) {
        if (element.path.endsWith(".mp4")) {
          videoFiles.add(element);
          continue;
        }
        if (element.path.endsWith(".jpg") ||
            element.path.endsWith(".jpeg") ||
            element.path.endsWith(".png")) {
          photoFiles.add(element);
          continue;
        }
      }
    }
    return [photoFiles, videoFiles];
  }

  static void downloadStatusAuto() {
    String waStatusFiles =
        '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
    String savedFiles = '/storage/emulated/0/Pictures/StatusSaver';
    List<FileSystemEntity> statuses = Directory(waStatusFiles).listSync();
    List<FileSystemEntity> saved = Directory(savedFiles).listSync();
    List<String> savedStatuses = [];
    for (var i in saved) {
      List<String> fileParts = i.path.split('/');
      String fileName = fileParts.last;
      savedStatuses.add(fileName);
    }
    
    for (var element in statuses) {
      List<String> fileParts = element.path.split('/');
      String fileName = fileParts.last;
      if (savedStatuses.contains(fileName) == false) {
        saveFile(element);
      }
    }
    
  }

  static bool checkNewStatus() {
    String waStatusFiles =
        '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
    String savedFiles = '/storage/emulated/0/Pictures/StatusSaver';
    List<FileSystemEntity> statuses = Directory(waStatusFiles).listSync();
    List<FileSystemEntity> saved = Directory(savedFiles).listSync();
    List<String> savedStatuses = [];
    for (var i in saved) {
      List<String> fileParts = i.path.split('/');
      String fileName = fileParts.last;
      savedStatuses.add(fileName);
    }
    bool newStat = false;
    for (var element in statuses) {
      List<String> fileParts = element.path.split('/');
      String fileName = fileParts.last;
      if (savedStatuses.contains(fileName) == false) {
        newStat = true;
      } else {
        newStat = false;
      }
    }
    return newStat;
  }

  static Future<File> saveFile(FileSystemEntity file) {
    List<String> fileParts = file.path.split('/');
    String fileName = fileParts.last;
    // return File(file.path)
    //     .copy("$statusSaverPath/${_getSaveFileName(isVideo)}");
    return File(file.path).copy("$statusSaverPath/$fileName");
  }
}
