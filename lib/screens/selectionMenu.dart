import 'dart:collection';

import 'package:flutter/material.dart';

class SelectionMenu extends StatefulWidget {
  final String title;
  final LinkedHashMap items;

  SelectionMenu(this.title, this.items);

  @override
  _SelectionMenuState createState() => _SelectionMenuState();
}

class _SelectionMenuState extends State<SelectionMenu> {

  @override
  Widget build(BuildContext context) {
    List<int> _listGroup = List.generate(widget.items.length, (i) => i);
    int _selection = null;

    return AlertDialog(
      title: Container(
        height: 87,
        child: Center(
          child: Column(
            children: [
              Text(
                this.widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(thickness: 2, color: Colors.black87,)
            ],
          ),
        ),
      ),
      content: Container(
          height: 220,
          child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int Index) {
                int i = Index + 1;
                return RadioListTile<int>(
                    title: Text(
                      widget.items[Index],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _listGroup[Index],
                    groupValue: _selection,
                    onChanged: (int value) {
                      setState(() {
                        _selection = value;
                      });
                      Navigator.pop(context, value);
                    }
                );
              }
              )


                 /* ListTile(
                  title: Row(
                    children: [
                      Text(
                        widget.items[Index],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  leading: Radio(
                    value: Index,
                    //groupValue: _selection,
                    onChanged: (int value) {
                      //setState(() {
                      //  _selection = value;
                      //});
                      Navigator.pop(context, value);
                    },
                  ),*/

    )
    );

  }
}
