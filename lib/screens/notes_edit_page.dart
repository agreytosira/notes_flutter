import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../services/api_service.dart';

// ignore: must_be_immutable
class NotesEditPage extends StatefulWidget {
  NotesEditPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _NotesEditPageState createState() => _NotesEditPageState();
}

class _NotesEditPageState extends State<NotesEditPage> {
  final _formKey = GlobalKey<FormState>();
  Notes note = Notes.fromJson({});

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

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
            content: const Text(
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
            content: const Text(
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

  Widget loadBody() {
    if (note.isNotEmpty()) {
      return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dibuat pada tanggal ${note.date}'),
              TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: "Masukkan Judul",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  filled: false,
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
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  filled: false,
                ),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _onUpdate(context);
                  } else {
                    print('tessss');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    "SIMPAN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 2, fontWeight: FontWeight.w600),
                  ),
                ),
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
        title: const Text('Ubah Catatan'),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Konfirmasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        'Apakah Anda yakin ingin menghapus data ini ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => _onDelete(context),
                          child: const Text('Ya, Hapus'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          child: const Text('Batal'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: loadBody(),
    );
  }
}
