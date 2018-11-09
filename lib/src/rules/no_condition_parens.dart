// Copyright 2018 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// The sass package's API is not necessarily stable. It is being imported with
// the Sass team's explicit knowledge and approval. See
// https://github.com/sass/dart-sass/issues/236.
import 'package:sass/src/ast/sass.dart';

import '../lint.dart';
import '../rule.dart';

/// A lint rule that reports unnecessary parentheses in conditionals.
///
/// Sometimes users who are familiar with other languages forget that Sass
/// doesn't need parentheses around its conditionals  (as in, `@if (...) {`, or
/// `@else if (...) {`, or `@while (...) {`). This rule suggests removing these
/// parentheses.
class NoConditionParensRule extends Rule {
  NoConditionParensRule() : super('no_condition_parens_rule');

  @override
  List<Lint> visitIfRule(IfRule node) {
    var lint = <Lint>[];
    for (var clause in node.clauses) {
      if (clause.expression is ParenthesizedExpression) {
        lint.add(Lint(
            rule: this,
            span: clause.expression.span,
            message:
                'Parentheses around ${clause.expression.span.text} are unnecessary'));
      }
    }
    return lint..addAll(super.visitIfRule(node));
  }

  @override
  List<Lint> visitWhileRule(WhileRule node) {
    var lint = <Lint>[];
    if (node.condition is ParenthesizedExpression) {
      lint.add(Lint(
          rule: this,
          span: node.condition.span,
          message:
              'Parentheses around ${node.condition.span.text} are unnecessary'));
    }
    return lint..addAll(super.visitWhileRule(node));
  }
}
