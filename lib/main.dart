import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/todo_provider.dart';
import 'package:todos/widgets/tasks.dart';


void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TodoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simple tasks App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const HomePage(title: 'Todo app'),
      )
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: const TasksWidget(),
    );
  }
}
