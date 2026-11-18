class TodoModel {
  final String title;
  final int categoryIndex;
  final DateTime date;
  final String time;
  final String note;
  final bool isCompleted;

  TodoModel({
    required this.title,
    required this.categoryIndex,
    required this.date,
    required this.time,
    required this.note,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categoryIndex': categoryIndex,
      'date': date.toIso8601String(),
      'time': time,
      'note': note,
      'isCompleted': isCompleted,
    };
  }

  factory TodoModel.fromMap(Map<dynamic, dynamic> map) {
    return TodoModel(
      title: map['title'] as String,
      categoryIndex: map['categoryIndex'] as int,
      date: DateTime.parse(map['date'] as String),
      time: map['time'] as String,
      note: map['note'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  TodoModel copyWith({
    String? title,
    int? categoryIndex,
    DateTime? date,
    String? time,
    String? note,
    bool? isCompleted,
  }) {
    return TodoModel(
      title: title ?? this.title,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
