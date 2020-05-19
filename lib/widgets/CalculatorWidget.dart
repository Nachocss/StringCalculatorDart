import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_calculator_java/bloc/calculator_bloc.dart';
import 'package:string_calculator_java/bloc/calculator_events.dart';
import 'package:string_calculator_java/bloc/calculator_state.dart';
import 'package:string_calculator_java/error_log.dart';

class CalculatorWidget extends StatefulWidget {
  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('String Calculator'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            BlocProvider.of<CalculatorBloc>(context)
                .add(OperateInput(userInput: inputController.text));
          },
        ),
      ]),
      body: Center(
        child: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case CalculatorEmpty:
                return HomeScreen(inputController: inputController);
              case CalculatorFoundError:
                return ErrorScreen();
            }
            if (state is CalculatorResult) {
              return Column(
                children: <Widget>[
                  Center(child: Text(state.result)),
                  RaisedButton(
                    onPressed: () {
                      BlocProvider.of<CalculatorBloc>(context).add(GoHome());
                    },
                    child: Text("BACK"),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child: Text(
          ErrorLog.getLast().message,
          style: TextStyle(color: Colors.red),
        )),
        RaisedButton(
          onPressed: () {
            BlocProvider.of<CalculatorBloc>(context).add(GoHome());
          },
          child: Text("BACK"),
        )
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.inputController,
  }) : super(key: key);

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextField(
      controller: inputController,
      decoration: InputDecoration(hintText: 'Please insert data'),
    ));
  }
}
