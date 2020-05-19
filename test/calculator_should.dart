import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator_java/calculator.dart';
import 'package:string_calculator_java/error_log.dart';

void main() {
  final calculator = Calculator();

  test('return 0', () {
    expect(calculator.add(""), "0");
  });

  test('return the input value', () {
    expect(calculator.add("1"), "1");
  });

  test('return the sum of 2 given numbers separated by comma', () {
    expect(calculator.add("1.1,2.2"), "3.3");
  });

  test('handle an unknown amount of numbers', () {
    expect(calculator.add("1,2,3"), "6");
    expect(calculator.add("1,3.1"), "4.1");
  });

  test('handle "newlines" as separators', () {
    expect(calculator.add("1\n2"), "3");
  });

  test('not accept EOF', () {
    calculator.add("1,3,");
    expect(ErrorLog.getLast().message, "Number expected but EOF found.");
  });

  test('allow custom separators', () {
    expect(calculator.add("//;\n1;2"), "3");
    expect(calculator.add("//|\n1|2"), "3");
    expect(calculator.add("//*\n1*2"), "3");
    expect(calculator.add("//*|\n1*2|2"), "5");
    expect(calculator.add("//sep\n1sep2"), "3");
    expect(calculator.add("//;\n1;2"), "3");
  });

  test('log negative not allowed error', () {
    calculator.add("-1,2");
    expect(ErrorLog.getLast().message, "Negative not allowed : -1");
    calculator.add("2,-4,-5");
    expect(ErrorLog.getLast().message, "Negative not allowed : -4, -5");
  });

  test('log multiple errors', () {
    calculator.add("-1,,2");
    expect(ErrorLog.get(ErrorLog.getCount() - 2).message,
        "Number expected but ',' found at position 3.");
    expect(ErrorLog.getLast().message, "Negative not allowed : -1");
  });

  test('handle multiplications', () {
    expect(calculator.multiply("2,2"), "4");
  });
}
