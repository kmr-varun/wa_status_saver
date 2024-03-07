import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wa_status_saver/android_methods.dart';
import 'package:wa_status_saver/container_page.dart';
import 'package:wa_status_saver/main.dart';
import 'package:wa_status_saver/status_saver.dart';

class WhatsApp extends StatefulWidget {
  final bool isSaved;
  final String appName;
  final String appDir;
  final bool isAvailable;
  const WhatsApp(
      {super.key,
      required this.isSaved,
      required this.appName,
      required this.appDir,
      required this.isAvailable});

  @override
  State<WhatsApp> createState() => _WhatsAppState();
}

class _WhatsAppState extends State<WhatsApp> {
  bool _isPermissionGranted = false;
  List<io.FileSystemEntity> _photoStatuses = [], _videoStatuses = [];
  static const Widget permissionErrorMsg = Center(
    child: Text("Please grant the permission for this app to work!"),
  );

  @override
  void initState() {
    super.initState();

    checkPermission().then((value) async {
      var statusFiles = StatusSaver.getStatusAsPhotosAndVideos(widget.appDir);
      debugPrint(statusFiles[0].toString());
      setState(() {
        _photoStatuses = statusFiles[0];
        _videoStatuses = statusFiles[1];
      });
      appPermissionManager();
    }).catchError((Object e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Something went wrong while requesting permission",
          toastLength: Toast.LENGTH_LONG);
    });
  }

  Future<void> checkPermission() async {
    String aVersion =
        await AndroidMethods.getAndroidVersion().catchError((Object err) {
      Fluttertoast.showToast(
          msg: "Error getting android version!",
          toastLength: Toast.LENGTH_LONG);
      debugPrint(err.toString());
    });

    if (int.parse(aVersion) <= 10) {
      if (await Permission.storage.request().isGranted) {
        setState(() {
          _isPermissionGranted = true;
        });
      }
      return;
    }

    if (await Permission.manageExternalStorage.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      return;
    }
    if (await Permission.manageExternalStorage.request().isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    }
  }

  void onRefresh() {
    var statusFiles = StatusSaver.getStatusAsPhotosAndVideos(widget.appDir);
    setState(() {
      _photoStatuses = statusFiles[0];
      _videoStatuses = statusFiles[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAvailable
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.isSaved
                      ? "Saved Files"
                      : "${widget.appName} Status Saver",
                  style: TextStyle(
                    color: Colors.teal.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Photos"),
                    Tab(
                      text: "Videos",
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: _isPermissionGranted
                    ? [
                        ContainerPage(
                          data: _photoStatuses,
                          onRefresh: onRefresh,
                          appName: widget.appName,
                          isSaved: widget.isSaved,
                        ),
                        ContainerPage(
                          data: _videoStatuses,
                          onRefresh: onRefresh,
                          isVideo: true,
                          appName: widget.appName,
                          isSaved: widget.isSaved,
                        )
                      ]
                    : [permissionErrorMsg, permissionErrorMsg],
              ),
            ),
          )
        : Center(
            child: Text("Install ${widget.appName} to View Statuses Here"),
          );
  }
}
