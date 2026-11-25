import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  testWidgets('Project retry and empty refresh complete without state errors', (
    tester,
  ) async {
    var requests = 0;
    final client = ApiClient(
      client: MockClient((_) async {
        requests++;
        return http.Response(
          requests == 1 ? '{}' : '[]',
          requests == 1 ? 500 : 200,
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No projects found.'), findsOneWidget);
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(requests, 3);
  });

  test('Project serialization excludes id and handles a missing image', () {
    final project = Project.fromJson({
      'id': 'project-id',
      'title': 'Portfolio',
      'description': 'My project',
      'tech_stack': 'Flutter',
      'project_url': 'https://example.com',
      'project_image_url': null,
    });
    expect(project.projectImageUrl, '');
    expect(project.toJson().containsKey('id'), isFalse);
    expect(project.toJson()['tech_stack'], 'Flutter');
  });

  test('AuthState clears its local token if logout is rejected', () async {
    final client = ApiClient(
      client: MockClient((request) async => http.Response('', 401)),
    );
    final auth = AuthState(client, initialToken: 'expired');
    await auth.logout();
    expect(auth.isLoggedIn, isFalse);
    auth.dispose();
  });

  testWidgets('Public projects open their detail without login', (
    tester,
  ) async {
    final client = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['Authorization'], isNull);
        return http.Response(
          jsonEncode([
            {
              'id': '1',
              'title': 'Portfolio',
              'description': 'My project',
              'tech_stack': 'Flutter',
              'project_url': 'https://example.com',
            },
          ]),
          200,
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Portfolio'), findsOneWidget);
    await tester.tap(find.text('Portfolio'));
    await tester.pumpAndSettle();
    expect(find.text('Tech Stack: Flutter'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Add Project requires login, posts JSON and resets on success', (
    tester,
  ) async {
    final requests = <http.Request>[];
    final client = ApiClient(
      client: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/v1/auth/token/') {
          expect(jsonDecode(request.body), {
            'username': 'owner',
            'password': 'password',
          });
          return http.Response('{"token":"test-token"}', 200);
        }
        expect(request.url.path, '/api/v1/projects/');
        expect(request.method, 'POST');
        expect(request.headers['Authorization'], 'Token test-token');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body.containsKey('id'), isFalse);
        return http.Response(jsonEncode({...body, 'id': '1'}), 201);
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Add Project Form'), findsNothing);

    var fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'owner');
    await tester.enterText(fields.at(1), 'password');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);

    final save = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(requests.length, 1);

    fields = find.byType(TextFormField);
    final values = [
      'Portfolio Flutter',
      'My portfolio',
      'Flutter, Django',
      'https://example.com',
      '',
    ];
    for (var index = 0; index < values.length; index++) {
      await tester.ensureVisible(fields.at(index));
      await tester.pumpAndSettle();
      await tester.enterText(fields.at(index), values[index]);
    }
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Title: Portfolio Flutter'), findsOneWidget);
    expect(requests.length, 2);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Portfolio Flutter'), findsNothing);
  });

  testWidgets('Drawer rejects invalid login and allows cancelling the guard', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 0.7;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    var loginRequests = 0;
    final client = ApiClient(
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/auth/token/');
        loginRequests++;
        return http.Response(
          '{"non_field_errors":["Invalid credentials"]}',
          400,
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    final login = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(login);
    await tester.pumpAndSettle();
    expect(loginRequests, 0);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'owner');
    await tester.enterText(fields.at(1), 'wrong-password');
    await tester.tap(login);
    await tester.pumpAndSettle();
    expect(loginRequests, 1);
    expect(find.text('Login gagal (HTTP 400).'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Add Project Form'), findsNothing);
    expect(tester.widget<ElevatedButton>(login).onPressed, isNotNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('Add Project Form'), findsNothing);
  });

  testWidgets('Expired token requests login again and preserves the project', (
    tester,
  ) async {
    var loginRequests = 0;
    var projectRequests = 0;
    final client = ApiClient(
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          loginRequests++;
          return http.Response('{"token":"token-$loginRequests"}', 200);
        }
        if (request.url.path == '/api/v1/auth/logout/') {
          expect(request.headers['Authorization'], 'Token token-1');
          return http.Response('', 401);
        }
        expect(request.url.path, '/api/v1/projects/');
        expect(request.method, 'POST');
        projectRequests++;
        expect(
          request.headers['Authorization'],
          'Token token-$projectRequests',
        );
        if (projectRequests == 1) return http.Response('', 401);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['title'], 'Project retained');
        return http.Response(jsonEncode({...body, 'id': '1'}), 201);
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    Future<void> login() async {
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'owner');
      await tester.enterText(fields.at(1), 'password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
    }

    await login();
    final fields = find.byType(TextFormField);
    final values = [
      'Project retained',
      'Keep this description',
      'Flutter',
      'https://example.com',
      '',
    ];
    for (var index = 0; index < values.length; index++) {
      await tester.ensureVisible(fields.at(index));
      await tester.pumpAndSettle();
      await tester.enterText(fields.at(index), values[index]);
    }
    final save = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(projectRequests, 1);
    expect(find.byType(AlertDialog), findsNothing);

    await login();
    expect(find.text('Project retained'), findsOneWidget);
    expect(find.text('Keep this description'), findsOneWidget);
    // Allow the session-expired SnackBar to leave the bottom of the form.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(loginRequests, 2);
    expect(projectRequests, 2);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
  });
}
