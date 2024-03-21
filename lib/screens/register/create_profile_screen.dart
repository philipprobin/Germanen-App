import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:germanenapp/models/user_model.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/home_page.dart';
import 'package:germanenapp/screens/users/user_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/submit_button.dart';
import '../../widgets/text_field_widget.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen(this._userModel, this.displayName, {Key? key})
      : super(key: key);
  final String displayName;
  final UserModel? _userModel;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _status = 'N/A';
  List<String> _statusList = ['N/A', 'aF', 'aB', 'aH', 'aM', 'BiE'];

  String _activeSince = 'N/A';
  List<String> _activeSinceList = [
    'WiSe 1940',
    'SoSe 1941',
    'WiSe 1941',
    'SoSe 1942',
    'WiSe 1942',
    'SoSe 1943',
    'WiSe 1943',
    'SoSe 1944',
    'WiSe 1944',
    'SoSe 1945',
    'WiSe 1945',
    'SoSe 1946',
    'WiSe 1946',
    'SoSe 1947',
    'WiSe 1947',
    'SoSe 1948',
    'WiSe 1948',
    'SoSe 1949',
    'WiSe 1949',
    'SoSe 1950',
    'WiSe 1950',
    'SoSe 1951',
    'WiSe 1951',
    'SoSe 1952',
    'WiSe 1952',
    'SoSe 1953',
    'WiSe 1953',
    'SoSe 1954',
    'WiSe 1954',
    'SoSe 1955',
    'WiSe 1955',
    'SoSe 1956',
    'WiSe 1956',
    'SoSe 1957',
    'WiSe 1957',
    'SoSe 1958',
    'WiSe 1958',
    'SoSe 1959',
    'WiSe 1959',
    'SoSe 1960',
    'WiSe 1960',
    'SoSe 1961',
    'WiSe 1961',
    'SoSe 1962',
    'WiSe 1962',
    'SoSe 1963',
    'WiSe 1963',
    'SoSe 1964',
    'WiSe 1964',
    'SoSe 1965',
    'WiSe 1965',
    'SoSe 1966',
    'WiSe 1966',
    'SoSe 1967',
    'WiSe 1967',
    'SoSe 1968',
    'WiSe 1968',
    'SoSe 1969',
    'WiSe 1969',
    'SoSe 1970',
    'WiSe 1970',
    'SoSe 1971',
    'WiSe 1971',
    'SoSe 1972',
    'WiSe 1972',
    'SoSe 1973',
    'WiSe 1973',
    'SoSe 1974',
    'WiSe 1974',
    'SoSe 1975',
    'WiSe 1975',
    'SoSe 1976',
    'WiSe 1976',
    'SoSe 1977',
    'WiSe 1977',
    'SoSe 1978',
    'WiSe 1978',
    'SoSe 1979',
    'WiSe 1979',
    'SoSe 1980',
    'WiSe 1980',
    'SoSe 1981',
    'WiSe 1981',
    'SoSe 1982',
    'WiSe 1982',
    'SoSe 1983',
    'WiSe 1983',
    'SoSe 1984',
    'WiSe 1984',
    'SoSe 1985',
    'WiSe 1985',
    'SoSe 1986',
    'WiSe 1986',
    'SoSe 1987',
    'WiSe 1987',
    'SoSe 1988',
    'WiSe 1988',
    'SoSe 1989',
    'WiSe 1989',
    'SoSe 1990',
    'WiSe 1990',
    'SoSe 1991',
    'WiSe 1991',
    'SoSe 1992',
    'WiSe 1992',
    'SoSe 1993',
    'WiSe 1993',
    'SoSe 1994',
    'WiSe 1994',
    'SoSe 1995',
    'WiSe 1995',
    'SoSe 1996',
    'WiSe 1996',
    'SoSe 1997',
    'WiSe 1997',
    'SoSe 1998',
    'WiSe 1998',
    'SoSe 1999',
    'WiSe 1999',
    'SoSe 2000',
    'WiSe 2000',
    'SoSe 2001',
    'WiSe 2001',
    'SoSe 2002',
    'WiSe 2002',
    'SoSe 2003',
    'WiSe 2003',
    'SoSe 2004',
    'WiSe 2004',
    'SoSe 2005',
    'WiSe 2005',
    'SoSe 2006',
    'WiSe 2006',
    'SoSe 2007',
    'WiSe 2007',
    'SoSe 2008',
    'WiSe 2008',
    'SoSe 2009',
    'WiSe 2009',
    'SoSe 2010',
    'WiSe 2010',
    'SoSe 2011',
    'WiSe 2011',
    'SoSe 2012',
    'WiSe 2012',
    'SoSe 2013',
    'WiSe 2013',
    'SoSe 2014',
    'WiSe 2014',
    'SoSe 2015',
    'WiSe 2015',
    'SoSe 2016',
    'WiSe 2016',
    'SoSe 2017',
    'WiSe 2017',
    'SoSe 2018',
    'WiSe 2018',
    'SoSe 2019',
    'WiSe 2019',
    'SoSe 2020',
    'WiSe 2020',
    'SoSe 2021',
    'WiSe 2021',
    'SoSe 2022',
    'WiSe 2022',
    'SoSe 2023',
    'WiSe 2023',
    'SoSe 2024',
    'WiSe 2024',
    'SoSe 2025',
    'WiSe 2025',
    'SoSe 2026',
    'WiSe 2026',
    'SoSe 2027',
    'WiSe 2027',
    'SoSe 2028',
    'WiSe 2028',
    'SoSe 2029',
    'WiSe 2029',
    'SoSe 2030',
    'WiSe 2030',
    'N/A'
  ];
  List<String> _hobbys = [];

  late File _profilePic;

  final _mayorController = TextEditingController();
  final _jobController = TextEditingController();
  final _locationController = TextEditingController();

  var loading = false;
  bool _imageSelected = false;
  bool _imageChanged = false;

  @override
  void initState() {
    if (widget._userModel != null) {
      //is there already an image of the user?
      if (widget._userModel?.image != "") {
        _imageSelected = true;
      }
      UserModel user = widget._userModel!;
      _activeSince = user.activeSince;
      _status = user.status;
      _jobController.text = user.job;
      _mayorController.text = user.mayor;
      _locationController.text = user.location;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 32.0,
                      ),
                      child: Container(
                        child: Stack(
                            alignment: Alignment.bottomRight,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: _imageSelected == true
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: (widget._userModel?.image != "" && !_imageChanged)
                                            ? Image.network(
                                                widget._userModel?.image,
                                                width: 152,
                                                height: 152,
                                                fit: BoxFit.cover,
                                                alignment:
                                                    FractionalOffset.center,
                                              )
                                            : Image.file(
                                                _profilePic,
                                                width: 152,
                                                height: 152,
                                                fit: BoxFit.cover,
                                                alignment:
                                                    FractionalOffset.center,
                                              ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(children: <Widget>[
                                          SizedBox(
                                            height: 120,
                                            width: 120,
                                            child: Image.asset(
                                              "assets/Germanen-Zirkel.png",
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.3),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ]),
                                      ),
                              ),
                              PhysicalModel(
                                color: Colors.red,
                                elevation: 8,
                                shadowColor: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: TextButton(
                                    child: Icon(
                                      _imageSelected ? Icons.delete : Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      _imageChanged = true;
                                      if (_imageSelected) {
                                        setState(() {
                                          _imageSelected = false;
                                        });
                                      } else {
                                        await selectImage();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        //color: Color(0x80121212),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonFormField(
                                hint: Text("Aktiv seit"),
                                isExpanded: false,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.date_range_rounded),
                                  border: const OutlineInputBorder(),
                                ),
                                value: widget._userModel != null
                                    ? widget._userModel!.activeSince.toString()
                                    : _activeSince,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _activeSince = newValue!;
                                  });
                                },
                                items: _activeSinceList.reversed
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonFormField(
                                hint: Text("Status"),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.workspace_premium),
                                  border: const OutlineInputBorder(),
                                ),
                                value: widget._userModel != null
                                    ? widget._userModel!.status.toString()
                                    : _status,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _status = newValue!;
                                  });
                                },
                                items: _statusList
                                    .map<DropdownMenuItem<String>>(
                                        (String value2) {
                                  return DropdownMenuItem<String>(
                                    value: value2,
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        value2,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    TextFieldWidget(
                      label: 'Studienfach',
                      controller: _mayorController,
                      icon: Icon(Icons.interests),
                      validator: null,
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Beruf',
                      controller: _jobController,
                      icon: Icon(Icons.work),
                      validator: null,
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Wohnsitz',
                      controller: _locationController,
                      icon: Icon(Icons.location_on),
                      validator: null,
                      inputAction: TextInputAction.done,
                      isPasswordField: false,
                    ),
                    if (loading) ...[
                      const Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                    if (!loading) ...[
                      SubmitButton(
                        onPressed: () {
                          _createProfile();
                        },
                        text: 'Speichern',
                        padding: 16,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _createProfile() async {
    DocumentReference document =
        FirebaseFirestore.instance.collection('users').doc(widget.displayName);

    setState(() {
      loading = true;
    });
    try {
      if (!_imageChanged && widget._userModel == null) {
        await document.update({
          'image': "",
        });
      }
      //update user entry
      await document.update({
        'hobbys': (_hobbys),
        'status': Database.encrypt(_status),
        'activeSince': Database.encrypt(_activeSince),
        'mayor': Database.encrypt(_mayorController.text.trim()),
        'job': Database.encrypt(_jobController.text.trim()),
        'location': Database.encrypt(_locationController.text.trim()),
      });

      //upload profile pic
      if (_imageChanged) {
        List<File> fileList = [];
        if (_imageSelected) {
          fileList.add(_profilePic);
        } else {
          _profilePic = await getImageFileFromAssets("Germanen-Zirkel.png");
        }
        await Database.uploadFilesSetPaths(
            widget.displayName, "profile_pictures", document, fileList);
      } else {
        /*List<File> fileList = [];
        fileList.add(await getImageFileFromAssets("Germanen-Zirkel.png"));
        Database.uploadFilesSetPaths(widget.displayName, "profile_pictures", document, fileList);*/
      }

      //fragment pops
      Timer(Duration(seconds: 2), () {
        if (widget._userModel != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserProfilePage(widget._userModel?.userId)));
        } else {
          Navigator.pop(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('createProfile exception $e');
      setState(() {
        loading = false;
      });
    }
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> selectImage() async {
    final XFile? selectedImage = await imagePicker.pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      _imageChanged = true;
      _profilePic = File(selectedImage.path);
      setState(() {
        _imageSelected = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Datei ausgewählt.'),
        ),
      );
      setState(() {
        _imageSelected = false;
      });
    }
  }

  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
