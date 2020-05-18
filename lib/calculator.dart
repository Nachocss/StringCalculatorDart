import 'package:quiver/async.dart';
import 'package:quiver/strings.dart';

class Calculator {
  List<double> nums = new List();
  String defaultSeparators = ",|\n";
  String separators;
  RegExp separatorsRegex;
  RegExp numbersRegex = new RegExp("^[0-9]+");
  RegExp specialCharcatersRegex = new RegExp("[!@#\$%^&*(),.?\":{}|<>]");


  add(String input) {
    nums.clear();
    separators = "";
    if (isEmpty(input)) {
      return "0";
    }

    if (input.contains(new RegExp("//(.|\n)*\n(.)*"))) {
      int indexOfCommandEnd = input.indexOf("\n");
      separators = input.substring(2, indexOfCommandEnd);
      if (separators.contains(specialCharcatersRegex)) {
        separators = "[" + separators + "]";
      }
      input = input.substring(indexOfCommandEnd + 1);
    } else {
      separators = defaultSeparators;
    }
    separatorsRegex = new RegExp(separators);


    var splittedInput = input.split(separatorsRegex);

    var isNumberMissing = 0 !=
        splittedInput
            .where((e) => !e.contains(numbersRegex))
            .toList()
            .length;
    if (isNumberMissing) {
      return "Number expected but EOF found.";
    }

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
