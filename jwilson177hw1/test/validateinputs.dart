import 'package:flutter_test/flutter_test.dart';
import 'package:jwilson177hw1/screens/authenticate/sign_in.dart';
import 'package:jwilson177hw1/screens/home/profile.dart';

void main() {
  test('empty email returns error string', () {
    final result = EmailFieldValidator.validate('');
    expect(result, 'cannot email leave empty');
  });

  test('non-empty email returns null', () {
    final result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', () {
    final result = PWFieldValidator.validate('');
    expect(result, 'cannot PW leave empty');
  });

  test('non-empty password returns null', () {
    final result = PWFieldValidator.validate('password');
    expect(result, null);
  });
}
