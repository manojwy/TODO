import 'dart:async';
import 'package:flutter/material.dart';
import '../model/Item.dart';
import '../data/repository.dart';

class ItemViewer extends StatefulWidget {
  final Item item;

  ItemViewer({this.item});

  @override
  _ItemViewerState createState() => _ItemViewerState(this.item);
}

class _ItemViewerState extends State<ItemViewer> {
  final _formKey = GlobalKey<FormState>();
  Item item;
  Item localItem;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _ItemViewerState(this.item);

  String appbarTitle = "Add Item";

  @override
  void initState() {
    super.initState();

    if (item == null) {
      localItem = Item(title: '', startTime: DateTime.now());
      localItem.description = '';
      localItem.priority = Priority.low;
    } else {
      appbarTitle = "Edit Item";
      localItem = Item.clone(item);
    }

    titleController.text = localItem.title;
    descriptionController.text = localItem.description;

    titleController.selection =
        TextSelection.collapsed(offset: localItem.title.length);
    descriptionController.selection =
        TextSelection.collapsed(offset: localItem.description.length);
  }

  void saveItem() async {
    Navigator.pop(context, true);

    if (localItem.id == null) {
      //fire an insert
      await Repository.getDatabase().addItem(
          title: localItem.title,
          description: localItem.description,
          priority: localItem.priority.index);
    } else {
      // fire an update
      await Repository.getDatabase().updateItem(
          id: localItem.id,
          title: localItem.title,
          description: localItem.description,
          priority: localItem.priority.index);
    }
  }

  Priority _priorityFromString(String value) {
    Priority priority = Priority.low;

    for (int i = 0; i < Priority.values.length; i++) {
      if (value ==
          Priority.values[i].toString().split('.').last.toUpperCase()) {
        priority = Priority.values[i];
        break;
      }
    }

    localItem.priority = priority;
    print(priority.toString());
    setState(() {});
    return priority;
  }

  String _priorityAsString(Priority priority) {
    if (priority == null) {
      priority = Priority.low;
    }
    String value = priority.toString().split('.').last.toUpperCase();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 16.0, color: Colors.black);

    return Scaffold(
      appBar: new AppBar(
        title: Text(appbarTitle),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  style: textStyle,
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Title should be non empty';
                    }
                  },
                  onFieldSubmitted: (value) {
                    localItem.title = value;
                  },
                ),
                TextFormField(
                  style: textStyle,
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (value) {},
                  onFieldSubmitted: (value) {
                    localItem.description = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(children: <Widget>[
                    Text(
                      "Priority",
                      style: textStyle,
                    ),
                    Container(
                      width: 20.0,
                    ),
                    DropdownButton<String>(
                      items: Priority.values.map((priority) {
                        String str = _priorityAsString(priority);
                        str = str[0].toUpperCase() + str.substring(1).toLowerCase();
                        return DropdownMenuItem<String>(
                          value: _priorityAsString(priority),
                          child: Text(str),
                        );
                      }).toList(),
//                      style: textStyle,
                      value: _priorityAsString(localItem.priority),
                      onChanged: (String value) {
                        _priorityFromString(value);
                      },
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.lightGreen,
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.

                            if (_formKey.currentState.validate()) {
                              localItem.title = titleController.text;
                              localItem.description =
                                  descriptionController.text;
                              saveItem();
                            }
                          },
                          child: Text('SAVE'),
                        ),
                      ),
                      Container(
                        width: 10.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.amber,
                          child: Text("CANCEL"),
//                          textColor: Colors.white,
//                          splashColor: Colors.yellow,
                          onPressed: () {
                            debugPrint("Cancel Button pressed");
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
