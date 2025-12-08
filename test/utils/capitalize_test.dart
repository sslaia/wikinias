import 'package:flutter_test/flutter_test.dart';
import 'package:wikinias/utils/capitalize.dart';

void main() {
  group('StringExtension', () {
    test('capitalize capitalizes the first letter of a string', () {
      expect('hello'.capitalize(), 'Hello');
      expect('world'.capitalize(), 'World');
    });

    test('capitalize keeps already capitalized string as is', () {
      expect('Hello'.capitalize(), 'Hello');
      expect('World'.capitalize(), 'World');
    });

    test('capitalize handles mixed case strings correctly', () {
      // "hELLO" -> "H" + "ELLO" -> "HELLO"
      expect('hELLO'.capitalize(), 'HELLO');
      // "wORLD" -> "W" + "ORLD" -> "WORLD"
      expect('wORLD'.capitalize(), 'WORLD');
    });

    test('capitalize handles single letter strings correctly', () {
      expect('a'.capitalize(), 'A');
      expect('A'.capitalize(), 'A');
    });

    test('capitalize throws RangeError on empty string', () {
       expect(() => ''.capitalize(), throwsRangeError);
    });
  });
}
