import 'package:flutter/material.dart';

import 'package:two/model/note.dart';
import 'package:two/db/db_provider.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  String title = '';
  String body = '';
  DateTime? date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(Note note) {
    DbProvider.db.addNewNote(note);
  }

  String _title_hint = "Heading...";
  String _body_hint = "your note...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New note"),backgroundColor: Colors.amberAccent,),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: _title_hint,
              ),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              onChanged: (text) {setState(() {if(titleController.text.isNotEmpty) {_title_hint='Heading...';}});},
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _body_hint,
                ),
                onChanged: (text) {setState(() {if(bodyController.text.isNotEmpty) {_body_hint='your note...';}});},
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: bodyController.text.isNotEmpty && titleController.text.isNotEmpty ? FloatingActionButton.extended(
        elevation: 1,
        backgroundColor: Colors.amberAccent,
        onPressed: () {
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            date = DateTime.now();
          });
          Note note = Note(title: title, body: body, creation_date: date);
          addNote(note);
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        },
        label: Text("Save"),
      ) : FloatingActionButton.extended(
        backgroundColor: Colors.grey[350],
        elevation: 0,
        onPressed: (){
          setState(() {
            if (bodyController.text.isEmpty && titleController.text.isEmpty) {
              _body_hint = 'field can`t be empty';
              _title_hint = 'field can`t be empty';
            } else if (bodyController.text.isEmpty) {
              _body_hint = 'field can`t be empty';
            } else if (titleController.text.isEmpty) {
              _title_hint = 'field can`t be empty';
            }
            });
          },
        label: Text("Save"),),
    );
  }
}