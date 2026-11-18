import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/screens/add_todo_screen.dart';
import '../model/todo_model.dart';

class CommonContainer extends StatelessWidget {
  final double height;
  final bool isCompleted;
  final List<MapEntry<dynamic, TodoModel>> todos;
  final VoidCallback onTodosChanged;

  const CommonContainer({
    super.key,
    required this.height,
    required this.isCompleted,
    required this.todos,
    required this.onTodosChanged,
  });

  Future<void> _toggleTodo(dynamic key, TodoModel todo, bool value) async {
    final box = Hive.box('todos');
    final updatedTodo = todo.copyWith(isCompleted: value);
    await box.put(key, updatedTodo.toMap());

    onTodosChanged();
  }

  Future<void> _editTodo(BuildContext context, dynamic key) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoScreen(todoKey: key),
      ),
    );

    onTodosChanged();
  }

  Future<void> _deleteTodo(BuildContext context, dynamic key) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final box = Hive.box('todos');
    await box.delete(key);

    onTodosChanged();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': Icons.person_outline,
        'bgColor': const Color(0xFFDBE6F6),
        'iconColor': const Color(0xFF2B5B9E),
      },
      {
        'icon': Icons.work_outline,
        'bgColor': const Color(0xFFFCE6C9),
        'iconColor': const Color(0xFFD98A2B),
      },
      {
        'icon': Icons.health_and_safety_outlined,
        'bgColor': const Color(0xFFD9EFE3),
        'iconColor': const Color(0xFF3A8F63),
      },
      {
        'icon': Icons.emoji_events_outlined,
        'bgColor': const Color(0xFFE7D9F6),
        'iconColor': const Color(0xFF6B3FA0),
      },
      {
        'icon': Icons.more_horiz_sharp,
        'bgColor': const Color(0xFFD6F0F8),
        'iconColor': const Color(0xFF2B8BA8),
      },
    ];

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xffE7DEFD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: todos.isEmpty
            ? Center(
          child: Text(
            'No tasks yet',
            style: GoogleFonts.dekko(fontSize: 18),
          ),
        )
            : ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: todos.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFDCD6EC),
          ),
          itemBuilder: (context, index) {
            final entry = todos[index];
            final todo = entry.value;
            final todoKey = entry.key;
            final category = categories[todo.categoryIndex];

            return Opacity(
              opacity: isCompleted ? 0.55 : 1.0,
              child: ListTile(
                onTap: () => _editTodo(context, todoKey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: category['bgColor'] as Color,
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['iconColor'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  todo.title,
                  style: GoogleFonts.dekko(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text(
                  todo.time,
                  style: GoogleFonts.dekko(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: todo.isCompleted,
                      activeColor: const Color(0xff4A3780),
                      onChanged: (value) {
                        if (value != null) {
                          _toggleTodo(todoKey, todo, value);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400]
                      ),
                      onPressed: () => _deleteTodo(context, todoKey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
