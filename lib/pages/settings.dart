import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wa_status_saver/pages/aboutus.dart';
import 'package:wa_status_saver/pages/privacy_policy.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool notificationsEnabled;
  late bool automaticStatusDownload;

  void setupVars() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('noti') == true) {
      setState(() {
        notificationsEnabled = true;
      });
    } else {
      setState(() {
        notificationsEnabled = false;
      });
    }

    if (prefs.getBool('autostat') == true) {
      setState(() {
        automaticStatusDownload = true;
      });
    } else {
      setState(() {
        automaticStatusDownload = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupVars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Whatsapp Status Saver",
          style: TextStyle(
            color: Colors.teal.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.workspace_premium_sharp),
                title: const Text('Upgrade To Pro'),
                value: const Text('Remove all Ads'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.teal.shade300),
            ),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (bool isEnabled) {
                  setState(() {
                    notificationsEnabled = isEnabled;
                  });
                },
                initialValue: notificationsEnabled,
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                description:
                    const Text('Get Notified when new status is available'),
              ),
              SettingsTile.switchTile(
                onToggle: (bool isEnabled) async {
                  final service = FlutterBackgroundService();
                  var isRunning = await service.isRunning();
                  if (!isRunning) {
                    service.startService();
                    if (isEnabled) {
                      FlutterBackgroundService().invoke("setAsForeground");
                    } else {
                      FlutterBackgroundService().invoke("setAsBackground");
                    }
                  }
                  if (isEnabled) {
                    FlutterBackgroundService().invoke("setAsForeground");
                  } else {
                    FlutterBackgroundService().invoke("setAsBackground");
                  }
                  setState(() async {
                    automaticStatusDownload = isEnabled;
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('autostat', isEnabled);
                  });
                },
                initialValue: automaticStatusDownload,
                leading: const Icon(Icons.downloading_rounded),
                title: const Text('Save New Status automatically'),
                description: const Text('Automatically Save all New Statuses'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.sim_card_download_rounded),
                title: const Text('Download Location'),
                value: const Text('/storage/emulated/0/Pictures/StatusSaver/'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.person_2_rounded),
                title: const Text('About Us'),
                value: const Text('About Our team and Contact Us'),
                onPressed: (context) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsPage()));
                },
              ),
              SettingsTile.navigation(
                onPressed: (context) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()));
                },
                leading: const Icon(Icons.language),
                title: const Text('Privacy Policy'),
                value: const Text('Our Terms and Conditions'),
              ),
              SettingsTile.navigation(
                onPressed: (context) {
                  Share.share('Try This New Whatsapp Status Downloader', subject: 'Whatsapp Status Downloader');
                },
                leading: const Icon(Icons.ios_share_rounded),
                title: const Text('Share with Others'),
                value: const Text('Share this app with your beloved friends'),
              ),
              SettingsTile.navigation(
                onPressed: (context) {
                  launchUrl(
                    Uri.parse('https://google.com'), // Rate Us
                  );
                },
                leading: const Icon(Icons.star_rate_rounded),
                title: const Text('Rate Us'),
                value: const Text('Please support our work by your rating'),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
