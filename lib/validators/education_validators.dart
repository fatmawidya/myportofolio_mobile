const educationLogoUrlMaxLength = 200;

const _yearRangeError = 'Masukkan tahun antara 1 dan 9999.';
const _logoUrlError = 'Masukkan URL logo yang valid (HTTP atau HTTPS).';

final _logoUrl = RegExp(
  r'^https?://(?:[^\s:@/?#]+(?::[^\s:@/?#]*)?@)?'
  r'(\[[a-f0-9:.]+\]|[^:/?#\s]+)(?::[0-9]{1,5})?(?:[/?#]\S*)?$',
  caseSensitive: false,
);
final _domain = RegExp(
  r'^(?:[a-z0-9\u00a1-\uffff](?:[a-z0-9\u00a1-\uffff-]{0,61}'
  r'[a-z0-9\u00a1-\uffff])?\.)+'
  r'(?:[a-z\u00a1-\uffff][a-z\u00a1-\uffff-]{0,61}'
  r'[a-z\u00a1-\uffff]|xn--[a-z0-9]{1,59})\.?$',
  caseSensitive: false,
);
const _ipv4Octet = r'(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])';
final _ipv4 = RegExp('^$_ipv4Octet(?:\\.$_ipv4Octet){3}\$');

String? validateEducationStartYear(String? value) {
  final input = value?.trim() ?? '';
  if (input.isEmpty) {
    return 'Tahun masuk wajib diisi.';
  }
  return _parseYear(input) == null ? _yearRangeError : null;
}

String? validateEducationEndYear(String? value, {required String startYear}) {
  final input = value?.trim() ?? '';
  if (input.isEmpty) {
    return null;
  }

  final end = _parseYear(input);
  if (end == null) {
    return _yearRangeError;
  }

  final start = _parseYear(startYear.trim());
  if (start != null && end < start) {
    return 'Tahun selesai tidak boleh sebelum tahun masuk.';
  }
  return null;
}

String? validateEducationLogoUrl(String? value) {
  final input = value?.trim() ?? '';
  if (input.isEmpty) {
    return null;
  }
  if (input.runes.length > educationLogoUrlMaxLength) {
    return 'URL logo tidak boleh lebih dari $educationLogoUrlMaxLength karakter.';
  }

  final host = _logoUrl.firstMatch(input)?.group(1);
  return host != null && _isValidHost(host) ? null : _logoUrlError;
}

int? _parseYear(String input) {
  final year = int.tryParse(input, radix: 10);
  return year != null && year >= 1 && year <= 9999 ? year : null;
}

bool _isValidHost(String host) {
  // Django accepts domains, IP literals, and localhost as URL hosts.
  if (_domain.hasMatch(host) ||
      _ipv4.hasMatch(host) ||
      host.toLowerCase() == 'localhost') {
    return true;
  }
  return host.startsWith('[') && Uri.tryParse('http://$host') != null;
}
