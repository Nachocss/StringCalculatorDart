import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_calculator_java/bloc/calculator_bloc.dart';
import 'package:string_calculator_java/bloc/simple_bloc_delegate.dart';
import 'package:string_calculator_java/widgets/CalculatorWidget.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StringCalculator Kata',
      home: BlocProvider(
        create: (context) => CalculatorBloc(),
        child: CalculatorWidget(),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      );
  }
}

