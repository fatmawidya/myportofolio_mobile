import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/validators/education_validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/education_preview_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({this.returnToList = false, super.key});

  final bool returnToList;

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
  bool _isSubmitting = false;

  late final _previewChanges = Listenable.merge([
    _institutionController,
    _degree,
    _fieldOfStudyController,
    _startYearController,
    _endYearController,
  ]);

  static const _degreeOptions = Education.degrees;

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

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = context.read<AuthState>().token;
      if (token == null) return;
      final education = Education(
        institution: _plainText(_institutionController.text),
        degree: _degree.value,
        fieldOfStudy: _plainText(_fieldOfStudyController.text),
        startYear: int.parse(_startYearController.text.trim()),
        endYear: _endYearController.text.trim().isEmpty
            ? null
            : int.parse(_endYearController.text.trim()),
        thumbnail: _thumbnailController.text.trim(),
        description: _plainText(_descriptionController.text),
      );
      final created = await context.read<ApiClient>().createEducation(
        education,
        token: token,
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      await _showConfirmation(created);
      if (!mounted) return;
      if (widget.returnToList) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EducationListScreen()),
        );
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          // AuthState clears the local session even if logout is unreachable.
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi berakhir. Silakan login kembali.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.statusCode == 403
                  ? 'Akun ini tidak memiliki izin menambah edukasi.'
                  : 'Gagal menyimpan edukasi (HTTP ${error.statusCode}).',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat menghubungi server. Coba lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showConfirmation(Education education) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edukasi berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${education.institution}'),
                Text('Jenjang: ${education.degreeLabel}'),
                Text('Jurusan: ${education.fieldOfStudy}'),
                Text('Tahun Masuk: ${education.startYear}'),
                Text('Tahun Selesai: ${education.endYear ?? 'Belum selesai'}'),
                Text(
                  'URL Logo: ${education.thumbnail.isEmpty ? 'Tidak diisi' : education.thumbnail}',
                ),
                Text('Deskripsi: ${education.description}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Lihat Daftar'),
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
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
