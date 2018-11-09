// Copyright 2018 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:sass_linter/src/rules/no_condition_parens.dart';
import 'package:sass_linter/src/lint.dart';
import 'package:sass_linter/src/linter.dart';
import 'package:test/test.dart';

final url = 'a.scss';
final rule = new NoConditionParensRule();

void main() {
  test('does not report lint when there are no parens', () {
    var lints = getLints(r'@if 1 != 7 { @debug("quack"); }');

    expect(lints, isEmpty);
  });

  test('reports lint when there is a paren in @if', () {
    var lints = getLints(r'@if (1 != 7) { @debug("quack"); }');

    expect(lints, hasLength(1));

    var lint = lints.single;
    expect(lint.rule, rule);
    expect(lint.message, contains('Parentheses'));
    expect(lint.message, contains('(1 != 7)'));
    expect(lint.message, contains('unnecessary'));
    expect(lint.url, new Uri.file(url));
    expect(lint.line, 0);
    expect(lint.column, 4);
  });

  test('reports lint when there is a paren in @else if', () {
    var lints = getLints(r'@if 1 {} @else if (2 != 3) { @debug("quack"); }');

    expect(lints, hasLength(1));

    var lint = lints.single;
    expect(lint.rule, rule);
    expect(lint.message, contains('Parentheses'));
    expect(lint.message, contains('(2 != 3)'));
    expect(lint.message, contains('unnecessary'));
    expect(lint.url, new Uri.file(url));
    expect(lint.line, 0);
    expect(lint.column, 18);
  });

  test('reports lint when there is a paren in @while', () {
    var lints = getLints(r'@while (2 == 3) { @debug("quack"); }');

    expect(lints, hasLength(1));

    var lint = lints.single;
    expect(lint.rule, rule);
    expect(lint.message, contains('Parentheses'));
    expect(lint.message, contains('(2 == 3)'));
    expect(lint.message, contains('unnecessary'));
    expect(lint.url, new Uri.file(url));
    expect(lint.line, 0);
    expect(lint.column, 18);
  });
}

List<Lint> getLints(String source) =>
    new Linter(source, [rule], url: url).run();
