import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dibuat pada tanggal ${note.date}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                      )),
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: "Masukkan Judul",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                    ),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
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
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                    ),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Konten Wajib Diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                  child: Text(
                    "SIMPAN",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        letterSpacing: 2, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          "Data Tidak Ditemukan",
          style: GoogleFonts.inter(
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
          'Ubah Catatan',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Konfirmasi',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Apakah Anda yakin ingin menghapus data ini ?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => _onDelete(context),
                          child: Text(
                            'Ya, Hapus',
                            style: GoogleFonts.inter(),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.inter(),
                          ),
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
