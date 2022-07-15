import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:desktop_test/application.dart';
import 'package:desktop_test/data.dart';
import 'package:desktop_test/downloader.dart';
import 'package:desktop_test/loading.dart';
import 'package:desktop_test/utility.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // await Window.initialize();
  await windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setResizable(true);
    await windowManager.setTitle('WTbgA');
    await windowManager.setIcon('assets/qatar_splash.png');
    // appDocPath = await AppUtil.getAppDocsPath();

    // if (SysInfo.operatingSystemName.contains('Windows 11')) {
    //   await Window.setEffect(effect: WindowEffect.acrylic, color: const Color(0xCC222222), dark: true);
    // } else {
    //   await Window.setEffect(effect: WindowEffect.aero, color: const Color(0xCC222222), dark: true);
    // }
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
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
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
  // bool isDownloading = false;
  // double downloadProgress = 0;
  // String downloadedFilePath = "";
  // Future<Map<String, dynamic>> loadJsonFromGithub() async {
  //   final response = await http.read(Uri.parse(
  //       "https://raw.githubusercontent.com/Lazizbek97/auto_update_desktop_test/main/app_version_check/version.json"));
  //   print("------------------------------------------");
  //   print(json.decode(response));

  //   return json.decode(response);
  // }

  // // this id for Windows
  // Future<void> openExeFile(String filePath) async {
  //   await Process.run(filePath, []).then((value) {});
  // }

  // // this for Mac
  // Future<void> openDMGFile(String filePath) async {
  //   await Process.start(
  //       "MOUNTDEV=\$(hdiutil mount '$filePath' | awk '/dev.disk/{print\$1}')",
  //       []).then((value) {
  //     debugPrint("Value: $value");
  //   });
  // }

  // Future downloadNewVersion(String appPath) async {
  //   final fileName = appPath.split("/").last;
  //   isDownloading = true;
  //   setState(() {});

  //   final dio = Dio();

  //   downloadedFilePath =
  //       "${(await getApplicationDocumentsDirectory()).path}/$fileName";

  //   await dio.download(
  //     "https://github.com/Lazizbek97/auto_update_desktop_test/blob/main/$appPath",
  //     downloadedFilePath,
  //     onReceiveProgress: (received, total) {
  //       final progress = (received / total) * 100;
  //       debugPrint('Rec: $received , Total: $total, $progress%');
  //       downloadProgress = double.parse(progress.toStringAsFixed(1));
  //       setState(() {});
  //     },
  //   );
  //   debugPrint("File Downloaded Path: $downloadedFilePath");
  //   if (Platform.isWindows) {
  //     await openExeFile(
  //       downloadedFilePath,
  //     );
  //   }
  //   isDownloading = false;
  //   setState(() {});
  // }

  // showUpdateDialog(Map<String, dynamic> versionJson) {
  //   final version = versionJson['version'];
  //   final updates = versionJson['description'] as List;
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return material.SimpleDialog(
  //           contentPadding: const EdgeInsets.all(10),
  //           title: Text("Latest Version $version"),
  //           children: [
  //             Text("What's new in $version"),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             ...updates
  //                 .map((e) => Row(
  //                       children: [
  //                         Container(
  //                           width: 4,
  //                           height: 4,
  //                           decoration: BoxDecoration(
  //                               color: Colors.grey[400],
  //                               borderRadius: BorderRadius.circular(20)),
  //                         ),
  //                         const SizedBox(
  //                           width: 10,
  //                         ),
  //                         Text(
  //                           "$e",
  //                           style: TextStyle(
  //                             color: Colors.grey[600],
  //                           ),
  //                         ),
  //                       ],
  //                     ))
  //                 .toList(),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             if (version > ApplicationConfig.currentVersion)
  //               material.TextButton.icon(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     if (Platform.isMacOS) {
  //                       downloadNewVersion(versionJson["macos_file_name"]);
  //                     }
  //                     if (Platform.isWindows) {
  //                       downloadNewVersion(versionJson["windows_file_name"]);
  //                     }
  //                   },
  //                   icon: const Icon(material.Icons.update),
  //                   label: const Text("Update")),
  //           ],
  //         );
  //       });
  // }

  // Future<void> _checkForUpdates() async {
  //   final jsonVal = await loadJsonFromGithub();
  //   debugPrint("Response: $jsonVal");
  //   showUpdateDialog(jsonVal);
  // }

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

  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        backgroundColor: Colors.blue,
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
                  'Current Version is ${ApplicationConfig.currentVersion}',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: material.FloatingActionButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await checkGitVersion(await checkVersion());
          });
          print("sdfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        },
        tooltip: 'Check for Updates',
        child: const Icon(material.Icons.update),
      ),
    );
  }
}
