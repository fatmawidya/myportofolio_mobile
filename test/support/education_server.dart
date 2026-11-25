import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Widgets use the real ApiClient and AuthState with an isolated HTTP server.
class EducationTestServer {
  final requests = <http.Request>[];
  final educations = <Map<String, dynamic>>[];
  int loginCount = 0;
  int? postError;
  bool expireNextPost = false;

  ApiClient get client => ApiClient(client: MockClient(_handle));

  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    if (request.url.path == '/api/v1/auth/token/') {
      loginCount++;
      return http.Response('{"token":"token-$loginCount"}', 200);
    }
    if (request.url.path == '/api/v1/auth/logout/') {
      return http.Response('', 204);
    }
    if (request.url.path == '/api/v1/education/') {
      if (request.method == 'GET') {
        return http.Response(jsonEncode(educations), 200);
      }
      if (request.method == 'POST') {
        if (expireNextPost) {
          expireNextPost = false;
          return http.Response('{}', 401);
        }
        if (postError != null) return http.Response('{}', postError!);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final created = {
          ...body,
          'id': 'education-${educations.length + 1}',
          'degree_display': Education.degrees[body['degree']],
          'is_current': body['end_year'] == null,
          'star_count': 0,
          'is_starred': false,
        };
        educations.add(created);
        return http.Response(jsonEncode(created), 201);
      }
    }
    throw StateError(
      'Unexpected request: ${request.method} ${request.url.path}',
    );
  }
}
