import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataTile extends StatelessWidget {
  final String myTitle;
  final String value;
  final TextInputType type;
  final int maxLength;
  final Function onSaved;
  final Function onChanged;
  final Function validator;
  final List<TextInputFormatter> formatInput;

  DataTile({
    this.myTitle,
    this.value,
    this.type,
    this.maxLength,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.formatInput,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        maxLength: maxLength,
        keyboardType: type,
        validator: validator,
        inputFormatters: formatInput,
        decoration: InputDecoration(
          labelText: myTitle,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        initialValue: value,
        onSaved: onSaved,
        onChanged: onChanged,
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
