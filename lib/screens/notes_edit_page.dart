import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../services/api_service.dart';

// ignore: must_be_immutable
class NotesEditPage extends StatefulWidget {
  NotesEditPage({super.key, required this.id});
  String id;
  @override
  _NotesEditPageState createState() => _NotesEditPageState();
}

class _NotesEditPageState extends State<NotesEditPage> {
  final _formKey = GlobalKey<FormState>();
  Notes note = Notes.fromJson({});

  var title = TextEditingController();
  var content = TextEditingController();

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
        title = TextEditingController(text: note.title);
        content = TextEditingController(text: note.content);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future _onUpdate(context) async {
    try {
      final updateNote = await ApiService.updateNote(
          id: widget.id, title: title.text, content: content.text);
      if (updateNote.status == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Data berhasil disimpan',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onDelete(context) async {
    try {
      final updateNote = await ApiService.deleteNote(id: widget.id);
      if (updateNote.status == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Data berhasil dihapus',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  loadBody() {
    if (note.isNotEmpty()) {
      return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dibuat tanggal ${note.date}'),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  hintText: "Masukkan Judul",
                  border: InputBorder.none, // Menghilangkan border
                  contentPadding: EdgeInsets.zero, // Menghilangkan padding
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Judul Wajib Diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: content,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Masukkan Konten',
                    border: InputBorder.none, // Menghilangkan border
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Konten Wajib Diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    "SIMPAN",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, letterSpacing: 2),
                  ),
                ),
                onPressed: () {
                  //validate
                  if (_formKey.currentState!.validate()) {
                    //send data to database with this method
                    _onUpdate(context);
                  } else {
                    print('tessss');
                  }
                },
              )
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          "Data Tidak Ditemukan",
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
        title: const Text('Edit Catatan'),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //show dialog to confirm delete data
                      return AlertDialog(
                        content: const Text(
                            'Apakah Anda yakin ingin menghapus data ini ?'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Icon(Icons.check_circle),
                            onPressed: () => _onDelete(context),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey), // Ubah warna tombol di sini
                            ),
                            child: const Icon(Icons.cancel),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete)),
          )
        ],
      ),
      body: loadBody(),
    );
  }
}
