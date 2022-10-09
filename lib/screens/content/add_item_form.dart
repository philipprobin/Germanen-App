import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/content/take_photo.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:open_file/open_file.dart';


List<CameraDescription>? cameras;

class AddItemForm extends StatefulWidget {
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;

  const AddItemForm({
    required this.titleFocusNode,
    required this.descriptionFocusNode,
  });

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  List<File> files = [];

  final Database database = Database();

  bool _isProcessing = false;
  bool _isLookingForFiles = false;

  String getTitle = "";
  String getDescription = "";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //camera
  late CameraDescription _cameraDescription;

  @override
  void initState() {
    super.initState();
    debugPrint("init");
    availableCameras().then((cameras) {

      debugPrint("availableCameras");
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {

        debugPrint("setState");
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _addItemFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Gib einen Titel ein ...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 1.4,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        controller: _titleController,
                        focusNode: widget.titleFocusNode,
                        keyboardType: TextInputType.text,
                        validator: _requiredTitleValidator,
                      ),
                      //descripton
                      SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.only(
                            top: 0,
                            left: 12,
                            bottom: 100.0,
                          ),
                          hintText: 'Gib eine Beschreibung ein ...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 1.4,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _descriptionController,
                        focusNode: widget.descriptionFocusNode,
                        keyboardType: TextInputType.text,
                        validator: _requiredDescriptionValidator,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          files += (await selectImages())!;
                          debugPrint('dateien $files');
                        },
                        child: Text('Foto(s) auswählen'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final String? imagePath =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TakePhoto(
                                camera: _cameraDescription,
                              ),
                            ),
                          );

                          if (imagePath != null) {
                            setState(() {
                              files.add(File(imagePath));
                            });
                          }

                          debugPrint('dateien $files');
                        },
                        child: Text('Foto schießen'),
                      ),
                      _isLookingForFiles
                          ? Container()
                          : Container(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: files.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.all(2),
                                    color: Colors.grey[800],
                                    child: Image.file(
                                      File(files[index].path.toString()),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.topCenter,
                                    ),
                                  );
                                },
                              ),
                            ),

                      _isProcessing
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            )
                          : FloatingActionButton(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () async {
                                widget.titleFocusNode.unfocus();
                                widget.descriptionFocusNode.unfocus();

                                if (_addItemFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  ///upload image

                                  await database.addItem(
                                      title: getTitle,
                                      description: getDescription,
                                      files: files);

                                  setState(() {
                                    _isProcessing = false;
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<CameraDescription>> setUpCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    return await availableCameras();
  }

  String? _requiredTitleValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Bitte gib einen Text ein.';
    }
    getTitle = text;
    return null;
  }

  String? _requiredDescriptionValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Bitte gib einen Text ein.';
    }
    getDescription = text;
    return null;
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<List<File>?> selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage(
      imageQuality: 50,
    );
    if (selectedImages!.isNotEmpty) {
      setState(() {
        _isLookingForFiles = false;
      });
      return selectedImages.map((val) => File(val.path)).toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Datei ausgewählt.'),
        ),
      );
      setState(() {
        _isLookingForFiles = true;
      });
      return null;
    }
  }
/*
  Future<List<File>?> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Datei ausgewählt.'),
        ),
      );
      setState(() {
        _isLookingForFiles = true;
      });
      return null;
    } else {
      setState(() {
        _isLookingForFiles = false;
      });
      //creates new Fileslist
      return result.paths.map((path) => File(path!)).toList();
    }
  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

 */
}

/*

ElevatedButton(
                        onPressed: () async {
                          final results = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg'],
                          );
                          if (results == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Keine Datei ausgewählt.'),
                              ),
                            );
                            return null;
                          }

                          final path = results.files.single.path!;
                          final fileName = results.files.single.name;
                          debugPrint('path $path');
                          debugPrint('fileName $fileName');

                          database
                              .uploadFile(path, fileName)
                              .then((value) => debugPrint('DONE'));
                        },
                        child: Text('Pick File'),
                      ),

return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: Image.network(image['url']),
                                  ),
                                );

return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 300,
                                      width: 250,
                                      child: Image.network(
                                        snapshot.data!.elementAt(index),
                                        fit: BoxFit.cover,
                                      ),
                                    );
 */
