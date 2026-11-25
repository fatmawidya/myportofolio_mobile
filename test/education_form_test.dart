import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/widgets/education_preview_card.dart';

import 'support/education_server.dart';

Future<void> login(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'owner');
  await tester.enterText(fields.at(1), 'password');
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

Future<void> fill(WidgetTester tester, int index, String value) async {
  final field = find.byType(TextFormField).at(index);
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> fillRequired(WidgetTester tester) async {
  await fill(tester, 0, 'Universitas Indonesia');
  await fill(tester, 1, 'Sistem Informasi');
  await fill(tester, 2, '2025');
  await fill(tester, 5, 'Belajar pengembangan aplikasi');
}

Future<void> save(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  final button = find.widgetWithText(ElevatedButton, 'Simpan');
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Mobile education validates, previews, posts and opens saved data',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 720);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final server = EducationTestServer();
      await tester.pumpWidget(MyApp(apiClient: server.client));
      final card = find.text('Tambah Edukasi');
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsNothing);
      await login(tester);

      final preview = find.byType(EducationPreviewCard);
      Finder previewText(String value) =>
          find.descendant(of: preview, matching: find.text(value));
      expect(previewText('Nama institusi belum diisi'), findsOneWidget);
      await fill(tester, 0, '   ');
      await save(tester);
      expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
      expect(server.educations, isEmpty);
      await fillRequired(tester);
      expect(previewText('Bachelor Degree · Sistem Informasi'), findsOneWidget);
      expect(previewText('Sedang menempuh pendidikan'), findsOneWidget);

      FocusManager.instance.primaryFocus?.unfocus();
      final degree = find.byType(DropdownButton<String>);
      await tester.ensureVisible(degree);
      await tester.pumpAndSettle();
      await tester.tap(degree);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Master Degree').last);
      await tester.pumpAndSettle();
      expect(previewText('Master Degree · Sistem Informasi'), findsOneWidget);

      await fill(tester, 3, '2024');
      await fill(tester, 4, 'https://contoh');
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      addTearDown(tester.view.resetViewInsets);
      await save(tester);
      expect(
        find.text('Tahun selesai tidak boleh sebelum tahun masuk.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
      expect(server.educations, isEmpty);

      tester.view.resetViewInsets();
      await fill(tester, 3, '2027');
      await fill(tester, 4, 'https://example.com/logo.png');
      await save(tester);
      expect(find.text('Edukasi berhasil ditambahkan!'), findsOneWidget);
      for (final text in [
        'Institusi: Universitas Indonesia',
        'Jenjang: Master Degree',
        'Jurusan: Sistem Informasi',
        'Tahun Masuk: 2025',
        'Tahun Selesai: 2027',
        'URL Logo: https://example.com/logo.png',
        'Deskripsi: Belajar pengembangan aplikasi',
      ]) {
        expect(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text(text),
          ),
          findsOneWidget,
        );
      }
      final post = server.requests.singleWhere(
        (r) => r.method == 'POST' && r.url.path == '/api/v1/education/',
      );
      expect(post.headers['Authorization'], 'Token token-1');
      expect(jsonDecode(post.body)['end_year'], 2027);
      await tester.tap(find.text('Lihat Daftar'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationListScreen), findsOneWidget);
      expect(find.text('Universitas Indonesia'), findsOneWidget);
    },
  );

  testWidgets('Drawer requires education login and Home returns to menu', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 0.7;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final server = EducationTestServer();
    await tester.pumpWidget(MyApp(apiClient: server.client));
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    await login(tester);
    expect(find.byType(EducationFormPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets(
    'Saving from the list refreshes once and sends optional null years',
    (tester) async {
      final server = EducationTestServer();
      await tester.pumpWidget(MyApp(apiClient: server.client));
      await tester.tap(find.text('Lihat Edukasi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tambah Edukasi'));
      await tester.pumpAndSettle();
      await login(tester);
      await fillRequired(tester);
      await save(tester);
      expect(find.text('Tahun Selesai: Belum selesai'), findsOneWidget);
      expect(find.text('URL Logo: Tidak diisi'), findsOneWidget);
      await tester.tap(find.text('Lihat Daftar'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationListScreen), findsOneWidget);
      expect(find.text('Universitas Indonesia'), findsOneWidget);
      expect(server.educations.single['end_year'], isNull);
      expect(server.requests.where((r) => r.method == 'GET').length, 2);
    },
  );

  for (final status in [400, 403]) {
    testWidgets('Education POST $status keeps input and permits retry', (
      tester,
    ) async {
      final server = EducationTestServer()..postError = status;
      await tester.pumpWidget(MyApp(apiClient: server.client));
      await tester.tap(find.text('Tambah Edukasi'));
      await tester.pumpAndSettle();
      await login(tester);
      await fillRequired(tester);
      await save(tester);
      expect(find.byType(AlertDialog), findsNothing);
      expect(server.educations, isEmpty);
      expect(find.text('Universitas Indonesia'), findsWidgets);
      expect(
        find.text(
          status == 403
              ? 'Akun ini tidak memiliki izin menambah edukasi.'
              : 'Gagal menyimpan edukasi (HTTP 400).',
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Simpan'),
            )
            .onPressed,
        isNotNull,
      );
    });
  }

  testWidgets(
    'Education 401 clears the session and uses a new token after login',
    (tester) async {
      final server = EducationTestServer()..expireNextPost = true;
      await tester.pumpWidget(MyApp(apiClient: server.client));
      await tester.tap(find.text('Tambah Edukasi'));
      await tester.pumpAndSettle();
      await login(tester);
      await fillRequired(tester);
      await save(tester);
      expect(server.educations, isEmpty);
      expect(find.byType(AlertDialog), findsNothing);
      await login(tester);
      expect(find.text('Universitas Indonesia'), findsWidgets);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await save(tester);
      final posts = server.requests
          .where(
            (r) => r.method == 'POST' && r.url.path == '/api/v1/education/',
          )
          .toList();
      expect(posts.length, 2);
      expect(posts.first.headers['Authorization'], 'Token token-1');
      expect(posts.last.headers['Authorization'], 'Token token-2');
      expect(
        server.requests.any((r) => r.url.path == '/api/v1/auth/logout/'),
        isTrue,
      );
      expect(find.text('Edukasi berhasil ditambahkan!'), findsOneWidget);
      expect(server.educations.length, 1);
    },
  );
}
