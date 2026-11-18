import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/screens/add_todo_screen.dart';
import 'package:todo_app/widget/common_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MapEntry<dynamic, TodoModel>> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    final box = Hive.box('todos');

    final loadedTodos = box.keys.map((key) {
      final todo = TodoModel.fromMap(
        Map<dynamic, dynamic>.from(box.get(key)),
      );

      return MapEntry(key, todo);
    }).toList();

    if (!mounted) return;

    setState(() {
      todos = loadedTodos;
    });
  }

  Future<void> _addTodo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTodoScreen(),
      ),
    );

    _loadTodos();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {

    final pendingTodos = todos.where((entry) => !entry.value.isCompleted).toList();
    final completedTodos = todos.where((entry) => entry.value.isCompleted).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: const Color(0xff512EA4),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    _getFormattedDate(),
                    style: GoogleFonts.dekko(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'My To-Do List',
                    style: GoogleFonts.dekko(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 160),

                  CommonContainer(
                    height: 350,
                    isCompleted: false,
                    todos: pendingTodos,
                    onTodosChanged: _loadTodos,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Completed',
                    style: GoogleFonts.dekko(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  CommonContainer(
                    height: 240,
                    isCompleted: true,
                    todos: completedTodos,
                    onTodosChanged: _loadTodos,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff512EA4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              onPressed: _addTodo,
              child: Text(
                'Add New Task',
                style: GoogleFonts.dekko(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
