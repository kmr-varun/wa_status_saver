import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class FilePreview extends StatefulWidget {
  final String path;
  final Function onDownloadClick, onShareClick;
  final bool isVideo;
  final bool isSaved;
  const FilePreview(
      {super.key,
      required this.path,
      required this.onDownloadClick,
      required this.onShareClick,
      required this.isVideo,
      required this.isSaved});

  @override
  State<StatefulWidget> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      initVideo();
    }
  }

  void initVideo() async {
    _controller = VideoPlayerController.file(File(widget.path));
    _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      allowMuting: true,
      showOptions: false,
    );
    _chewieController?.play();
  }

  Future<void> setWall(String pathx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set as Wallpaper'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Set this Photo as Wallpaper'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Set Wallpaper'),
              onPressed: () async {
                int location = WallpaperManager.BOTH_SCREEN;
                bool result = await WallpaperManager.setWallpaperFromFile(
                    pathx, location);
                Fluttertoast.showToast(
                  msg: "Wallpaper Set!",
                  toastLength: Toast.LENGTH_LONG,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: const TextStyle(color: Colors.white),
        title: Text(
          widget.isVideo ? "Video Preview" : "Image Preview",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          widget.isSaved
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 50,
                  child: InkWell(
                      child: const Icon(
                        CupertinoIcons.cloud_download_fill,
                        color: Colors.white,
                      ),
                      onTap: () {
                        widget.onDownloadClick();
                      }),
                ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 50,
            child: InkWell(
              child: const Icon(
                CupertinoIcons.share_solid,
                color: Colors.white,
              ),
              onTap: () {
                widget.onShareClick();
              },
            ),
          ),
          widget.isVideo
              ? const SizedBox(
                  width: 10,
                )
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 50,
                  child: InkWell(
                    child: const Icon(
                      CupertinoIcons.device_phone_portrait,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setWall(widget.path);
                    },
                  ),
                )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        heightFactor: double.maxFinite,
        widthFactor: double.maxFinite,
        child: widget.isVideo
            ? _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  )
            : Image.file(File(widget.path)),
      ),
    );
  }
}
