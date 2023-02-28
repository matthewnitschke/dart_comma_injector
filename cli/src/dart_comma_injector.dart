import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

int? findInjectedCommaLocation(String fileContent, {int? offset, int? line, int? column}) {
  final parsedContent = parseString(content: fileContent);

  if (offset == null) {
    final lineOffset = parsedContent.lineInfo.getOffsetOfLine(line! - 1);
    offset = lineOffset + column! - 1;
  }

  final visitor = _AstLocator(offset);
  parsedContent.unit.visitChildren(visitor);

  return visitor.commaOffset;
}


class _AstLocator extends GeneralizingAstVisitor {
  int _searchOffset;

  int? commaOffset;
  int lastRangeLength = 999999;

  _AstLocator(this._searchOffset);

  @override
  void visitNode(AstNode node) {
    if (node.beginToken.offset <= _searchOffset && node.endToken.offset >= _searchOffset) {
      final rangeLength = node.endToken.offset - node.beginToken.offset;
      if (rangeLength < lastRangeLength) {
        lastRangeLength = rangeLength;

        if (node is FormalParameterList) {
          if (node.parameters.length > 0) {
            final lastParam = node.parameters.last;
            commaOffset = lastParam.endToken.offset + lastParam.endToken.length;
          }
        }

        if (node is ArgumentList) {
          if (node.arguments.length > 0) {
            final lastParam = node.arguments.last;
            commaOffset = lastParam.endToken.offset + lastParam.endToken.length;
          }
        }
      }

    }

    super.visitNode(node);
    
  }
}