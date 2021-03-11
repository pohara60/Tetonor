import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:Tetonor/Tetonor.dart';

var cells1 = [
  36,
  42,
  27,
  180,
  140,
  33,
  245,
  30,
  13,
  224,
  27,
  54,
  272,
  15,
  72,
  36
];
var operands1 = [3, 0, 6, 6, 7, 7, 9, 0, 14, 0, 16, 0, 0, 24, 0, 0];
var cells2 = [
  40,
  300,
  95,
  256,
  400,
  40,
  364,
  32,
  56,
  384,
  40,
  175,
  231,
  24,
  135,
  40
];
var operands2 = [0, 5, 0, 7, 0, 0, 16, 0, 0, 20, 20, 0, 0, 0, 0, 0];
// var cells2 = [];
// var operands2 = [];

const help = 'help';
const program = 'tetonor';

void main(List<String> arguments) {
  exitCode = 0; // presume success

  var runner = CommandRunner('tetonor', 'Tetonor solver.')
    ..addCommand(SolveCommand());
  try {
    runner.run(arguments);
  } on UsageException catch (e) {
    // Arguments exception
    print('$program: ${e.message}');
    print('');
    print('${runner.usage}');
  }
}

class SolveCommand extends Command {
  @override
  final name = 'solve';
  @override
  final description =
      'Solve puzzle specifieid by <cells> and <operands>, which are strings with a list of 16 numbers. Operands may include 0 for undetermined values.';

  SolveCommand() {}

  @override
  void run() {
    // Arguments may specify cells and operands
    Tetonor tetonor;
    var numArgs = argResults.rest.length;
    if (numArgs == 0) {
      tetonor = Tetonor(cells2, operands2);
    } else {
      if (numArgs == 2) {
        var cellString = argResults.rest[0];
        var operandString = argResults.rest[1];
        var cellList =
            cellString.split(',').map((s) => int.tryParse(s)).toList();
        var operandList =
            operandString.split(',').map((s) => int.tryParse(s)).toList();
        if (cellList.length != 16 ||
            cellList.contains(null) ||
            operandList.length != 16 ||
            operandList.contains(null)) {
          print('$program: Error in <cells> or <operands>');
          print(
              'Cells[${cellList.length}]=$cellList\nOperands[${operandList.length}]=$operandList');
          print('');
          print('${runner.usage}');
          exitCode = 1;
          return;
        }
        tetonor = Tetonor(cellList, operandList);
      }
    }
    print('$tetonor\n');
    tetonor.solve();
    // for (var word in argResults.rest) {
    // }
  }
}
