import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class NotesInsertPage extends StatefulWidget {
  const NotesInsertPage({super.key});
  @override
  _NotesInsertPageState createState() => _NotesInsertPageState();
}

class _NotesInsertPageState extends State<NotesInsertPage> {
  final _formKey = GlobalKey<FormState>();
  var title = TextEditingController();
  var content = TextEditingController();

  Future _onInsert(context) async {
    try {
      final insertResponse =
          await ApiService.insertNote(title: title.text, content: content.text);
      if (insertResponse.status == 1) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  loadBody() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: "Masukkan Judul",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false),
                  style: GoogleFonts.inter(
                    color: Colors.white,
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
                  decoration: InputDecoration(
                      hintText: 'Masukkan Konten',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white70),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Konten Wajib Diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "TAMBAHKAN",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          letterSpacing: 2, fontWeight: FontWeight.w600),
                    ),
                  ),
                  onPressed: () {
                    //validate
                    if (_formKey.currentState!.validate()) {
                      _onInsert(context);
                    } else {
                      print('tessss');
                    }
                  },
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambahkan Catatan',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: loadBody(),
    );
  }
}
