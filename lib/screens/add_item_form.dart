import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/validators/Database.dart';
import 'package:germanenapp/widgets/app_toolbar.dart';

import '../custom_form_field.dart';

class AddItemForm extends StatefulWidget{

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

  bool _isProcessing = false;

  String getTitle= "";
  String getDescription = "";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
             child: Container(
               height: MediaQuery.of(context).size.height,
               color: Colors.white,
                child: Form(
                    key: _addItemFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24,),
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
                              SizedBox(height: 24,),
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
                              _isProcessing ?
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                              ):Container(
                                  padding: const EdgeInsets.all(16.0),
                                  width: double.maxFinite,
                                  child:ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.red),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                        )
                                    ),
                                    onPressed: () async{
                                      widget.titleFocusNode.unfocus();
                                      widget.descriptionFocusNode.unfocus();

                                      if(_addItemFormKey.currentState!.validate()){
                                        setState(() {
                                          _isProcessing = true;
                                        });
                                        await Database.addItem(title: getTitle, description: getDescription);

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
                    )
                ),
             ),
          ),
        )
    );
  }
  String? _requiredTitleValidator(String? text){
    if(text==null|| text.trim().isEmpty){
      return 'Bitte gib einen Text ein.';
    }
    getTitle = text;
    return null;
  }
  String? _requiredDescriptionValidator(String? text){
    if(text==null|| text.trim().isEmpty){
      return 'Bitte gib einen Text ein.';
    }
    getDescription = text;
    return null;
  }

}
