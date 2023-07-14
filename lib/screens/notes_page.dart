import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

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
  List<Notes> searchResults = [];

  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

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
        searchResults = fetchedNotes;
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
        onTap: unfocusSearchField,
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
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.date,
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          note.title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.content,
                          style: GoogleFonts.inter(
                            color: Colors.white70,
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
            color: Colors.white,
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
        title: Text(
          'NoteKeeper',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Tentang NoteKeeper',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'NoteKeeper adalah sebuah aplikasi catatan sederhana yang dibuat menggunakan Flutter. Aplikasi ini dapat menambah, mengubah, dan menghapus catatan. NoteKeeper dibuat oleh Kelompok 1 untuk memenuhi tugas mata kuliah Pemrograman Mobile.\n\nAnggota Kelompok 1:\nAgrey Tosira (21112022)\nAisyah Dean Maharani (21112050)\nVuspa Fitri Yusni (21112052)',
                        style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                      ),
                      actions: [
                        Container(
                            margin: EdgeInsets.only(
                                left: 16, bottom: 16, right: 16),
                            child: ElevatedButton(
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: const Text(
                                  "OK",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: searchNotes,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.white70), // Atur warna border menjadi putih
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors
                          .white70), // Atur warna border sebelum fokus menjadi putih
                ),
                labelText: 'Cari Catatan',
                labelStyle: GoogleFonts.inter(color: Colors.white),
                suffixIcon: Icon(
                  Icons.search,
                  color:
                      Colors.white, // Atur warna ikon pada suffix menjadi putih
                ),
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
