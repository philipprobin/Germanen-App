import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/sempro/sempro_pdf_reader_screen.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../network/Database.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/sempro_item.dart';

class SemproPage extends StatefulWidget {
  const SemproPage({Key? key}) : super(key: key);

  @override
  _SemproPageState createState() => _SemproPageState();
}

class _SemproPageState extends State<SemproPage> {
  final Dio dio = Dio();

  Future<List> getFileDirectory(String url, String fileName) async {
    Directory? directory = Directory.current;
    try {
      if (Platform.isAndroid) {
        debugPrint("isAndroid");
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          //storage/emulated/0/Android/data/de.turnerschaft.germania.germanenapp/files
          //finds path to Android folder
          String newPath = "";
          List<String> folders = directory!.path.split("/");
          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          //set newPath to .../android/Germanen_App
          newPath = newPath + "/Germanen_App";
          directory = Directory(newPath);
        }
      } else {
        if (await _requestPermission(Permission.storage)) {
          directory = await getTemporaryDirectory();
        }
      }
      return [directory, File(directory.path + "/$fileName")];
    } catch (e) {
      debugPrint("getFileDir crashed $e");
    }
    return [directory, File("ErrorPath")];
  }

  Future<bool> savePdf(SemproItem sempro) async {
    try {
      //here the saving folder is found
      List resultList = await getFileDirectory(sempro.url, sempro.fileName);
      Directory directory = resultList[0];
      File saveFile = resultList[1];
      debugPrint("savefile name ${saveFile.absolute} ");

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        debugPrint("Directory exists ");
        if (!saveFile.existsSync()) {
          debugPrint("File exists not yet");
          dio.download(sempro.url, saveFile.path,
              onReceiveProgress: (value1, value2) {
            setState(() {
              sempro.progress = value1 / value2;
              if (sempro.progress == 1.0) {
                sempro.isDownloaded = true;
              }
            });
          });
          if (Platform.isIOS) {
            await ImageGallerySaver.saveFile(
              saveFile.path,
              isReturnPathOfIOS: true,
            );
          }
          if (sempro.progress == 1.0) {
            return true;
          }
        } else {}
      }
      return false;
    } catch (e) {
      debugPrint("Something went wrong: $e");
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void checkFileExists(SemproItem sempro, File file) {
    bool exists = File(file.path).existsSync();
    if (!exists) {
      setState(() {
        sempro.isDownloaded = false;
        debugPrint("file is removed");
      });
    }
  }

  Future<bool> downloadFile(SemproItem sempro) async {
    setState(() {
      sempro.loading = true;
    });

    bool downloaded = await savePdf(sempro);

    if (downloaded) {
      debugPrint("Download Success!");
      setState(() {
        sempro.isDownloaded = true;
      });
      return true;
    } else {
      debugPrint("Download Failed...");
      return false;
    }
  }

  late Stream<List<SemproItem>> semproStream;
  late Future<List<SemproItem>> dataFuture;

  Future<List<SemproItem>> getData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
        await Database.readSempros() as QuerySnapshot<Map<String, dynamic>>;
    List<SemproItem> semproList = [];
    for (var i in querySnapshots.docs) {
      semproList.add(await generateMemoMaterial(i.data()));
    }
    return semproList;
  }

  Future<SemproItem> generateMemoMaterial(Map<String, dynamic> data) async {
    List resultList = await getFileDirectory(data["url"], data["fileName"]);
    Directory directory = resultList[0];
    File file = resultList[1];
    //check specific file downloaded
    bool isDownloaded = File(file.path).existsSync();
    debugPrint("File downloaded? $isDownloaded");
    debugPrint("this is a new File ${data["fileName"]}");
    debugPrint("Data: $data");

    //Null is not a subtype of type String -> check data form here
    try {
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
    } catch (e) {
      debugPrint("Error $e");
      return SemproItem(
        fileName: "ERROR: Datenbank überprüfen",
        size: "",
        date: "",
        url: "",
        path: directory.path,
        progress: 0,
        loading: false,
        isDownloaded: isDownloaded,
      );
    }
  }

  @override
  initState() {
    super.initState();
    dataFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppToolbar(
          sectionName: 'Germanen-App',
        ),
      ),
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
                                              SemproPdfReaderScreen(pdfController)));
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

  Future<PdfPageImage> openPDF(SemproItem sempro) async {
    debugPrint("openPdf ${sempro.path}");
    final document =
        await PdfDocument.openFile(sempro.path + "/${sempro.fileName}");
    debugPrint("document ${document}");
    final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height);
    return pageImage!;
  }
}
