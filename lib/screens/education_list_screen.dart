import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  late Future<List<Education>> _educationsFuture;

  @override
  void initState() {
    super.initState();
    _educationsFuture = context.read<ApiClient>().getEducations();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getEducations();
    setState(() {
      _educationsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder displays failures from both retry and pull-to-refresh.
    }
  }

  Future<void> _addEducation() async {
    if (!await ensureLoggedIn(context) || !mounted) return;
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const EducationFormPage(returnToList: true),
      ),
    );
    if (created == true && mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEducation,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Edukasi'),
      ),
      body: FutureBuilder<List<Education>>(
        future: _educationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Gagal memuat edukasi. Coba lagi.'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          final educations = snapshot.data ?? const <Education>[];
          return RefreshIndicator(
            onRefresh: _reload,
            child: educations.isEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: const Center(child: Text('Belum ada edukasi.')),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
                    itemCount: educations.length,
                    itemBuilder: (context, index) {
                      final education = educations[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.school_outlined),
                          title: Text(education.institution),
                          subtitle: Text(
                            '${education.degreeLabel} · ${education.fieldOfStudy}\n'
                            '${education.startYear}–${education.endYear ?? 'Sekarang'}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EducationDetailScreen(education: education),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
