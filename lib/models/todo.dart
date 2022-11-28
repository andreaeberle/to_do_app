class ToDo {
  String? id;
  String todoText;
  String deadline;
  bool isDone;
  bool hasDeadline;

  ToDo({
    required this.id,
    required this.todoText,
    required this.deadline,
    this.isDone = false,
    this.hasDeadline = false,
  });

  static List<ToDo> todoList() {
    return [];
  }

  // Converts a map of ToDo object info into a ToDo object
  ToDo.fromMap(Map map)
      : id = map["id"],
        todoText = map["todoText"],
        deadline = map["deadline"],
        isDone = map["isDone"],
        hasDeadline = map["hasDeadline"];

  // Converts ToDo object into a map of ToDo object info
  Map toMap() {
    return {
      "id": id,
      "todoText": todoText,
      "deadline": deadline,
      "isDone": isDone,
      "hasDeadline": hasDeadline,
    };
  }
}
