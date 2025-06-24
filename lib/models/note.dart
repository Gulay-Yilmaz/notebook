class Note {
  final String content;
  final String category;

  Note({required this.content, required this.category});

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'category': category,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      content: map['content'],
      category: map['category'],
    );
  }
}
