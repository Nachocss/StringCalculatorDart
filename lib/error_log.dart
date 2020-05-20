import 'calculator_error.dart';

class ErrorLog {
  static final List<CalculatorError> _errorList = new List();

  static put(CalculatorError error) => _errorList.add(error);

  static int getCount() => _errorList.length;

  static CalculatorError get(int index) => _errorList[index];

  static CalculatorError getLast() =>
      _errorList.length > 0 ? _errorList.last : null;

  static String getErrors() => _errorList.map((e) => e.message).join("\n").toString();

  static clear() => _errorList.clear();

  static isEmpty() => _errorList.isEmpty;

  static isNotEmpty() => _errorList.isNotEmpty;
}
