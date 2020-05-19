import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator_java/calculator.dart';
import 'package:string_calculator_java/error_log.dart';

void main() {
  final calculator = Calculator();

  test('return 0 when input is empty', () {
    expect(calculator.add(""), "0");
  });

  test('return the input value when it is one single number', () {
    expect(calculator.add("1"), "1");
  });

  test('handle the sum of an uknown amount of numbers', () {
    expect(calculator.add("1.1,2.2"), "3.3");
    expect(calculator.add("1,2,3"), "6");
  });

  test('support "newline" as separator', () {
    expect(calculator.add("1\n2"), "3");
  });

  test('not accept unexpected EOF', () {
    calculator.add("1,3,");
    expect(ErrorLog.getLast().message, "Number expected but EOF found.");
  });

  test('support custom separators', () {
    expect(calculator.add("//;\n1;2"), "3");
    expect(calculator.add("//|\n1|2"), "3");
    expect(calculator.add("//*\n1*2"), "3");
    expect(calculator.add("//*|\n1*2|2"), "5");
    expect(calculator.add("//sep\n1sep2"), "3");
    expect(calculator.add("//;\n1;2"), "3");
  });

  test('not accept negative numbers', () {
    calculator.add("-1,2");
    expect(ErrorLog.getLast().message, "Negative not allowed : -1");
    calculator.add("2,-4,-5");
    expect(ErrorLog.getLast().message, "Negative not allowed : -4, -5");
  });

  test('log multiple errors', () {
    expect(calculator.add("-1,,2"),
        "Error has occurred. Check ErrorLog to see details.");
    expect(ErrorLog.get(ErrorLog.getCount() - 2).message,
        "Number expected but ',' found at position 3.");
    expect(ErrorLog.getLast().message, "Negative not allowed : -1");
  });

  test('handle multiplications', () {
    expect(calculator.multiply("2,2"), "4");
    expect(calculator.multiply("1,,2"),
        "Error has occurred. Check ErrorLog to see details.");
    expect(ErrorLog.getLast().message,
        "Number expected but ',' found at position 2.");
  });
}
