import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  final dynamic onDoneStatusChanged;
  final dynamic onDeleteItem;
  final dynamic onSetDeadline;

  const ToDoItem({
    Key? key,
    required this.todo,
    this.onDoneStatusChanged,
    this.onDeleteItem,
    this.onSetDeadline,
  }) : super(key: key);

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // A function could be added here to add a sub-list option to the
        // to-do item
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      leading: IconButton(
        // Checkbox for to-do item, indicating whether or not task has been done
        onPressed: () {
          widget.onDoneStatusChanged(widget.todo);
        },
        icon: widget.todo.isDone
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
      ),
      title: Text(
        // User-provided text describes the to-do task
        widget.todo.todoText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: widget.todo.isDone ? Colors.grey : null,
        ),
      ),
      trailing: Wrap(
        spacing: 0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          SizedBox(
            // If the user has selected a deadline for their to-do item, it
            // will be displayed
            child: widget.todo.hasDeadline
                ? Text(
                    "By: ${widget.todo.deadline}",
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.todo.isDone ? Colors.grey : null,
                    ),
                  )
                : const Text(""),
          ),
          IconButton(
            // Calendar button allows user to select a deadline date for their
            // to-do item
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('M/d').format(pickedDate);

                widget.onSetDeadline(widget.todo, formattedDate);
              }
            },
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            // Delete button allows user to delete a to-do item
            onPressed: () {
              widget.onDeleteItem(widget.todo.id);
            },
            icon: const Icon(Icons.delete),
            iconSize: 27,
          ),
        ],
      ),
    );
  }
}
