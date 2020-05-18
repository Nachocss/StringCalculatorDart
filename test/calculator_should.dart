import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator_java/calculator.dart';

void main() {

  final calculator = Calculator();

  test('return 0', () {
    expect(calculator.add(""), "0");
  });

  
}