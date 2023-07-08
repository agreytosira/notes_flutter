class Notes {
  final String id;
  final String title;
  final String content;
  final String date;

  Notes({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      return Notes(
        id: '',
        title: '',
        content: '',
        date: '',
      );
    } else {
      return Notes(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        date: json['date'],
      );
    }
  }

  bool isNotEmpty() {
    return id.isNotEmpty || id == '';
  }
}
