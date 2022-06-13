import 'package:flutter/material.dart';

import 'package:two/model/notifications.dart';

import 'package:two/db/db_provider.dart';
import 'package:two/model/note.dart';

class ShowNote extends StatefulWidget {
  ShowNote({Key? key}) : super(key: key);

  @override
  _ShowNoteState createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  editNote(Note note) {
    DbProvider.db.editNote(note);
  }

  @override
  Widget build(BuildContext context) {
    final Note note = ModalRoute.of(context)?.settings.arguments as Note;

    titleController.text = note.title;
    bodyController.text = note.body;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.hovered,
        MaterialState.focused,
      };
      return Colors.white;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Note",),
        backgroundColor: Colors.amberAccent,
        elevation: 2,
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 3,),
            child: Row(
              children: [
                Text("Done:", style: TextStyle(fontSize: 17),),
                Checkbox(
                  activeColor: Colors.amberAccent,
                  checkColor: Colors.amberAccent,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  value: note.isDone == 0 ? false : true,
                  onChanged: (value) {
                    setState(() {
                      note.isDone = value! == false ? 0 : 1;
                      note.title = titleController.text;
                      note.body = bodyController.text;
                    });
                  },
                ),
                VerticalDivider(indent: 5, endIndent: 5, thickness: 1,)
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (bodyController.text.isEmpty || titleController.text.isEmpty) {
                note.title = titleController.text;
                note.body = bodyController.text;
              } else {
              setState(() {
                note.title = titleController.text;
                note.body = bodyController.text;
              });
              Note editedNote = Note(id: note.id, title: note.title, body: note.body, creation_date: note.creation_date, isDone: note.isDone, notifyId: note.notifyId);
              editNote(editedNote);
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
              }
            },
            icon: const Icon(Icons.check),
          ),
          IconButton(
              onPressed: () {
                if (note.notifyId! < 31000) {
                  cancelNotification(note.notifyId);
                }
                DbProvider.db.deleteNote(note.id!);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              icon: const Icon(Icons.delete),
          )
        ],),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Heading...",
              ),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "your note...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

