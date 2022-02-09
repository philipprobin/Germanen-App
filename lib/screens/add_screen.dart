import 'package:flutter/material.dart';
import 'package:germanenapp/screens/add_item_form.dart';
import 'package:germanenapp/widgets/app_toolbar.dart';

class AddScreen extends StatelessWidget{
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
            elevation: 0,
            title: AppToolbar(
              sectionName: 'Germanen-App',
            )
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: AddItemForm(
              titleFocusNode: _titleFocusNode,
              descriptionFocusNode: _descriptionFocusNode
            ),
          ),
        ),
      ),
    );
  }
}