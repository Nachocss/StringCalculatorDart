import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_calculator_java/bloc/calculator_events.dart';
import 'package:string_calculator_java/bloc/calculator_state.dart';
import 'package:string_calculator_java/calculator.dart';
import 'package:string_calculator_java/calculator_error.dart';

import '../error_log.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  @override
  CalculatorState get initialState => CalculatorEmpty();

  @override
  Stream<CalculatorState> mapEventToState(CalculatorEvent event) async* {
    if (event is OperateInput) {
      String result = new Calculator().add(event.userInput);
      if (ErrorLog.isNotEmpty()) {
        yield CalculatorFoundError(error: ErrorLog.getLast());

      } else {
        yield CalculatorResult(result: result);
      }
    }
    if (event is GoHome) {
      yield CalculatorEmpty();
    }
  }
}
