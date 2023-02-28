import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final results = (ArgParser()
    ..addOption('line', abbr: 'l')
    ..addOption('column', abbr: 'c')
    ..addOption('offset', abbr: 'o')
  ).parse(args);

  final path = p.normalize(p.absolute(results.rest.first));
  final content = await File(path).readAsStringSync();
  final parsedContent = parseString(content: content);

  int offset;
  if (results['offset'] != null) {
    offset = int.parse(results['offset']);
  } else {
    int line = int.parse(results['line']) - 1;
    final lineOffset = parsedContent.lineInfo.getOffsetOfLine(line);
    offset = lineOffset + int.parse(results['column']) - 1;
  }

  final visitor = AstLocator(offset);
  parsedContent.unit.visitChildren(visitor);

  File(path).writeAsStringSync(
    content.substring(0, visitor.commaOffset) + ',' + content.substring(visitor.commaOffset)
  );
}

class AstLocator extends GeneralizingAstVisitor {
  int _searchOffset;

  int commaOffset;

  bool _isSearching = true;

  AstLocator(this._searchOffset);

  @override
  void visitNode(AstNode node) {
    if (node.beginToken.offset <= _searchOffset && node.endToken.offset >= _searchOffset) {
      if (node is FormalParameterList) {
        _isSearching = false;
        if (node.parameters.length > 0) {
          final lastParam = node.parameters.last;
          commaOffset = lastParam.endToken.offset + lastParam.endToken.length;
        }
      }

      if (node is ArgumentList) {
        _isSearching = false;
        if (node.arguments.length > 0) {
          final lastParam = node.arguments.last;
          commaOffset = lastParam.endToken.offset + lastParam.endToken.length;
        }
      }
    }

    if (_isSearching) {
      super.visitNode(node);
    }
  }
}