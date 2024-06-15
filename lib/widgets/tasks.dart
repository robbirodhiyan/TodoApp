import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todos/providers/todo_provider.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TextEditingController newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: newTaskController,
                  decoration: const InputDecoration(
                    labelText: "Ajouter une nouvelle tâche",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.amberAccent),
                  foregroundColor: MaterialStateProperty.all(Colors.purple),
                ),
                child: const Text("Ajouter"),
                onPressed: () {
                  Provider.of<TodoProvider>(context, listen: false)
                      .createTodo(newTaskController.text);
                  newTaskController.clear();
                },
              )
            ],
          ),
          FutureBuilder<void>(
            future: Provider.of<TodoProvider>(context, listen: false).getTodos(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Consumer<TodoProvider>(
                  builder: (ctx, todoProvider, child) {
                    if (todoProvider.todos.isEmpty) {
                      return child!;
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                            itemCount: todoProvider.todos.length,
                            itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ListTile(
                                tileColor: Colors.black12,
                                leading: Checkbox(
                                  value: todoProvider.todos[i].isExecuted,
                                  activeColor: Colors.purple,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      Provider.of<TodoProvider>(context, listen: false).updateTodo(
                                        todoProvider.todos[i].id!,
                                        {
                                          'is_executed': newValue ? 1 : 0,
                                        },
                                      );
                                    }
                                  },
                                ),
                                title: Text(todoProvider.todos[i].todoID),
                                subtitle: Text(todoProvider.todos[i].todoName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    Provider.of<TodoProvider>(context, listen: false)
                                      .deleteTodo(todoProvider.todos[i].id!);
                                  },
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: const SizedBox(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
