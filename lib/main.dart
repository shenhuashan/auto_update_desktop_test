import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:desktop_test/data.dart';
import 'package:desktop_test/downloader.dart';
import 'package:desktop_test/loading.dart';
import 'package:desktop_test/utility.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // await Window.initialize();
  await windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setResizable(true);
    await windowManager.setTitle('desktop_test');
    await windowManager.setIcon('assets/qatar_splash.png');

    await windowManager.show();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: 'In App Updates in Flutter Desktop App',
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String versionNumber = "";

  Future<String> checkVersion() async {
    try {
      final File file = File(AppUtil.versionPath);
      final String version = await file.readAsString();
      return version;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      rethrow;
    }
  }

  Future<void> checkGitVersion(String version) async {
    versionNumber = version;
    try {
      Data data = await Data.getData();
      if (int.parse(data.tagName.replaceAll('.', '')) >
          int.parse(version.replaceAll('.', ''))) {
        if (!mounted) return;
        showSnackbar(
            context,
            Snackbar(
              content: Text(
                  'Version: $version. Status: Proceeding to update in 4 seconds!'),
              extended: true,
              action: TextButton(
                  child: const Text('Cancel update'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) =>
                            const MyHomePage(title: "home Page"),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 1000),
                      ),
                    );
                  }),
            ));

        Future.delayed(const Duration(seconds: 4), () async {
          Navigator.of(context)
              .pushReplacement(FluentPageRoute(builder: (context) {
            return const Downloader();
          }));
        });
      } else {
        if (!mounted) return;

        showSnackbar(
            context,
            Snackbar(
              content: Text('Version: $version ___ Status: Up-to-date!'),
              extended: true,
            ));
        Future.delayed(const Duration(microseconds: 500), () async {
          Navigator.pushReplacement(
            context,
            FluentPageRoute(
              builder: (context) => const MyHomePage(title: "home Page"),
            ),
          );
        });
      }
    } catch (e, st) {
      showSnackbar(
          context,
          Snackbar(
            content: Text(
                'Version: $version ___ Status: Error checking for update!'),
            extended: true,
          ));
      log(e.toString(), stackTrace: st);
      Future.delayed(const Duration(seconds: 2), () async {
        Navigator.pushReplacement(
          context,
          FluentPageRoute(
            builder: (context) => const MyHomePage(title: "home Page"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Version is $versionNumber',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: material.FloatingActionButton(
        onPressed: () async {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await checkGitVersion(await checkVersion());
          });
          setState(() {});
          print("sdfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        },
        tooltip: 'Check for Updates',
        child: const Icon(material.Icons.update),
      ),
    );
  }
}
