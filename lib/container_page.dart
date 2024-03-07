import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:wa_status_saver/status_card.dart';

class ContainerPage extends StatefulWidget {
  final List<io.FileSystemEntity> data;
  final Function onRefresh;
  final bool isVideo;
  final String appName;
  final bool isSaved;
  const ContainerPage(
      {super.key,
      required this.data,
      required this.onRefresh,
      this.isVideo = false,
      required this.appName,
      required this.isSaved});

  @override
  State<StatefulWidget> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          widget.onRefresh();
        });
      },
      child: widget.data.isEmpty
          ? Center(
              child: Text(widget.isSaved
                  ? 'Download Statuses to Save Them'
                  : 'Open ${widget.appName} and View Status to See them here'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1 / 1.1,
              ),
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                return StatusCard(
                  statusFile: widget.data[index],
                  isVideo: widget.isVideo,
                  isSaved: widget.isSaved,
                );
              },
            ),
    );
  }
}
