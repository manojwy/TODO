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

  _ItemViewerState(this.item);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String appbarTitle = "Add Item";

  @override
  void initState() {
    super.initState();

    if (item == null) {
      item = Item(title: '', startTime: DateTime.now());
      item.description = '';
    } else {
      appbarTitle = "Edit Item";
    }
  }

  void saveItem() async {
    Navigator.pop(context, true);

    print(item.title);
    print(item.description);

    if (item.id == null) {
      //fire an insert
      await Repository.getDatabase()
          .addItem(title: item.title, description: item.description);
    } else {
      // fire an update
      await Repository.getDatabase().updateItem(
          id: item.id, title: item.title, description: item.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = item.title;
    descriptionController.text = item.description;

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
                  decoration: InputDecoration(labelText: 'Title'),
//                  initialValue: item.title,
                  controller: titleController,
                  validator: (value) {
                    print('validator Title $value');
                    if (value.isEmpty) {
                      return 'Title should be non empty';
                    }
                    item.title = value;
                    setState(() {

                    });
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted Title $value');
                    item.title = value;
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
//                  initialValue: item.description,
                  controller: descriptionController,
                  validator: (value) {
                    item.description = value;
                    setState(() {
                    });
                  },
                  onFieldSubmitted: (value) {
                    item.description = value;
                    setState(() {

                    });

                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              saveItem();
                            }
                          },
                          child: Text('Save'),
                        ),
                      ),
                      Container(
                        width: 10.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.deepPurple,
                          child: Text("Cancel"),
                          textColor: Colors.white,
                          splashColor: Colors.yellow,
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
