import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wa_status_saver/file_preview.dart';
import 'package:wa_status_saver/status_saver.dart';

import 'android_methods.dart';

class StatusCard extends StatefulWidget {
  final FileSystemEntity statusFile;
  final bool isVideo;
  final bool isSaved;
  const StatusCard(
      {super.key,
      required this.statusFile,
      this.isVideo = false,
      required this.isSaved});

  @override
  State<StatefulWidget> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  Uint8List? _videoImage;
  InterstitialAd? _interstitialAd;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  void loadIntAd() {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    setThumbnailFromVideo();
    createStatusSaveDirectory();
    loadIntAd();
  }

  void setThumbnailFromVideo() {
    VideoThumbnail.thumbnailData(
      video: widget.statusFile.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 480,
      maxWidth: 720,
    ).then((value) {
      setState(() {
        _videoImage = value;
      });
    });
  }

  void createStatusSaveDirectory() {
    Directory(StatusSaver.statusSaverPath)
        .create(recursive: true)
        .catchError((Object e) {
      Fluttertoast.showToast(
        msg: "Could not create directory to save status",
        toastLength: Toast.LENGTH_LONG,
      );
    });
  }

  void onDownloadClick() {
    List<String> fileParts = widget.statusFile.path.split('/');
    String fileName = fileParts.last;
    if (StatusSaver.fileExists(fileName)) {
      Fluttertoast.showToast(
        msg: "File Already Exists",
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      StatusSaver.saveFile(widget.statusFile)
          .then((value) async {
        await AndroidMethods.sendMediaScannerBroadcast(value.path);
        Fluttertoast.showToast(
          msg: "File Saved",
          toastLength: Toast.LENGTH_LONG,
        );
      }).catchError((Object e) {
        Fluttertoast.showToast(
          msg: "Could not save the file!",
          toastLength: Toast.LENGTH_LONG,
        );
      });
    }
  }

  void onShareClick() {
    Share.shareXFiles([XFile(widget.statusFile.path)]);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Ink.image(
              height: 300,
              image: widget.isVideo
                  ? _videoImage == null
                      ? Image.asset(
                          "images/loading.png",
                          width: 64,
                        ).image
                      : Image.memory(_videoImage!).image
                  : Image.file(
                      File(widget.statusFile.path),
                    ).image,
              fit: _videoImage == null ? BoxFit.scaleDown : BoxFit.cover,
              child: InkWell(
                onTap: () {
                  _interstitialAd?.show();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black87,
                      transitionDuration: const Duration(milliseconds: 250),
                      transitionsBuilder:
                          (ctx, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(Tween(
                              begin: const Offset(0, 1), end: Offset.zero)),
                          child: child,
                        );
                      },
                      pageBuilder: (BuildContext ctx, _, __) {
                        return FilePreview(
                          path: widget.statusFile.path,
                          onDownloadClick: onDownloadClick,
                          onShareClick: onShareClick,
                          isVideo: widget.isVideo,
                          isSaved: widget.isSaved,
                        );
                      }));
                  debugPrint("ImagePreview");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
