import 'package:string_calculator_java/error_log.dart';

import 'calculator_error.dart';

class Calculator {
  String _separators;
  List<double> _nums = List();
  String _defaultSeparators = ",|\n";
  int _inputIndex; //Value that represents the char that is being tested on the input string.

  add(String expression) {
    if (expression.isEmpty) return "0";

    _setSeparators(expression);
    if (_separators != _defaultSeparators) expression = _cleanInput(expression);

    _validateAndCast(expression);
    if (ErrorLog.isNotEmpty())
      return "Error has occurred. Check ErrorLog to see details.";

    var result = _nums.reduce((a, b) => a + b);
    return _roundIfPossible(result);
  }

  multiply(String expression) {
    if (expression.isEmpty) return "0";

    _setSeparators(expression);
    if (_separators != _defaultSeparators) expression = _cleanInput(expression);

    _validateAndCast(expression);
    if (ErrorLog.isNotEmpty())
      return "Error has occurred. Check ErrorLog to see details.";

    var result = _nums.reduce((a, b) => a * b);
    return _roundIfPossible(result);
  }

  void _validateAndCast(String expression) {
    _nums.clear();
    _inputIndex = 1;
    ErrorLog.clear();

    _castExpressionToNumbers(expression);

    bool endsInNumber = expression
        .substring(expression.length - 1)
        .contains(RegExp("^-?[0-9]+"));
    if (!endsInNumber) {
      ErrorLog.put(CalculatorError(
          ErrorCode.EOF_FOUND, "Number expected but EOF found."));
    }

    _searchForNegativeValues();
  }

  _setSeparators(String input) {
    var customSeparators = RegExp("//(.|\n)*\n(.)*");
    if (input.contains(customSeparators)) {
      _separators = input.substring(2, input.indexOf("\n"));
      if (_separators.contains(RegExp("[!@#\$%^&*(),.?\":{}|<>]"))) {
        _separators = "[" + _separators + "]";
      }
    } else {
      _separators = _defaultSeparators;
    }
  }

  String _cleanInput(String input) {
    return input.substring(input.indexOf("\n") + 1);
  }

  void _searchForNegativeValues() {
    List<double> negativeNums = List();
    for (double x in _nums) {
      if (x < 0) negativeNums.add(x);
    }
    bool hasNegativeValues = negativeNums.isNotEmpty;
    if (hasNegativeValues) {
      String negativeErrorMessage =
          "Negative not allowed : "; //Hay que formar el string aNTES de loggearlo
      for (var i = 0; i < negativeNums.length; i++) {
        negativeErrorMessage += _roundIfPossible(negativeNums[i]);
        if (i != negativeNums.length - 1) negativeErrorMessage += ", ";
      }
      _addNewErrorMessage(ErrorCode.NEGATIVE_NOT_ALLOWED, negativeErrorMessage);
    }
  }

  void _castExpressionToNumbers(String expression) {
    List<String> splittedInput = expression.split(RegExp(_separators));
    int i = 0;
    String value = "";
    for (i = 0; i < splittedInput.length; i++) {
      value = splittedInput[i];
      _inputIndex += value.length;
      try {
        _nums.add(double.parse(value));
      } catch (FormatException) {
        if (ErrorLog.getLast()?.message !=
            "Number expected but EOF found.") //El modificador '?.' solo realizará la siguiente operación cuando la función no haya devuelto null.
          _addNewErrorMessage(
              ErrorCode.NUMBER_EXPECTED,
              "Number expected but '" +
                  expression[_inputIndex] +
                  "' found at position " +
                  _inputIndex.toString() +
                  ".");
      }
    }
  }

  String _roundIfPossible(double result) {
    if (result == result.roundToDouble()) {
      return result.toInt().toString();
    }
    return result.toStringAsFixed(1);
  }

  _addNewErrorMessage(ErrorCode errorCode, String message) {
    ErrorLog.put(CalculatorError(errorCode, message));
  }
}