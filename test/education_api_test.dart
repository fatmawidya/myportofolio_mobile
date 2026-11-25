import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const educationPayload = <String, dynamic>{
  'id': 'education-id',
  'institution': 'Universitas Indonesia',
  'degree': 'bachelor',
  'degree_display': 'Bachelor Degree',
  'field_of_study': 'Sistem Informasi',
  'start_year': 2025,
  'end_year': null,
  'thumbnail': null,
  'description': 'Belajar Flutter dan Django',
  'is_current': true,
  'star_count': 2,
  'is_starred': false,
};

void main() {
  test(
    'Education preserves optional fields and excludes server-owned data',
    () {
      final education = Education.fromJson(educationPayload);
      expect(education.thumbnail, '');
      expect(education.endYear, isNull);
      expect(education.degreeLabel, 'Bachelor Degree');
      expect(education.isCurrent, isTrue);
      expect(education.starCount, 2);
      expect(education.toJson(), {
        'institution': 'Universitas Indonesia',
        'degree': 'bachelor',
        'field_of_study': 'Sistem Informasi',
        'start_year': 2025,
        'end_year': null,
        'thumbnail': '',
        'description': 'Belajar Flutter dan Django',
      });
    },
  );

  test('Public education GET decodes UTF-8 without sending a token', () async {
    final client = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/education/');
        expect(request.headers['Authorization'], isNull);
        return http.Response.bytes(
          utf8.encode(
            jsonEncode([
              {...educationPayload, 'institution': 'Université Indonesia'},
            ]),
          ),
          200,
        );
      }),
    );
    final educations = await client.getEducations();
    expect(educations.single.institution, 'Université Indonesia');
  });

  test(
    'Education POST sends a token and numeric years, excluding the id',
    () async {
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/v1/education/');
          expect(request.headers['Authorization'], 'Token owner-token');
          expect(request.headers['Content-Type'], contains('application/json'));
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['start_year'], 2025);
          expect(body['end_year'], isNull);
          expect(body.containsKey('id'), isFalse);
          expect(body.containsKey('degree_display'), isFalse);
          return http.Response(jsonEncode(educationPayload), 201);
        }),
      );
      final created = await client.createEducation(
        Education.fromJson(educationPayload),
        token: 'owner-token',
      );
      expect(created.id, 'education-id');
    },
  );

  test(
    'Education HTTP failures throw ApiException with their status',
    () async {
      for (final status in [400, 401, 403, 500]) {
        final client = ApiClient(
          client: MockClient((_) async => http.Response('{}', status)),
        );
        final matcher = isA<ApiException>().having(
          (error) => error.statusCode,
          'statusCode',
          status,
        );
        await expectLater(client.getEducations(), throwsA(matcher));
        await expectLater(
          client.createEducation(
            Education.fromJson(educationPayload),
            token: 'token',
          ),
          throwsA(matcher),
        );
      }
    },
  );
}
