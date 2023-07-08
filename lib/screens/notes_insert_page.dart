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
            const Text(
              'Judul',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                  hintText: "Masukkan Judul",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Judul Wajib Diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Konten',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: content,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Masukkan Konten',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Konten Wajib Diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
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
        title: const Text('Notes'),
      ),
      body: loadBody(),
    );
  }
}
