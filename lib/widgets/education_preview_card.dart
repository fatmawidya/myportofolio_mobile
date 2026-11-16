import 'package:material_ui/material_ui.dart';

class EducationPreviewCard extends StatelessWidget {
  const EducationPreviewCard({
    super.key,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    required this.endYear,
  });

  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startYear;
  final String endYear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final foreground = colors.onSecondaryContainer;

    return Card(
      margin: EdgeInsets.zero,
      color: colors.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school_outlined, color: foreground),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pratinjau Edukasi',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              institution.isEmpty ? 'Nama institusi belum diisi' : institution,
              style: theme.textTheme.titleMedium?.copyWith(color: foreground),
            ),
            Text(
              fieldOfStudy.isEmpty ? degree : '$degree · $fieldOfStudy',
              style: TextStyle(color: foreground),
            ),
            const SizedBox(height: 8),
            Text(
              startYear.isEmpty
                  ? 'Tahun masuk belum diisi'
                  : endYear.isEmpty
                  ? 'Sejak $startYear'
                  : '$startYear–$endYear',
              style: TextStyle(color: foreground),
            ),
            if (startYear.isNotEmpty && endYear.isEmpty)
              Text(
                'Sedang menempuh pendidikan',
                style: theme.textTheme.labelLarge?.copyWith(color: foreground),
              ),
          ],
        ),
      ),
    );
  }
}
