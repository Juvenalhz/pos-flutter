import 'dart:collection';

import 'package:flutter/material.dart';

class SelectionMenu extends StatelessWidget {
  final String title;
  final LinkedHashMap items;

  SelectionMenu(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          gradient: LinearGradient(
            begin: Alignment(0.0, 0.6),
            end: Alignment(0.0, 0.0),
            colors: <Color>[
              Color(0xFF0D47A1),
              Colors.blue,
            ],
          ),
        ),
        child: Center(
          child: Text(
            this.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      content: Container(
          height: 220,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int Index) {
                int i = Index + 1;
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          '$i ) ',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          items[Index],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, Index);
                  },
                );
              })),
    );
  }
}
