import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import '../src/dart_comma_injector.dart';

Future<void> main(List<String> args) async {
  final results = (ArgParser()
    ..addOption('line', abbr: 'l')
    ..addOption('column', abbr: 'c')
    ..addOption('offset', abbr: 'o')
  ).parse(args);

  final path = p.normalize(p.absolute(results.rest.first));
  final content = await File(path).readAsStringSync();

  int offset;
  int line;
  int column;
  
  if (results['offset'] != null) {
    offset = int.parse(results['offset']);
  } else {
    line = int.parse(results['line']);
    column = int.parse(results['column']);
  }

  final commaOffset = findInjectedCommaLocation(
    content,
    offset: offset,
    line: line,
    column: column,
  );

  if (commaOffset != null) {
    File(path).writeAsStringSync(
      content.substring(0, commaOffset) + ',' + content.substring(commaOffset)
    );
  }
}
