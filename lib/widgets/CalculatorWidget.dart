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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('String Calculator'),
      ),
      body: Center(
        child: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
            if (state is CalculatorHome) {
              return HomeScreen();
            }
            if (state is CalculatorFoundError) {
              return HomeScreenShowingErrorDialog();
            }
            if (state is CalculatorResult) {
              return ResultScreen(state: state);
            }
            return null;
          },
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final CalculatorResult state;

  const ResultScreen({
    Key key,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Column(
          children: <Widget>[
            Center(child: Text(state.result)),
            RaisedButton(
              onPressed: () {
                BlocProvider.of<CalculatorBloc>(context).add(GoHome());
              },
              child: Text("BACK"),
            )
          ],
        ),
        onWillPop: () {
          BlocProvider.of<CalculatorBloc>(context).add(GoHome());
          return Future(() =>
              false); //Giving 'true' to this value will make our app to close.
        });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: inputController,
              maxLines: 2,
              decoration: InputDecoration(hintText: 'Please insert data'),
            ),
          ),
          ButtonGroup(inputController: inputController),
        ],
      ),
    );
  }
}

class ButtonGroup extends StatelessWidget {
  const ButtonGroup({Key key, @required this.inputController})
      : super(key: key);
  final TextEditingController inputController;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            OperationButton(
              inputController: inputController,
              operationType: OperationType.ADD,
            ),
            OperationButton(
              inputController: inputController,
              operationType: OperationType.MULTIPLY,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            OperationButton(
              inputController: inputController,
              operationType: OperationType.SUBTRACT,
            ),
            OperationButton(
              inputController: inputController,
              operationType: OperationType.DIVIDE,
            ),
          ],
        ),
      ]),
    );
  }
}

class OperationButton extends StatelessWidget {
  const OperationButton({
    Key key,
    @required this.inputController,
    @required this.operationType,
  }) : super(key: key);

  final TextEditingController inputController;
  final OperationType operationType;

  @override
  Widget build(BuildContext context) {
    String buttonText;
    switch (operationType) {
      case OperationType.ADD:
        buttonText = "+";
        break;
      case OperationType.MULTIPLY:
        buttonText = "x";
        break;
      case OperationType.DIVIDE:
        buttonText = "%";
        break;
      case OperationType.SUBTRACT:
        buttonText = "-";
        break;
    }
    return Padding(
      padding: EdgeInsets.all(8),
      child: ButtonTheme(
        height: 120.0,
        minWidth: 120.0,
        child: RaisedButton(
          child: Text(
            buttonText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100.0),
          ),
          onPressed: () {
            if (inputController.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Insert some data"),
              ));
            } else {
              BlocProvider.of<CalculatorBloc>(context).add(OperateInput(
                  userInput: inputController.text,
                  operationType: operationType));
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
    return WillPopScope(
        child: Column(
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
        ),
        onWillPop: () {
          BlocProvider.of<CalculatorBloc>(context).add(GoHome());
          return Future(() =>
              false); //Giving 'true' to this value will make our app to close.
        });
  }
}

class HomeScreenShowingErrorDialog extends StatelessWidget {
  const HomeScreenShowingErrorDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HomeScreen(),
        ErrorDialog(),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Error found"),
      content: Text(
        ErrorLog.getErrors(),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Accept'),
            onPressed: () =>
                BlocProvider.of<CalculatorBloc>(context).add(GoHome())),
      ],
    );
  }
}
