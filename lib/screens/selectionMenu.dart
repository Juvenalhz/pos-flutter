import 'dart:collection';
import 'package:flutter/material.dart';

class SelectionMenu extends StatefulWidget {
  final String title;
  final LinkedHashMap items;
  final bool needsPop;
  final Function(BuildContext, int) onSelection;

  SelectionMenu(this.title, this.items, this.needsPop, {this.onSelection});

  @override
  _SelectionMenuState createState() => _SelectionMenuState(title, items, needsPop, onSelection: onSelection);
}

class _SelectionMenuState extends State<SelectionMenu> {
  final String title;
  final LinkedHashMap items;
  final bool needsPop;
  final Function(BuildContext, int) onSelection;

  _SelectionMenuState(this.title, this.items, this.needsPop, {this.onSelection});

  @override
  Widget build(BuildContext context) {
    int _selection = items.length;

    return AlertDialog(
      title: Container(
        height: 87,
        child: Center(
          child: Column(
            children: [
              Text(
                this.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.black87,
              )
            ],
          ),
        ),
      ),
      content: Container(
          height: 220,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<int>(
                    title: Text(
                      items[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: index,
                    groupValue: _selection,
                    onChanged: (int value) {
                      setState(() {
                        _selection = value;
                      });

                      if (needsPop == true) {
                        Navigator.pop(context, value);
                      } else {
                        if (onSelection != null) {
                          onSelection(context, value);
                        }
                      }
                    });
              })),
    );
  }
}
