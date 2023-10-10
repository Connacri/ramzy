import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class LottieListPage extends StatefulWidget {
  @override
  _LottieListPageState createState() => _LottieListPageState();
}

class _LottieListPageState extends State<LottieListPage> {
  List<String> lottieFileNames = []; // List of Lottie file names

  @override
  void initState() {
    super.initState();
    loadLottieFiles();
  }

  // Load the list of Lottie files from the assets folder
  Future<void> loadLottieFiles() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final lottieFiles = manifestMap.keys
          .where((String key) => key.contains('assets/lotties/'))
          .toList();

      setState(() {
        lottieFileNames = lottieFiles;
      });
    } catch (e) {
      print('Error loading Lottie files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Lottie Animations'),
      ),
      body: ListView.builder(
        itemCount: lottieFileNames.length,
        itemBuilder: (context, index) {
          final lottieFileName = lottieFileNames[index];
          final lottieFilePath = 'assets/lotties/$lottieFileName';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              child: ListTile(
                  title: Text(
                    lottieFileName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Lottie.asset('${lottieFileName}')
                  // FutureBuilder(
                  //   future: rootBundle.loadString(lottieFilePath),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error loading Lottie');
                  //     } else {
                  //       return LottieBuilder.asset(
                  //         lottieFilePath,
                  //         width: 100,
                  //         height: 100,
                  //         fit: BoxFit.contain,
                  //       );
                  //     }
                  //   },
                  // ),
                  ),
            ),
          );
        },
      ),
    );
  }
}
