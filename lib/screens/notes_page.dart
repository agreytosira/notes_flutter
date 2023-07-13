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
  List<Notes> searchResults = []; // Ditambahkan untuk fungsionalitas pencarian

  final TextEditingController searchController =
      TextEditingController(); // Ditambahkan untuk mengendalikan teks pada TextField
  FocusNode searchFocusNode =
      FocusNode(); // Ditambahkan untuk mengendalikan fokus pada TextField

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
        searchResults =
            fetchedNotes; // Menginisialisasi hasil pencarian dengan semua catatan
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void searchNotes(String query) {
    final List<Notes> filteredNotes = notesList.where((note) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          contentLower.contains(searchLower);
    }).toList();

    setState(() {
      searchResults = filteredNotes;
    });
  }

  void unfocusSearchField() {
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }

  loadBody() {
    if (notesList.length > 0) {
      return GestureDetector(
        onTap:
            unfocusSearchField, // Menghilangkan fokus pada TextField saat pengguna mengetap area selain TextField
        child: Container(
          padding: EdgeInsets.all(16),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final note = searchResults[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesEditPage(
                        id: note.id,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Container(
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: searchController, // Menggunakan TextEditingController
              focusNode: searchFocusNode, // Menggunakan FocusNode
              onChanged: searchNotes,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Cari Catatan',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(child: Center(child: loadBody())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesInsertPage()),
          );
        },
      ),
    );
  }
}
