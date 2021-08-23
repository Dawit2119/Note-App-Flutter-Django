import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/create_or_update_note.dart';
import 'package:frontend/note.dart';
import 'package:frontend/widgets/customButton.dart';
import 'package:http/http.dart' as http;

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  void _retrieveNotes() async {
    var response = await http.get(Uri.parse('http://localhost:8000/api/notes'));
    if (response.statusCode == 200) {
      List allNotes = jsonDecode(response.body);
      notes = allNotes.map((e) {
        return Note.fromJson(e);
      }).toList();
      setState(() {});
    } else {
      print('Failed! status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    _retrieveNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Django-Flutter-Note-App'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All My Notes",
                style: TextStyle(fontSize: 40, color: Colors.deepPurple),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.deepOrange,
                onPressed: _retrieveNotes,
              )
            ],
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      title: Text(notes[index].body,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              decoration: TextDecoration.underline)),
                      children: [
                        Text('Created at:',style:TextStyle(color:Colors.lightGreenAccent,fontSize:15)
                        ),
                        Text(notes[index].created!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: CustomButton(
                                    lableText: "Update",
                                    onpressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreateOrUpdateNote(
                                            note: Note(
                                                id: notes[index].id,
                                                body: notes[index].body),
                                            isUpdate: true,
                                          ),
                                        ),
                                      );
                                    },
                                    color: Colors.yellowAccent)),
                            Expanded(
                                child: CustomButton(
                                    lableText: "Delete",
                                    onpressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text(
                                                'Info',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 15),
                                              ),
                                              content: Text('Are You Shure?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.greenAccent,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    var response =
                                                        await http.delete(
                                                      Uri.parse(
                                                          'http://localhost:8000/api/notes/${notes[index].id}/delete/'),
                                                    );
                                                    print(response.statusCode);
                                                    if (response.statusCode ==
                                                        204) {
                                                      _retrieveNotes();
                                                      Navigator.pop(
                                                          context, 'Yes');
                                                    }
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                ),
                                              ],
                                            )),
                                    color: Colors.redAccent)),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateOrUpdateNote()));
        },
      ),
    );
  }
}
