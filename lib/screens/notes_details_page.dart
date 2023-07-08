import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../services/api_service.dart';

class NotesDetailsPage extends StatefulWidget {
  final String id;

  NotesDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  _NotesDetailsPageState createState() => _NotesDetailsPageState();
}

class _NotesDetailsPageState extends State<NotesDetailsPage> {
  Notes note = Notes.fromJson({});

  @override
  void initState() {
    super.initState();
    fetchNote();
  }

  Future<void> fetchNote() async {
    try {
      final fetchedNote = await ApiService.fetchOneNote(id: widget.id);
      setState(() {
        note = fetchedNote;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: note.isNotEmpty()
          ? Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Judul',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Konten',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    note.content,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
                "Data Tidak Ditemukan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
