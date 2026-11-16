import 'package:material_ui/material_ui.dart';

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

  static const _degreeOptions = {
    'elementary': 'Elementary School',
    'junior_high': 'Junior High School',
    'high_school': 'High School',
    'bachelor': 'Bachelor Degree',
    'master': 'Master Degree',
    'doctoral': 'Doctoral Degree',
  };

  String _degree = 'bachelor';

  @override
  void dispose() {
    _institutionController.dispose();
    _fieldOfStudyController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showSummary() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
                Text('Institusi: ${_institutionController.text.trim()}'),
                Text('Jenjang: ${_degreeOptions[_degree]}'),
                Text('Jurusan: ${_fieldOfStudyController.text.trim()}'),
                Text('Tahun Masuk: ${_startYearController.text.trim()}'),
                Text(
                  'Tahun Selesai: ${endYear.isEmpty ? 'Belum selesai' : endYear}',
                ),
                Text('URL Logo: ${logoUrl.isEmpty ? 'Tidak diisi' : logoUrl}'),
                Text('Deskripsi: ${_descriptionController.text.trim()}'),
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama institusi tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _degree,
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
                    setState(() {
                      _degree = value;
                    });
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
                  if (value == null || value.trim().isEmpty) {
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
                validator: (value) {
                  final input = value?.trim() ?? '';
                  if (input.isEmpty) {
                    return 'Tahun masuk wajib diisi.';
                  }

                  final year = int.tryParse(input, radix: 10);
                  if (year == null || year < 1 || year > 9999) {
                    return 'Masukkan tahun antara 1 dan 9999.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tahun Selesai (opsional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final input = value?.trim() ?? '';
                  if (input.isEmpty) {
                    return null;
                  }

                  final endYear = int.tryParse(input, radix: 10);
                  if (endYear == null || endYear < 1 || endYear > 9999) {
                    return 'Masukkan tahun antara 1 dan 9999.';
                  }

                  final startYear = int.tryParse(
                    _startYearController.text.trim(),
                    radix: 10,
                  );
                  if (startYear != null && endYear < startYear) {
                    return 'Tahun selesai tidak boleh sebelum tahun masuk.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thumbnailController,
                keyboardType: TextInputType.url,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'URL Logo (opsional)',
                  hintText: 'https://example.com/logo.png',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final input = value?.trim() ?? '';
                  if (input.isEmpty) {
                    return null;
                  }

                  final uri = Uri.tryParse(input);
                  if (uri == null ||
                      (uri.scheme != 'http' && uri.scheme != 'https') ||
                      uri.host.isEmpty ||
                      RegExp(r'\s').hasMatch(input)) {
                    return 'Masukkan URL logo yang valid (HTTP atau HTTPS).';
                  }
                  return null;
                },
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
                  final text = (value ?? '')
                      .replaceAll(RegExp(r'<[^>]+>'), '')
                      .trim();
                  if (text.isEmpty) {
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
