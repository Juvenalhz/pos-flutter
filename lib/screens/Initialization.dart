import 'package:flutter/cupertino.dart';
import 'package:pay/screens/commProgress.dart';

class Initialization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDev = (const String.fromEnvironment('dev') == 'true');
    //final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);

    return CommProgress('Inicialization', status: 'test2');
  }
}
