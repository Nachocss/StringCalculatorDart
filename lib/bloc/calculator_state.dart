import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorHome extends CalculatorState {
  const CalculatorHome();
}

class CalculatorFoundError extends CalculatorState {
  const CalculatorFoundError();
}

class CalculatorResult extends CalculatorState {
  final String result;

  const CalculatorResult({@required this.result});

  @override
  List<String> get props => [result];
}
