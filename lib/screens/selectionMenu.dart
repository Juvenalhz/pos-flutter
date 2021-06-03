import 'dart:collection';
import 'package:flutter/material.dart';

class SelectionMenu extends StatefulWidget {
  final String title;
  final LinkedHashMap items;
  final bool needsPop;
  final Function(BuildContext, int) onSelection;
  final int selectedItem;

  SelectionMenu(this.title, this.items, this.needsPop, {this.onSelection, this.selectedItem}) : super();

  @override
  _SelectionMenuState createState() => _SelectionMenuState(title, items, needsPop, onSelection: onSelection, selectedItem: selectedItem);
}

class _SelectionMenuState extends State<SelectionMenu> {
  final String title;
  final LinkedHashMap items;
  final bool needsPop;
  final Function(BuildContext, int) onSelection;
  final selectedItem;
  int _selection;


  _SelectionMenuState(this.title, this.items, this.needsPop, {this.onSelection, this.selectedItem}) {

    if (selectedItem != null)
      _selection = selectedItem;

  }

  @override
  Widget build(BuildContext context) {

    double height;

    if (this.title.length > 0)
      height = 87;
    else
      height = 20;

    return AlertDialog(
      title: Container(
        height: height,
        child: Center(
          child: Column(
            children: [
              if (this.title.length > 0)
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
              if (this.title.length > 0)
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
              itemBuilder: (BuildContext context, index) {
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
                    toggleable: false,
                    selected: (_selection == index),
                    onChanged: (int value) async {
                      print('selected:' + value.toString());
                      _selection = value;
                      setState(() {
                        //_selection = value;

                      });

                      if (needsPop == true) {
                        await new Future.delayed(const Duration(milliseconds: 250));
                        Navigator.pop(context, value);
                      } else {
                        if (onSelection != null) {
                          await new Future.delayed(const Duration(milliseconds: 250));
                          onSelection(context, value);
                        }
                      }
                      //(context as Element).markNeedsBuild();
                    }

                    );
              })),
    );
  }
}
