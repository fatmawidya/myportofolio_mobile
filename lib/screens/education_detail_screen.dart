import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({required this.education, super.key});

  final Education education;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.institution,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SelectableText('ID: ${education.id ?? 'Belum tersedia'}'),
            const SizedBox(height: 8),
            Text('Jenjang: ${education.degreeLabel} (${education.degree})'),
            const SizedBox(height: 8),
            Text('Jurusan: ${education.fieldOfStudy}'),
            const SizedBox(height: 8),
            Text('Tahun Masuk: ${education.startYear}'),
            const SizedBox(height: 8),
            Text('Tahun Selesai: ${education.endYear ?? 'Belum selesai'}'),
            const SizedBox(height: 8),
            Text(
              'Status: ${education.isCurrent ? 'Sedang menempuh pendidikan' : 'Selesai'}',
            ),
            const SizedBox(height: 8),
            Text('Jumlah bintang: ${education.starCount}'),
            const SizedBox(height: 8),
            Text('Ditandai: ${education.isStarred ? 'Ya' : 'Tidak'}'),
            const SizedBox(height: 8),
            SelectableText(
              'URL Logo: ${education.thumbnail.isEmpty ? 'Tidak diisi' : education.thumbnail}',
            ),
            if (education.thumbnail.isNotEmpty) ...[
              const SizedBox(height: 16),
              Image.network(
                education.thumbnail,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Logo institusi tidak dapat dimuat.'),
              ),
            ],
            const SizedBox(height: 16),
            Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(education.description),
          ],
        ),
      ),
    );
  }
}
