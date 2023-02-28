import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

int findInjectedCommaLocation(String fileContent, {int offset, int line, int column}) {
  final parsedContent = parseString(content: fileContent);

  int calculatedOffset;
  if (offset == null) {
    final lineOffset = parsedContent.lineInfo.getOffsetOfLine(line - 1);
    calculatedOffset = lineOffset + column - 1;
  }

  final visitor = _AstLocator(calculatedOffset);
  parsedContent.unit.visitChildren(visitor);

  return visitor.commaOffset;
}


class _AstLocator extends GeneralizingAstVisitor {
  int _searchOffset;

  int commaOffset;

  bool _isSearching = true;

  _AstLocator(this._searchOffset);

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