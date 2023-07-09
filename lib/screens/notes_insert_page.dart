import 'package:flutter/material.dart';
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
          children: [
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                  hintText: "Masukkan Judul",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.white,
                  filled: true),
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
              decoration: InputDecoration(
                  hintText: 'Masukkan Konten',
                  border: InputBorder.none,
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
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      "TAMBAHKAN",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, letterSpacing: 2),
                    ),
                  ),
                  onPressed: () {
                    //validate
                    if (_formKey.currentState!.validate()) {
                      //send data to database with this method
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
        title: const Text('Tambahkan Catatan'),
      ),
      body: loadBody(),
    );
  }
}
