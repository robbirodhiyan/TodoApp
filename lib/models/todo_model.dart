class TodoItem {
  String? id;
  dynamic todoID;
  String todoName = '';
  bool isExecuted;
  DateTime? createdAt;
  DateTime? updatedAt;

  TodoItem({
    this.id,
    this.todoID,
    required this.todoName,
    required this.isExecuted,
    this.createdAt,
    this.updatedAt,
  });
}
