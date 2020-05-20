import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_calculator_java/bloc/calculator_events.dart';
import 'package:string_calculator_java/bloc/calculator_state.dart';
import 'package:string_calculator_java/calculator.dart';

import '../error_log.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final Calculator _calculator = new Calculator();

  @override
  CalculatorState get initialState => CalculatorHome();

  @override
  Stream<CalculatorState> mapEventToState(CalculatorEvent event) async* {
    if (event is OperateInput) {
      String result = "";

      switch (event.operationType) {
        case OperationType.ADD:
          result = _calculator.add(event.userInput);
          break;
        case OperationType.MULTIPLY:
          result = _calculator.multiply(event.userInput);
          break;
      }
      if (ErrorLog.isNotEmpty()) {
        yield CalculatorFoundError(error: ErrorLog.getLast());
      } else {
        yield CalculatorResult(result: result);
      }
    }
    if (event is GoHome) {
      yield CalculatorHome();
    }
  }
}
