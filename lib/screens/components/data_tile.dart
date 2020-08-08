import 'package:flutter/material.dart';

class DataTile extends StatelessWidget {
  final String myTitle;
  final String value;
  final TextInputType type;
  final Function onSaved;

  DataTile({this.myTitle, this.value, this.type, this.onSaved});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        keyboardType: type,
        validator: (String newValue) {
          if (newValue.isEmpty) {
            return 'Este campo no puede estar vacio';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: myTitle,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        initialValue: value,
        onSaved: onSaved,
      ),
      //dense: true,
    );
  }
}

/*
Widget dataTile(String myTitle, String value, TextInputType type) {
  return ListTile(
    title: TextFormField(
      keyboardType: type,
      validator: (String newValue) {
        if (newValue.isEmpty) {
          return 'Este campo no puede estar vacio';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: myTitle,
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      initialValue: value,
      onSaved: (String newValue) {
        value = newValue;
      },
    ),
    //dense: true,
  );
}
 */
