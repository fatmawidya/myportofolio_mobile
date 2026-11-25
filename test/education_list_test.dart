import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'education_api_test.dart' show educationPayload;

void main() {
  testWidgets('Education list is public and opens every detail field', (
    tester,
  ) async {
    var requests = 0;
    final client = ApiClient(
      client: MockClient((request) async {
        requests++;
        expect(request.url.path, '/api/v1/education/');
        expect(request.headers['Authorization'], isNull);
        return http.Response(jsonEncode([educationPayload]), 200);
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Edukasi'));
    await tester.pumpAndSettle();
    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(requests, 1);
    await tester.tap(find.text('Universitas Indonesia'));
    await tester.pumpAndSettle();
    expect(find.byType(EducationDetailScreen), findsOneWidget);
    for (final text in [
      'ID: education-id',
      'Jenjang: Bachelor Degree (bachelor)',
      'Jurusan: Sistem Informasi',
      'Tahun Masuk: 2025',
      'Tahun Selesai: Belum selesai',
      'Status: Sedang menempuh pendidikan',
      'Jumlah bintang: 2',
      'Ditandai: Tidak',
      'URL Logo: Tidak diisi',
      'Belajar Flutter dan Django',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Education loading, retry and empty refresh work without login', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    var requests = 0;
    final client = ApiClient(
      client: MockClient((_) {
        requests++;
        return requests == 1
            ? pending.future
            : Future.value(http.Response('[]', 200));
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Edukasi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.complete(http.Response('{}', 500));
    await tester.pumpAndSettle();
    expect(find.text('Gagal memuat edukasi. Coba lagi.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada edukasi.'), findsOneWidget);
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(requests, 3);
  });

  testWidgets('Education is reachable from the drawer without login', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 0.7;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final client = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Edukasi'), findsOneWidget);
    expect(find.text('Belum ada edukasi.'), findsOneWidget);
  });
}
