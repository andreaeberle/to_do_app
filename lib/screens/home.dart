import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/todo_item.dart';
import '../models/todo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todoList = ToDo.todoList();
  final _todoController = TextEditingController();
  late SharedPreferences sharedPreferences;

  // Ensures the app loads with locally-saved data
  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  // Gets locally-saved data from SharedPreferences
  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do App"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                // ListView to contain to-do list name and subsequent to-do
                // list items
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      margin: const EdgeInsets.only(
                        top: 25,
                        bottom: 15,
                      ),
                      child: const Text(
                        "To-Do List",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // For loop iterates through all ToDo objects contained in
                    // todoList and calls methods to make any necessary changes
                    // to the data stored in the ToDo objects
                    for (ToDo todo in todoList)
                      ToDoItem(
                        todo: todo,
                        onDoneStatusChanged: _changeIsDoneStatus,
                        onDeleteItem: _deleteToDoItem,
                        onSetDeadline: _setDeadline,
                      ),
                  ],
                ),
              )
            ],
          ),
          // Creates a bar along the bottom of the screen where a user can add
          // to-do list items
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // User input is passed to the appropriate method to
                        // create a new to-do item
                        _addToDoItem(_todoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        minimumSize: const Size(50, 50),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          hintText: "Add a new to-do item",
                          hintStyle: TextStyle(fontSize: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Method sets the user's selected date as the deadline for the to-do item
  // and saves the change locally
  void _setDeadline(ToDo todo, String deadline) {
    setState(() {
      todo.deadline = deadline;
      todo.hasDeadline = true;
    });
    _saveData();
  }

  // Method handles swtich between user marking a to-do item as done or not
  // done and saves the change locally
  void _changeIsDoneStatus(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    _saveData();
  }

  // Method handles request from user to delete a to-do list item and saves the
  // change locally
  void _deleteToDoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
    _saveData();
  }

  // Method uses user input to create a new to-do list item, clears the
  // TextField, and saves the change locally
  void _addToDoItem(String toDo) {
    setState(() {
      todoList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
        deadline: '',
      ));
    });
    _saveData();
    _todoController.clear();
  }

  // Method encodes a map of data from each ToDo object in todoList, converts
  // the map to a list, and saves that list of data locally
  void _saveData() {
    List<String> savedList =
        todoList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList("list", savedList);
  }

  // Method loads the list of strings that has been saved locally and converts
  // that list of strings into maps, which are then converted into ToDo objects.
  // The ToDo objects are collected in a list and assigned to "todoList".
  void _loadData() {
    List<String>? savedList = sharedPreferences.getStringList("list");
    todoList =
        savedList!.map((item) => ToDo.fromMap(json.decode(item))).toList();
    setState(() {});
  }
}
