import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:germanenapp/network/Database.dart';
//import 'package:open_file/open_file.dart';

import '../custom_form_field.dart';

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
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      CustomFormField(
                        textInputAction: TextInputAction.next,
                        controller: _titleController,
                        focusNode: widget.titleFocusNode,
                        keyboardType: TextInputType.text,
                        validator: _requiredTitleValidator,
                      ),
                      //descripton
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      CustomFormField(
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
                          files = (await pickFiles())!;
                          debugPrint('dateien $files');
                        },
                        child: Text('Pick File'),
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
                      /*
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: FutureBuilder(
                          ///loadImages
                          future: database.loadImages(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final Map<String, dynamic> image =
                                      snapshot.data![index];
                                  return Container(
                                    child: Card(
                                      child: Container(
                                        child: Center(
                                          child: Image.network(image['url']),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return Container();
                          },
                        ),
                      ),

                       */
                      _isProcessing
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(16.0),
                              width: double.maxFinite,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  widget.titleFocusNode.unfocus();
                                  widget.descriptionFocusNode.unfocus();

                                  if (_addItemFormKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      _isProcessing = true;
                                    });

                                    ///upload image

                                    await database.addItem(
                                        title: getTitle,
                                        description: getDescription,
                                        files: files


                                    );

                                    setState(() {
                                      _isProcessing = false;
                                    });
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  'Hinzufügen',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
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



  Future<List<File>?> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
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
/*
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
