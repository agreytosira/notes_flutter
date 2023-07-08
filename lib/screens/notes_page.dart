import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/notes.dart';
import '../services/api_service.dart';
import 'notes_edit_page.dart';
import 'notes_insert_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Notes> notesList = [];

  // final _lightColors = [
  //   Colors.amber.shade300,
  //   Colors.lightGreen.shade300,
  //   Colors.lightBlue.shade300,
  //   Colors.orange.shade300,
  //   Colors.pinkAccent.shade100,
  //   Colors.tealAccent.shade100
  // ];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final fetchedNotes = await ApiService.fetchNotes();
      setState(() {
        notesList = fetchedNotes;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  loadBody() {
    if (notesList.length > 0) {
      return Container(
        padding: EdgeInsets.all(16),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          itemCount: notesList.length,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesEditPage(
                              id: note.id,
                            )));
              },
              child: Card(
                // color: _lightColors[index % _lightColors.length],
                child: Container(
                  //make 2 different height
                  // constraints: BoxConstraints(minHeight: (index % 2 + 1) * 85),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.date,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        note.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          "Data Tidak Tersedia",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotesV2'),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(child: loadBody()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              //routing into add page
              MaterialPageRoute(builder: (context) => NotesInsertPage()));
        },
      ),
    );
  }
}
