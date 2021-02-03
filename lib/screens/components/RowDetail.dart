import 'package:flutter/material.dart';

class RowDetail extends StatelessWidget {
  final String label;
  final String strAmount;

  const RowDetail({
    Key key,
    @required this.label,
    @required this.strAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22)),
        Flexible(fit: FlexFit.tight, child: SizedBox()),
        Text(strAmount, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22))
      ]),
    );
  }
}

class RowDetailAmount extends StatelessWidget {
  final String label;
  final String strAmount;

  const RowDetailAmount({
    Key key,
    @required this.label,
    @required this.strAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        Flexible(fit: FlexFit.tight, child: SizedBox()),
        Text(strAmount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
      ]),
    );
  }
}
