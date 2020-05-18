import 'package:quiver/async.dart';
import 'package:quiver/strings.dart';

class Calculator {

  List<double> nums = new List();
  RegExp defaultSeparators = new RegExp(",|\n");

  add(String input) {
    nums.clear();
    if (isEmpty(input)) {
      return "0";
    }

    var splittedInput = input.split(defaultSeparators);

    for (String value in splittedInput) {
      nums.add(double.parse(value));
    }

    var result = nums.reduce((a, b) => a + b);

    if (result == result.roundToDouble()) {
      return result.toInt().toString();
    }

    return result.toStringAsFixed(1);
  }

}