import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../model/todo_model.dart';


class AddTodoScreen extends StatefulWidget {

  final dynamic todoKey;

  const AddTodoScreen({
    super.key,
    this.todoKey,
  });

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  bool _isCompleted = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _selectedCategoryIndex = 0;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 16, minute: 30);

  final List<Map<String, dynamic>> _categories = [
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

  TimeOfDay _parseTime(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (parts.length > 1) {
      if (parts[1] == 'PM' && hour != 12) {
        hour += 12;
      } else if (parts[1] == 'AM' && hour == 12) {
        hour = 0;
      }
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void initState() {
    super.initState();

    if (widget.todoKey != null) {
      final box = Hive.box('todos');
      final savedTodo = TodoModel.fromMap(
        Map<dynamic, dynamic>.from(box.get(widget.todoKey)),
      );

      _titleController.text = savedTodo.title;
      _notesController.text = savedTodo.note;
      _selectedCategoryIndex = savedTodo.categoryIndex;
      _selectedDate = savedTodo.date;
      _selectedTime = _parseTime(savedTodo.time);
      _isCompleted = savedTodo.isCompleted;
    }
  }


  Future<void> _saveTodo() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
        ),
      );
      return;
    }

    final todo = TodoModel(
      title: _titleController.text.trim(),
      categoryIndex: _selectedCategoryIndex,
      date: _selectedDate,
      time: _selectedTime.format(context),
      note: _notesController.text.trim(),
      isCompleted: _isCompleted,
    );

    final box = Hive.box('todos');

    if (widget.todoKey == null) {
      await box.add(todo.toMap());
    } else {
      await box.put(widget.todoKey, todo.toMap());
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }


  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff512EA4),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          widget.todoKey == null ? 'Add New To-Do' : 'Edit To-Do',
          style: GoogleFonts.dekko(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Task Title"),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: GoogleFonts.dekko(fontSize: 18),
              decoration: _inputDecoration(hintText: "Task Title"),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                _buildLabel("Category"),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_categories.length, (index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategoryIndex = index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: category['bgColor'],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xff512EA4)
                                  : Colors.white,
                              width: 2.5,
                            ),
                          ),
                          child: Icon(
                            category['icon'],
                            color: category['iconColor'],
                            size: 22,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Date"),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(10),
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                          child: Text(
                            _formatDate(_selectedDate),
                            style: GoogleFonts.dekko(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Time"),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickTime,
                        borderRadius: BorderRadius.circular(10),
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            suffixIcon: const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: GoogleFonts.dekko(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLabel("Notes"),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 6,
              style: GoogleFonts.dekko(fontSize: 18),
              decoration: _inputDecoration(hintText: "Notes"),
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
              onPressed: _saveTodo,
              child: Text(
                widget.todoKey == null ? 'Save' : 'Update',
                style: GoogleFonts.dekko(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dekko(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.dekko(color: Colors.black45, fontSize: 16),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff512EA4), width: 1.5),
      ),
    );
  }
}
