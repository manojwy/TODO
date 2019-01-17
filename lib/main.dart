import 'package:flutter/material.dart';
import 'data/repository.dart';
import 'widgets/todolist.dart';
import 'widgets/item_viewer.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Todo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoListHome());
  }
}

class TodoListHome extends StatefulWidget {
  @override
  _TodoListHomeState createState() => _TodoListHomeState();
}

class _TodoListHomeState extends State<TodoListHome> {
  final _todoListKey = GlobalKey();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _ctx;

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Todo'),
      ),
      body: new Center(
          child: TodoList(
        key: _todoListKey,
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add a new item',
        child: new Icon(Icons.add),
      ),
    );
  }

  _addNewItem() async {
    print("_addNewItem");
//    Repository.getDatabase().addItem();
//

//
//
//
//    final snackBar = SnackBar(
//        content: new Text('This is the Snackbar...')
//    );
//
////    Scaffold.of(_ctx).showSnackBar(snackBar);
//    _scaffoldKey.currentState.showSnackBar(snackBar);

    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ItemViewer();
    }));

    if (result == true) {
      _todoListKey.currentState.didChangeDependencies();
      //final snackBar = SnackBar(content: new Text('New item added'));
      //_scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}
