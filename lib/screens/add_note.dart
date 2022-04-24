import 'package:flutter/material.dart';

import 'package:two/model/note.dart';
import 'package:two/db/db_provider.dart';

import 'package:two/model/notifications.dart';
import 'dart:math';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  String title = '';
  String body = '';
  DateTime? date;

  DateTime? newDate;

  int finalNotify = 0;
  TextEditingController notifyControllerH = TextEditingController();
  TextEditingController notifyControllerM = TextEditingController();
  TextEditingController notifyControllerS = TextEditingController();

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
            Row(children: [
              Text('Timer:   ', style: TextStyle(fontSize: 16.7, color: Colors.black54),),
              CustomField(notifyControllerH, 'h'),
              SizedBox(width: 10),
              CustomField(notifyControllerM, 'm'),
              SizedBox(width: 10),
              CustomField(notifyControllerS, 's'),
            ],
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
            date = DateTime.now().toLocal();

            if(notifyControllerH.text.isNotEmpty) {
              finalNotify += int.parse(notifyControllerH.text) * 3600;
            }
            if(notifyControllerM.text.isNotEmpty) {
              finalNotify += int.parse(notifyControllerM.text) * 60;
            }
            if(notifyControllerS.text.isNotEmpty) {
              finalNotify += int.parse(notifyControllerS.text);
            }

            if (notifyControllerH.text.isNotEmpty || notifyControllerM.text.isNotEmpty || notifyControllerS.text.isNotEmpty) {
              newDate = date!.add(Duration(hours: notifyControllerH.text.isNotEmpty ? int.parse(notifyControllerH.text) : 0, minutes: notifyControllerM.text.isNotEmpty ? int.parse(notifyControllerM.text) : 0, seconds: notifyControllerS.text.isNotEmpty ? int.parse(notifyControllerS.text) : 0,));
            }
          });
          Note note = Note(title: title, body: body, creation_date: newDate == null ? date : newDate);
          addNote(note);

          Random random = new Random();
          int randomNumber = random.nextInt(10000);
          
          finalNotify == 0 ? null : showNotification(randomNumber, finalNotify, title);
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

Widget CustomField(notifyController, textHint) {
  return Container(
    width: 50,
    height: 32,
    child: TextField(
      controller: notifyController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 10
        ),
        hintText: textHint,
      ),
    ),
  );
}