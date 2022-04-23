import 'package:flutter/material.dart';

import 'package:two/model/note.dart';
import 'package:two/db/db_provider.dart';
import 'package:two/screens/add_note.dart';
import 'package:two/screens/show_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/AddNote': (context) => AddNote(),
        '/ShowNote': (context) => ShowNote(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  getNotes() async {
    final notes = await DbProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomNotesBar(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, dynamic noteData) {
          if (noteData.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator(backgroundColor: Colors.black,));
          } else {
            if (noteData.data == null) {
              return const Center(child: Text("Add Notes...", style: TextStyle(fontSize: 16),));
            } else {
              return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: noteData.data.length,
                    itemBuilder: (context, index) {
                      int id = noteData.data[index]['id']!;
                      String title = noteData.data[index]['title'];
                      String body = noteData.data[index]['body'];
                      String creation_date = noteData.data[index]['creation_date'];
                      int isDone = noteData.data[index]['isDone'];
                      return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/ShowNote", arguments: Note(id: id, title: title, body: body, creation_date: DateTime.parse(creation_date),isDone: isDone));
                            },
                            leading: const Icon(Icons.comment),
                            title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,)),
                            subtitle: Text(body),
                            trailing: isDone == 1 ? Icon(Icons.check_circle_outline, color: Colors.green,) : null,
                          )
                      );
                    },
                  )
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent.withOpacity(0.75),
        elevation: 0,
        mini: false,
        onPressed: () {
          Navigator.pushNamed(context, "/AddNote");
        },
        child: Text("+", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),),
      ),
    );
  }
}

Widget CustomNotesBar() {
  return Padding(
      padding: EdgeInsets.only(top: 10, left: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("My notes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              )
          ),
        ],
      )
  );
}