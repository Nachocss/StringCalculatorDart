import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:string_calculator_java/calculator_error.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorEmpty extends CalculatorState {}

class CalculatorFoundError extends CalculatorState {
  final CalculatorError error;

  const CalculatorFoundError({@required this.error});

  @override
  List<CalculatorError> get props => [error];
}

class CalculatorResult extends CalculatorState {
  final String result;

  const CalculatorResult({@required this.result});

  @override
  List<String> get props => [result];
}
