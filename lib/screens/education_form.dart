import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/validators/education_validators.dart';
import 'package:myportofolio_mobile/widgets/education_preview_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _degree = ValueNotifier('bachelor');

  late final _previewChanges = Listenable.merge([
    _institutionController,
    _degree,
    _fieldOfStudyController,
    _startYearController,
    _endYearController,
  ]);

  static const _degreeOptions = {
    'elementary': 'Elementary School',
    'junior_high': 'Junior High School',
    'high_school': 'High School',
    'bachelor': 'Bachelor Degree',
    'master': 'Master Degree',
    'doctoral': 'Doctoral Degree',
  };

  static final _htmlTags = RegExp(r'<!--[\s\S]*?-->|</?[a-zA-Z][^>]*>');

  String _plainText(String? value) =>
      (value ?? '').replaceAll(_htmlTags, '').trim();

  @override
  void dispose() {
    _institutionController.dispose();
    _fieldOfStudyController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    _degree.dispose();
    super.dispose();
  }

  void _showSummary() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    final endYear = _endYearController.text.trim();
    final logoUrl = _thumbnailController.text.trim();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ringkasan Edukasi'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${_plainText(_institutionController.text)}'),
                Text('Jenjang: ${_degreeOptions[_degree.value]}'),
                Text('Jurusan: ${_plainText(_fieldOfStudyController.text)}'),
                Text('Tahun Masuk: ${_startYearController.text.trim()}'),
                Text(
                  'Tahun Selesai: ${endYear.isEmpty ? 'Belum selesai' : endYear}',
                ),
                Text('URL Logo: ${logoUrl.isEmpty ? 'Tidak diisi' : logoUrl}'),
                Text('Deskripsi: ${_plainText(_descriptionController.text)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _institutionController,
                maxLength: 255,
                decoration: const InputDecoration(
                  labelText: 'Nama Institusi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_plainText(value).isEmpty) {
                    return 'Nama institusi tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _degree.value,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Jenjang Pendidikan',
                  border: OutlineInputBorder(),
                ),
                items: _degreeOptions.entries.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.key,
                    child: Text(option.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _degree.value = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fieldOfStudyController,
                maxLength: 255,
                decoration: const InputDecoration(
                  labelText: 'Jurusan / Bidang Studi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_plainText(value).isEmpty) {
                    return 'Jurusan atau bidang studi tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tahun Masuk',
                  border: OutlineInputBorder(),
                ),
                validator: validateEducationStartYear,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tahun Selesai (opsional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateEducationEndYear(
                  value,
                  startYear: _startYearController.text,
                ),
              ),
              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: _previewChanges,
                builder: (context, child) => EducationPreviewCard(
                  institution: _plainText(_institutionController.text),
                  degree: _degreeOptions[_degree.value]!,
                  fieldOfStudy: _plainText(_fieldOfStudyController.text),
                  startYear: _startYearController.text.trim(),
                  endYear: _endYearController.text.trim(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thumbnailController,
                keyboardType: TextInputType.url,
                maxLength: educationLogoUrlMaxLength,
                decoration: const InputDecoration(
                  labelText: 'URL Logo (opsional)',
                  hintText: 'https://example.com/logo.png',
                  border: OutlineInputBorder(),
                ),
                validator: validateEducationLogoUrl,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_plainText(value).isEmpty) {
                    return 'Deskripsi wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _showSummary,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
