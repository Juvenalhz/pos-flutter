import 'package:flutter/material.dart';

class DropDownItems {
  static const typePinpadList = <String>[
    'Interno',
    'Externo',
  ];

  static final List<DropdownMenuItem<String>> dropDownTypePinpad = typePinpadList
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
}
