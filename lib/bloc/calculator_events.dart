import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();
}

class OperateInput extends CalculatorEvent {
  final String userInput;

  const OperateInput({@required this.userInput}) : assert(userInput != "");

  @override
  List<String> get props => [userInput];
}

class GoHome extends CalculatorEvent {

  const GoHome();
  
  @override
  List<Object> get props => [];
}


