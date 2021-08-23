class Note {
  int id;
  String? created;
  String body;
  Note({required this.id,this.created,required this.body});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(id: json['id'],created: json['created'], body: json['body']);
  }
  Map<String, dynamic> toJson() {
    return {"id": id, 'body': body,"created":created};
  }
}
