import 'package:flutter/material.dart';

class ItemTileTwoColumn extends StatelessWidget {
  final Widget leftLabel;
  final Widget rightLabel;
  final Widget leftItem;
  final Widget rightItem;

  ItemTileTwoColumn(
      {this.leftLabel, this.rightLabel, this.leftItem, this.rightItem});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        Container(
          width: size.width / 2.18,
          child: ListTile(
            title: leftLabel,
            subtitle: leftItem,
          ),
        ),
        Container(
          width: size.width / 2.18,
          child: ListTile(
            title: rightLabel,
            subtitle: rightItem,
          ),
        ),
      ],
    );
  }
}
