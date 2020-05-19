import 'package:quiver/strings.dart';
import 'package:string_calculator_java/error_log.dart';

import 'calculator_error.dart';

class Calculator {
  List<double> _nums = new List();
  String _defaultSeparators = ",|\n";
  String _separators;
  RegExp _separatorsRegex;
  RegExp _numbersRegex = new RegExp("^-?[0-9]+");
  RegExp _specialCharacters = new RegExp("[!@#\$%^&*(),.?\":{}|<>]");
  int _inputIndex; //Value that represents the char that is being tested on the input string.

  add(String input) {
    if (isEmpty(input)) {
      return "0";
    }

    _processInput(input);
    if (ErrorLog.isNotEmpty())
      return "Error has occurred. Check ErrorLog to see details.";

    var result = _nums.reduce((a, b) => a + b);
    return _roundIfPossible(result);
  }

  multiply(String input) {
    if (isEmpty(input)) {
      return "0";
    }

    _processInput(input);
    if (ErrorLog.isNotEmpty())
      return "Error has occurred. Check ErrorLog to see details.";

    var result = _nums.reduce((a, b) => a * b);
    return _roundIfPossible(result);
  }

  void _processInput(String input) {
    _nums.clear();
    _inputIndex = 1;
    ErrorLog.clear();
    _setSeparators(input);
    input = _cleanInput(input);

    bool endsInNumber =
        input.substring(input.length - 1).contains(_numbersRegex);
    if (!endsInNumber) {
      ErrorLog.put(new CalculatorError(
          ErrorCode.EOF_FOUND, "Number expected but EOF found."));
    }

    _castInputToDouble(input);

    _searchForNegativeValues();
  }

  _setSeparators(String input) {
    if (input.contains(new RegExp("//(.|\n)*\n(.)*"))) {
      int indexOfFirstNumber = input.indexOf("\n") + 1;
      _separators = input.substring(2, indexOfFirstNumber - 1);
      if (_separators.contains(_specialCharacters)) {
        _separators = "[" + _separators + "]";
      }
    } else {
      _separators = _defaultSeparators;
    }
    _separatorsRegex = new RegExp(_separators);
  }

  String _cleanInput(String input) {
    if (_separators != _defaultSeparators)
      return input.substring(input.indexOf("\n") + 1);
    else
      return input;
  }

  void _searchForNegativeValues() {
    List<double> negativeNums = new List();
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

  void _castInputToDouble(String input) {
    List<String> splittedInput = input.split(_separatorsRegex);
    int i = 0;
    String value = "";
    for (i = 0; i < splittedInput.length; i++) {
      value = splittedInput[i];
      _inputIndex += value.length;
      try {
        _nums.add(double.parse(value));
      } catch (FormatException) {
        if (ErrorLog.getLast()?.message !=
            "Number expected but EOF found.") //El modificador '?.' solo realizará la operación cuando la función no haya devuelto null.
          _addNewErrorMessage(
              ErrorCode.NUMBER_EXPECTED,
              "Number expected but '" +
                  input[_inputIndex] +
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
    ErrorLog.put(new CalculatorError(errorCode, message));
  }
}
