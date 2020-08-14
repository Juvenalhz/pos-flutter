import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';

import 'package:pay/screens/commProgress.dart';
import 'package:pay/bloc/initializationBloc.dart';

class ShowInitializationProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final InitializationBloc initializationBloc = BlocProvider.of<InitializationBloc>(context);

    return BlocBuilder<CommBloc, CommState>(builder: (context, state) {
      if (state is CommLoaded) {
        initializationBloc.add(InitializationConnect(state.comm));
        return BlocBuilder<InitializationBloc, InitializationState>(builder: (context, state) {
          if (state is InitializationConnecting)
            return CommProgress('Inicialization', status: 'Conectando').build(context);
          else if (state is InitializationSending)
            return CommProgress('Inicialization', status: 'Enviando').build(context);
          else if (state is InitializationInitial)
            return CommProgress('Inicialization').build(context);
          else {
            return CommProgress('Inicialization').build(context);
          }
        });
      } else
        return CommProgress('Inicialization').build(context);
    });
  }
}

class Initialization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<InitializationBloc>(create: (context) => InitializationBloc(), child: ShowInitializationProgress()),
      ),
    );
  }
}
