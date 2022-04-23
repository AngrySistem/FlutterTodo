class Note {
  int? id;
  String title;
  String body;
  DateTime? creation_date;
  int isDone;

  Note({this.id, required this.title, required this.body, this.creation_date, this.isDone = 0});

  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "title": title,
      "body": body,
      "creation_date": creation_date.toString(),
      "isDone": isDone,
    });
  }
}