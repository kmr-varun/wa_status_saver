import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wa_status_saver/app_icons.dart';
import 'package:wa_status_saver/pages/settings.dart';
import 'package:wa_status_saver/pages/whatsapp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  static bool checkDir(String dirName) {
    return Directory(dirName).existsSync();
  }

  List pages = [
    WhatsApp(
      isSaved: false,
      isAvailable: true,
      appName: 'Whatsapp',
      appDir:
          checkDir('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses') ? '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses' : '/storage/emulated/0/WhatsApp/Media/.Statuses',
    ),
    WhatsApp(
      isSaved: false,
      isAvailable: checkDir(
          '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses'),
      appName: 'Whatsapp Bussniess',
      appDir:
          '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
    ),
    WhatsApp(
      isSaved: false,
      isAvailable: checkDir(
          '/storage/emulated/0/Android/media/com.gbwhatsapp/GBWhatsApp/Media/.Statuses'),
      appName: 'GB Whatsapp',
      appDir:
          '/storage/emulated/0/Android/media/com.gbwhatsapp/GBWhatsApp/Media/.Statuses',
    ),
    const WhatsApp(
      isSaved: true,
      isAvailable: true,
      appName: 'Saved File',
      appDir: '/storage/emulated/0/Pictures/StatusSaver',
    ),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: Container(
        color: Colors.teal.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.teal.shade50,
            color: Colors.teal.shade200,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.teal.shade200,
            padding: const EdgeInsets.all(16),
            gap: 8,
            onTabChange: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            tabs: [
              GButton(
                icon: AppIcons.whatsapp,
                iconColor: Colors.green.shade400,
                text: 'Whatsapp',
              ),
              GButton(
                icon: AppIcons.whatsapp,
                iconColor: Colors.greenAccent.shade400,
                text: 'Whatsapp Bussiness',
              ),
              GButton(
                icon: AppIcons.whatsapp,
                iconColor: Colors.teal.shade400,
                text: 'GB Whatsapp',
              ),
              const GButton(
                icon: Icons.download,
                text: 'Saved',
              ),
              const GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
