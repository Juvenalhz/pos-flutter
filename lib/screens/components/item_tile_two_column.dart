import 'package:flutter/material.dart';

class ItemTileTwoColumn extends StatelessWidget {
  final Widget leftLabel;
  final Widget rightLabel;
  final Widget leftItem;
  final Widget rightItem;
  final double leftWidth;
  final double rightWidth;
  final EdgeInsetsGeometry contentPadding;

  ItemTileTwoColumn({
    this.leftLabel,
    this.rightLabel,
    this.leftItem,
    this.rightItem,
    @required this.leftWidth,
    @required this.rightWidth,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: leftWidth,
          child: ListTile(
            contentPadding: contentPadding,
            title: leftLabel,
            subtitle: leftItem,
          ),
        ),
        Container(
          width: rightWidth,
          child: ListTile(
            contentPadding: contentPadding,
            title: rightLabel,
            subtitle: rightItem,
          ),
        ),
      ],
    );
  }
}
