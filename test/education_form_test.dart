import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/widgets/education_preview_card.dart';

void main() {
  testWidgets('Updates the preview and validates before saving on mobile', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 720);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);

    final educationCard = find.text('Tambah Edukasi');
    await tester.ensureVisible(educationCard);
    await tester.pumpAndSettle();
    await tester.tap(educationCard);
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);

    final preview = find.byType(EducationPreviewCard);
    Finder previewText(String text) =>
        find.descendant(of: preview, matching: find.text(text));

    final fields = find.byType(TextFormField);
    Future<void> fill(int index, String value) async {
      await tester.ensureVisible(fields.at(index));
      await tester.pumpAndSettle();
      await tester.enterText(fields.at(index), value);
      await tester.pumpAndSettle();
    }

    Future<void> save() async {
      final button = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    expect(previewText('Nama institusi belum diisi'), findsOneWidget);
    await fill(0, '   ');
    await save();
    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await fill(0, 'Universitas Indonesia');
    await fill(1, 'Sistem Informasi');
    await fill(2, '2024');
    expect(previewText('Universitas Indonesia'), findsOneWidget);
    expect(previewText('Bachelor Degree · Sistem Informasi'), findsOneWidget);
    expect(previewText('Sejak 2024'), findsOneWidget);
    expect(previewText('Sedang menempuh pendidikan'), findsOneWidget);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final selectedDegree = find.byType(DropdownButton<String>);
    await tester.ensureVisible(selectedDegree);
    await tester.pumpAndSettle();
    await tester.tap(selectedDegree);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Master Degree').last);
    await tester.pumpAndSettle();
    expect(previewText('Master Degree · Sistem Informasi'), findsOneWidget);

    await fill(3, '2023');
    await fill(4, 'https://contoh');
    await fill(5, 'Belajar pengembangan aplikasi');
    tester.view.viewInsets = const FakeViewPadding(bottom: 240);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await save();
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      find.text('Tahun selesai tidak boleh sebelum tahun masuk.'),
      findsOneWidget,
    );
    expect(
      find.text('Masukkan URL logo yang valid (HTTP atau HTTPS).'),
      findsOneWidget,
    );

    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    await fill(3, '2027');
    await fill(4, 'https://example.com/logo.png');
    expect(previewText('2024–2027'), findsOneWidget);
    expect(previewText('Sedang menempuh pendidikan'), findsNothing);

    await save();
    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    for (final line in [
      'Institusi: Universitas Indonesia',
      'Jenjang: Master Degree',
      'Jurusan: Sistem Informasi',
      'Tahun Masuk: 2024',
      'Tahun Selesai: 2027',
      'URL Logo: https://example.com/logo.png',
      'Deskripsi: Belajar pengembangan aplikasi',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(line)),
        findsOneWidget,
      );
    }

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
    expect(previewText('Universitas Indonesia'), findsOneWidget);

    await fill(3, '');
    await fill(4, '');
    await save();
    expect(find.text('Tahun Selesai: Belum selesai'), findsOneWidget);
    expect(find.text('URL Logo: Tidak diisi'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('Opens Education from the drawer and returns via Home', (
    tester,
  ) async {
    // The bundled Ahem test font is wider than the app's default font.
    tester.platformDispatcher.textScaleFactorTestValue = 0.7;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.byType(EducationFormPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.byType(EducationFormPage), findsNothing);
  });
}
