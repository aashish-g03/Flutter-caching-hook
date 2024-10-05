import 'package:caching_hook/service/request_service.dart';
import 'package:flutter/material.dart';
import 'model/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RequestCacheService<Todo> service = RequestCacheService<Todo>(
    fromJson: (json) => Todo.fromJson(json),
    toJson: (todo) => todo.toJson(),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Caching Demo',
      home: TodoPage(service: service),
    );
  }
}

class TodoPage extends StatefulWidget {
  final RequestCacheService<Todo> service;

  const TodoPage({super.key, required this.service});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late Stream<Todo> _todoStream;
  final String url = 'https://jsonplaceholder.typicode.com/todos/1';

  @override
  void initState() {
    super.initState();
    _todoStream = widget.service.fetchData(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Caching Demo'),
      ),
      body: StreamBuilder<Todo>(
        stream: _todoStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final todo = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Todo Item',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text('Title: ${todo.title}'),
                Text('Completed: ${todo.completed}'),
                Text('Source: ${todo.source}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
