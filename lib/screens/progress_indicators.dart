import "package:flutter/material.dart";
import 'package:mgflutter/util/constants.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProgressIndicators extends StatefulWidget {
  @override
  _ProgressIndicatorsState createState() => _ProgressIndicatorsState();
}

class _ProgressIndicatorsState extends State<ProgressIndicators> {
  double _progress;
  bool _validateFile = true;
  String _initFileURL =
      "https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_500_kB.pdf";
  String _initFileName = "file_example.pdf";

  /// Sample file

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _validateFile = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<File> _getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    print("dir ${dir.toString()}");
    return File("${dir.path}/$filename");
  }

  Future<void> downloadFile(String url, String downloadFileName) async {
    List<int> bytes = [];
    final request = Request('GET', Uri.parse(url));
    final StreamedResponse response = await Client().send(request);

    final contentLength = response.contentLength;

    final file = await _getFile(downloadFileName);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        setState(() {
          _progress = downloadedLength / contentLength;
        });
      },
      onDone: () async {
        setState(() {
          _progress = 1;
        });
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        print(e);
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlController =
        TextEditingController(text: _initFileURL);
    final TextEditingController downloadFileController =
        TextEditingController(text: _initFileName);
    return Scaffold(
      appBar: AppBar(title: Text("Download File With Progress Bars")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  "Provide URL of the file to download",
                  style: k_LabelTextStyle,
                ),
                TextFormField(
                  controller: urlController,
                  maxLines: null,
                  style: k_CommonTextStyle,
                  decoration: InputDecoration(
                      errorText: _validateFile
                          ? null
                          : 'Please enter a valid file URL',
                      border: UnderlineInputBorder(),
                      hintText: 'Enter file URL',
                      hintStyle: TextStyle(fontSize: 15)),
                ),
                SizedBox(height: 16),
                Text(
                  "Download file name",
                  style: k_LabelTextStyle,
                ),
                TextFormField(
                  controller: downloadFileController,
                  maxLines: null,
                  style: k_CommonTextStyle,
                  decoration: InputDecoration(
                      errorText: _validateFile
                          ? null
                          : 'Please enter a valid file name',
                      border: UnderlineInputBorder(),
                      hintText: 'Enter file URL',
                      hintStyle: TextStyle(fontSize: 15)),
                ),
                SizedBox(height: 16),
                RaisedButton(
                  child: Text(
                    "Download Now",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  elevation: 10,
                  color: Colors.blueAccent,
                  onPressed: () {
                    downloadFile(
                        urlController.text, downloadFileController.text);

                    setState(() {
                      _progress = 0;
                    });
                  },
                ),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 150,
                          width: 150,
                          child: (_progress == null)
                              ? Text("Click Download to start")
                              : CircularProgressIndicator(
                                  strokeWidth: 20,
                                  value: ((_progress == 1) ? 1 : null))),
                      Container(
                        height: 150,
                        width: 150,
                        child: (_progress == null)
                            ? null
                            : CircularProgressIndicator(
                                strokeWidth: 20, value: _progress),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 20,
                          width: 150,
                          child: (_progress == null)
                              ? null
                              : LinearProgressIndicator(
                                  value: (_progress == 1) ? 1 : null)),
                      Container(
                          height: 20,
                          width: 150,
                          child: (_progress == null)
                              ? null
                              : LinearProgressIndicator(value: _progress)),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 150,
                          child: Text(
                            "Indeterminate Progress",
                            style: k_LabelTextStyle,
                          )),
                      Container(
                          width: 150,
                          child: Text(
                            "Determinate Progress",
                            style: k_LabelTextStyle,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
