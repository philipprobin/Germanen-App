import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/content/take_photo.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../widgets/app_toolbar.dart';
//import 'package:open_file/open_file.dart';

List<CameraDescription>? cameras;

class AddContentPage extends StatefulWidget {
  @override
  _AddContentPageState createState() => _AddContentPageState();
}

class _AddContentPageState extends State<AddContentPage> {
  final _addItemFormKey = GlobalKey<FormState>();
  List<File> files = [];

  final Database database = Database();

  bool _isProcessing = false;
  bool _isLookingForFiles = false;

  String getTitle = "";
  String description = "";

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
      appBar: AppBar(
          title: AppToolbar(
        sectionName: 'Germanen-App',
      )),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _addItemFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: buildMaterialColor(Color(0xFAE2E2E2)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          //weg?
                          hintText: 'Was möchtest du sagen?',
                          border: InputBorder.none,
                        ),
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 15,
                        validator: _requiredDescriptionValidator,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      _isLookingForFiles
                          ? Expanded(
                              child: Container(
                                height: 50,
                              ),
                            )
                          : Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                                height: 50,
                                width: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: files.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.all(2),
                                      color: Colors.grey[800],
                                      child: Image.file(
                                        File(files[index].path.toString()),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        alignment: FractionalOffset.topCenter,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      //3 Buttons
                      Row(children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: TextButton(
                            child: Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              _onTakePhotoPressed();
                            },
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          child: TextButton(
                            child: Icon(
                              Icons.photo,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              files += (await selectImages())!;
                            },
                          ),
                        ),
                        //send Button
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                child: TextButton(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    _onSendPressed();
                                  },
                                ),
                              ),
                      ])
                    ]),
                  ],
                ),
              ),
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

  String? _requiredDescriptionValidator(String? text) {
    if (files.isNotEmpty) {
      description = text!;
      return null;
    }
    if (text == null || text.trim().isEmpty) {
      return 'Bitte gib einen Text ein.';
    }
    description = text;
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

  Future<void> _onSendPressed() async {
    if (_addItemFormKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      //upload image
      debugPrint("description is $description");
      await database.addItem(description: description, files: files);

      setState(() {
        _isProcessing = false;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _onTakePhotoPressed() async {
    final String? imagePath = await Navigator.of(context).push(
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
  }
}
