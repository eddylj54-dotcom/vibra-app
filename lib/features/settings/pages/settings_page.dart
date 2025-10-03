import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibra/core/theme/theme_notifier.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/profile/pages/edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context, 'Cuenta'),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Editar Perfil'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
          ),
          _buildSectionTitle(context, 'Apariencia'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Modo Oscuro'),
            value: themeNotifier.isDarkMode,
            onChanged: (value) {
              themeNotifier.toggleTheme();
            },
          ),
          _buildSectionTitle(context, 'Acerca de'),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('Políticas de Privacidad'),
            onTap: () => _launchURL('https://www.google.com/policies/privacy/'), // Reemplaza con tu URL
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Términos de Servicio'),
            onTap: () => _launchURL('https://www.google.com/terms/'), // Reemplaza con tu URL
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versión'),
            subtitle: Text(_appVersion),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
    );
  }

  Padding _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
