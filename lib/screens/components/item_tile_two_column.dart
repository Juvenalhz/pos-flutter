import 'package:flutter/material.dart';

class ItemTileTwoColumn extends StatelessWidget {
  final Widget leftLabel;
  final Widget rightLabel;
  final Widget leftItem;
  final Widget rightItem;
  final Widget rightTrailing;
  final double leftWidth;
  final double rightWidth;
  final EdgeInsetsGeometry contentPadding;

  ItemTileTwoColumn({
    this.leftLabel,
    this.rightLabel,
    this.leftItem,
    this.rightItem,
    this.rightTrailing,
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
            contentPadding: EdgeInsets.only(left: 10.0),
            title: leftLabel,
            subtitle: leftItem,
          ),
        ),
        Container(
          width: rightWidth,
          child: ListTile(
            contentPadding: EdgeInsets.only(right: 10.0),
            title: rightLabel,
            subtitle: rightItem,
            trailing: rightTrailing,
          ),
        ),
      ],
    );
  }
}
