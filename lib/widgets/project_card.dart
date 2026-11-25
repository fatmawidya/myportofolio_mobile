import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          if (item.name == "Lihat Edukasi") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EducationListScreen()),
            );
            return;
          }
          if (item.name == "Lihat Proyek") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProjectListScreen(),
              ),
            );
            return;
          }
          if (item.name == "Logout") {
            final auth = context.read<AuthState>();
            if (!auth.isLoggedIn) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Kamu belum login.')),
              );
              return;
            }
            try {
              await auth.logout();
              messenger.showSnackBar(
                const SnackBar(content: Text('Logout berhasil.')),
              );
            } catch (_) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Sesi lokal ditutup. Server tidak terhubung.'),
                ),
              );
            }
            return;
          }
          if (item.name == "Tambah Edukasi") {
            messenger.removeCurrentSnackBar();
            if (!await ensureLoggedIn(context) || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EducationFormPage(),
              ),
            );
            return;
          }

          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );

          // Navigate ke halaman yang sesuai
          if (item.name == "Tambah Proyek") {
            if (!await ensureLoggedIn(context) || !context.mounted) return;
            messenger.removeCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
