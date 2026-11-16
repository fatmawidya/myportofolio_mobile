import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/validators/education_validators.dart';

void main() {
  test('requires a decimal start year between 1 and 9999', () {
    for (final value in [null, '  ', '0', '10000', '2024.5', '0x7e8']) {
      expect(validateEducationStartYear(value), isNotNull, reason: '$value');
    }
    for (final value in ['1', ' 2024 ', '9999']) {
      expect(validateEducationStartYear(value), isNull, reason: value);
    }
  });

  test('allows an empty end year and rejects an invalid year or order', () {
    for (final value in [null, '  ', '2024', '2027']) {
      expect(validateEducationEndYear(value, startYear: '2024'), isNull);
    }
    for (final value in ['2023', '10000', 'keliru']) {
      expect(validateEducationEndYear(value, startYear: '2024'), isNotNull);
    }
  });

  test('accepts optional HTTP and HTTPS URLs with valid hosts', () {
    for (final value in [
      null,
      '  ',
      ' https://kampus.ac.id/logo.png ',
      'https://xn--bcher-kva.example./logo.png',
      'https://bücher.example/logo.png',
      'http://localhost:8080/logo.png',
      'http://127.0.0.1/logo.png',
      'http://[::1]/logo.png',
    ]) {
      expect(validateEducationLogoUrl(value), isNull, reason: '$value');
    }
  });

  test('rejects malformed URLs and enforces the model length limit', () {
    final base = 'https://example.com/';
    final atLimit = base.padRight(educationLogoUrlMaxLength, 'a');
    expect(validateEducationLogoUrl(atLimit), isNull);

    for (final value in [
      'https://contoh',
      'https://kampus..ac.id/logo.png',
      'https://-kampus.ac.id/logo.png',
      'https://256.0.0.1/logo.png',
      'http://[:::]/logo.png',
      'https://example.com:port/logo.png',
      'https://example.com/logo kampus.png',
      'ftp://example.com/logo.png',
      '${atLimit}a',
    ]) {
      expect(validateEducationLogoUrl(value), isNotNull, reason: value);
    }
  });
}
