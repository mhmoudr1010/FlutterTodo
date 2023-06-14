import 'package:flutter/material.dart';
import 'package:todo_app/todo_screen.dart';
import 'data/todo.dart';
import 'bloc/todo_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TodoBloc todoBloc;
  List<Todo>? todos;

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo(name: '', description: '', completeBy: '', priority: 0);
    todos = todoBloc.todoList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Container(
        child: StreamBuilder<List<Todo>>(
          stream: todoBloc.todos,
          initialData: todos,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: (snapshot.hasData) ? snapshot.data?.length : 0,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(snapshot.data![index].id.toString()),
                  onDismissed: (_) =>
                      todoBloc.todoDeleteSink.add(snapshot.data![index]),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).highlightColor,
                      child: Text("${snapshot.data![index].priority}"),
                    ),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].description),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoScreen(
                                  todo: snapshot.data![index], isNew: false),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit)),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoScreen(todo: todo, isNew: true),
              ));
        },
      ),
    );
  }

  /*Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();

    await db.insertTodo(Todo(
      name: 'Call Donald',
      description: 'And tell him about Daisy',
      completeBy: '02/02/2023',
      priority: 1,
    ));
    await db.insertTodo(Todo(
      name: 'Buy sugar',
      description: '1 Kg',
      completeBy: '03/02/2023',
      priority: 2,
    ));
    await db.insertTodo(Todo(
      name: 'Go runing',
      description: '12:00 with neighbours',
      completeBy: '02/02/2023',
      priority: 3,
    ));

    todos = await db.getTodos();

    debugPrint('First insert');
    for (var todo in todos) {
      debugPrint(todo.name);
    }

    if (todos.isNotEmpty) {
      Todo todoToUpdate = todos[0];
      todoToUpdate.name = 'Call Tim';
      await db.updateTodo(todoToUpdate);
    }

    if (todos.isNotEmpty) {
      Todo todoToDelete = todos[1];
      await db.deleteTodo(todoToDelete);
    }

    debugPrint('After Updates');
    todos = await db.getTodos();
    for (var todo in todos) {
      debugPrint(todo.name);
    }
  }*/

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }
}
