import 'package:flutter/material.dart';

class CheckboxItem extends StatelessWidget {
  final String label;
  final bool value;
  final Function onChanged;

  CheckboxItem({this.label, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
