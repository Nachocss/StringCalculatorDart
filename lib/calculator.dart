import 'package:quiver/strings.dart';

class Calculator {
  List<double> _nums = new List();
  String _defaultSeparators = ",|\n";
  String _separators;
  RegExp _separatorsRegex;
  RegExp _numbersRegex = new RegExp("^-?[0-9]+");
  RegExp _specialCharacters = new RegExp("[!@#\$%^&*(),.?\":{}|<>]");
  String _errorMsg;
  int _inputIndex; //Value that represents the char that is being tested on the input string.

  add(String input) {
    _nums.clear();
    _errorMsg = "";
    _inputIndex = 1;
    if (isEmpty(input)) {
      return "0";
    }

    _setSeparators(input);
    input = _cleanInput(input);

    bool endsInNumber =
        input.substring(input.length - 1).contains(_numbersRegex);
    if (!endsInNumber) {
      return "Number expected but EOF found.";
    }

    _castInputToDouble(input);

    _searchForNegativeValues();

    if (_errorMsg.isNotEmpty) return _errorMsg;

    var result = _nums.reduce((a, b) => a + b);
    return _roundIfPossible(result);
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
      _addNewErrorMessage("Negative not allowed : ");
      for (var i = 0; i < negativeNums.length; i++) {
        _errorMsg += _roundIfPossible(negativeNums[i]);
        if (i != negativeNums.length - 1) _errorMsg += ", ";
      }
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
        _addNewErrorMessage("Number expected but '" +
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

  _addNewErrorMessage(String text) {
    if (_errorMsg.isNotEmpty) _errorMsg += "\n";
    _errorMsg += text;
  }
}