import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:germanenapp/screens/sempro/sempro_pdf_reader_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../network/Database.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/sempro_item.dart';

class SemproPage extends StatefulWidget {
  const SemproPage({Key? key}) : super(key: key);

  @override
  _SemproPageState createState() => _SemproPageState();
}

class _SemproPageState extends State<SemproPage> {
  final Dio dio = Dio();

  Future<List> getFileDirectory(String url, String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String newPath = "${directory.path}/Germanen_App";
    directory = Directory(newPath);
    return [directory, File('${directory.path}/$fileName')];
  }

  Future<bool> savePdf(SemproItem sempro) async {
    List resultList = await getFileDirectory(sempro.url, sempro.fileName);
    Directory directory = resultList[0];
    File saveFile = resultList[1];

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (!saveFile.existsSync()) {
      await dio.download(sempro.url, saveFile.path,
          onReceiveProgress: (value1, value2) {
        setState(() {
          sempro.progress = value1 / value2;
          if (sempro.progress == 1.0) {
            sempro.isDownloaded = true;
          }
        });
      });
    }
    return sempro.isDownloaded;
  }

  Future<List<SemproItem>> getData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
        await Database.readSempros() as QuerySnapshot<Map<String, dynamic>>;
    List<SemproItem> semproList = [];
    for (var doc in querySnapshots.docs) {
      semproList.add(await generateMemoMaterial(doc.data()));
    }
    return semproList;
  }

  Future<SemproItem> generateMemoMaterial(Map<String, dynamic> data) async {
    List resultList = await getFileDirectory(data["url"], data["fileName"]);
    Directory directory = resultList[0];
    File file = resultList[1];
    bool isDownloaded = file.existsSync();

    return SemproItem(
      fileName: data["fileName"],
      size: data["size"],
      date: data["date"],
      url: data["url"],
      path: directory.path,
      progress: 0,
      loading: false,
      isDownloaded: isDownloaded,
    );
  }

  @override
  void initState() {
    super.initState();
    dataFuture = getData();
  }

  late Future<List<SemproItem>> dataFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<SemproItem>>(
            future: dataFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return Center(
                    child: Text("Connection active"),
                  );
                case ConnectionState.none:
                  return Center(
                    child: Text("Connection none"),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                        "snapshot has error ${snapshot.error}\n\n ${snapshot.stackTrace}");
                  }
                  if (snapshot.hasData) {
                    var semproList = snapshot.data;

                    if (semproList != null) {
                      if (semproList.isNotEmpty) {
                        return ListView.separated(
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            SemproItem sempro = semproList[index];
                            debugPrint("isDownloaded = ${sempro.isDownloaded}");
                            return InkWell(
                              child: SemproItem(
                                fileName: sempro.fileName,
                                size: sempro.size,
                                date: sempro.date,
                                url: sempro.url,
                                path: sempro.path,
                                progress: sempro.progress,
                                loading: sempro.loading,
                                isDownloaded: sempro.isDownloaded,
                              ),
                              onTap: () async {
                                debugPrint("onTap = ${sempro.isDownloaded}");
                                if (!sempro.isDownloaded) {
                                  //download File on first Click
                                  await downloadFile(sempro);
                                }
                                if (sempro.isDownloaded) {
                                  debugPrint("isDownloaded");
                                  final pdfController = PdfControllerPinch(
                                    document: PdfDocument.openFile(
                                        sempro.path + "/${sempro.fileName}"),
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemproPdfReaderScreen(
                                                  pdfController)));
                                }
                                debugPrint("tapped");
                              },
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 16.0,
                          ),
                          itemCount: semproList.length,
                        );
                      } else {
                        return Text("semproList isEmpty");
                      }
                    } else
                      return Text("semproList is null");
                  } else {
                    return Text("snapshot has no data");
                  }
              }
            }),
      ),
    );
  }

  Future<bool> downloadFile(SemproItem sempro) async {
    sempro.loading = true;
    bool downloaded = await savePdf(sempro);
    sempro.loading = false;
    if (downloaded) {
      Fluttertoast.showToast(msg: "Download Success!");
      sempro.isDownloaded = true;
    } else {
      Fluttertoast.showToast(msg: "Download Failed...");
    }
    return downloaded;
  }
}
