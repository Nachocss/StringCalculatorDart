import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();
}

enum OperationType { ADD, MULTIPLY, DIVIDE, SUBSTRACT }

class OperateInput extends CalculatorEvent {
  final String userInput;
  final OperationType operationType;

  const OperateInput({@required this.operationType, @required this.userInput}) : assert(userInput != "");

  @override
  List<String> get props => [userInput];
}

class GoHome extends CalculatorEvent {
  const GoHome();

  @override
  List<Object> get props => [];
}
