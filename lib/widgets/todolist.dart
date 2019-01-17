import 'dart:async';
import 'package:flutter/material.dart';
import '../model/Item.dart';
import '../data/repository.dart';
import 'item_viewer.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key}) : super(key: key);

  void refresh() {}

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    getUpdatedList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUpdatedList();
  }

  void getUpdatedList() async {
    print('getUpdatedList  start');
    await Repository.getDatabase().getDBPath();

    List<Item> allItems = await Repository.getDatabase().getAllItems();

    setState(() {
      _items = allItems;
    });
  }

  void _deleteItem(int id) async {
    print('_deleteItem: $id');
    await Repository.getDatabase().removeItem(id);
    getUpdatedList();
  }

  void _showDetail(Item item) async {
    print('_showDetail: ${item.id}');
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ItemViewer(item:item);
    }));

    if (result == true) {
      didChangeDependencies();
    }

  }

  @override
  Widget build(BuildContext context) {
    if (_items.length == 0) {
      return Text("Empty");
    } else {
      return ListView(
          children: _items
              .map((item) => Card(
                  color: Colors.white,
                  elevation: 1.0,
                  child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.play_arrow)),
                      title: Text(item.title),
                      subtitle: Text(item.description ?? ''),
                      trailing: GestureDetector(
                          child: const Icon(Icons.delete, color: Colors.grey),
                          onTap: () {
                            print("Pressed Delete");
                            _deleteItem(item.id);
                          }),
                      onTap: () {
                        /* react to the tile being tapped */
                        print('open details view');
                        _showDetail(item);
                      })))
              .toList());
    }
  }
}
