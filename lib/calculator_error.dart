class CalculatorError {
  final ErrorCode _errorCode;
  final String _message;

  CalculatorError(this._errorCode, this._message);

  ErrorCode get errorCode => _errorCode;

  String get message => _message;
}

enum ErrorCode { EOF_FOUND, NEGATIVE_NOT_ALLOWED, NUMBER_EXPECTED }
