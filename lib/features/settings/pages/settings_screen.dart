import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibra/core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _reminders = true;
  bool _passcodeEnabled = false;
  bool _faceIdEnabled = false;

  // late AnimationController _glowAnimController;

  @override
  void initState() {
    super.initState();
    // _glowAnimController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // )..repeat(reverse: true);
  }

  @override
  void dispose() {
    // _glowAnimController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Cerrar sesión'),
            onPressed: () {
              // Aquí iría la lógica para cerrar sesión
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Eliminar'),
            onPressed: () {
              // Aquí iría la lógica para eliminar la cuenta
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark();
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('Configuración', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fondo con gradiente y orbes
          _buildBackground(colors),
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSection(
                    title: 'Notificaciones',
                    colors: colors,
                    items: [
                      _buildSwitchItem(
                        title: 'Recordatorios',
                        subtitle: 'Recibe notificaciones de transmisiones',
                        icon: FontAwesomeIcons.bell,
                        value: _reminders,
                        onChanged: (val) => setState(() => _reminders = val),
                        colors: colors,
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Seguridad',
                    colors: colors,
                    items: [
                      _buildSwitchItem(
                        title: 'Bloquear con código',
                        subtitle: 'Protege tu cuenta con un código',
                        icon: FontAwesomeIcons.lock,
                        value: _passcodeEnabled,
                        onChanged: (val) => setState(() => _passcodeEnabled = val),
                        colors: colors,
                      ),
                      _buildSwitchItem(
                        title: 'Bloquear con Face ID',
                        subtitle: 'Usa Face ID para desbloquear',
                        icon: FontAwesomeIcons.fingerprint,
                        value: _faceIdEnabled,
                        onChanged: (val) => setState(() => _faceIdEnabled = val),
                        colors: colors,
                        hasBorder: false,
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Legal',
                    colors: colors,
                    items: [
                      _buildNavigationItem(
                        title: 'Términos de servicio',
                        icon: FontAwesomeIcons.fileLines,
                        onTap: () {},
                        colors: colors,
                      ),
                      _buildNavigationItem(
                        title: 'Política de privacidad',
                        icon: FontAwesomeIcons.shieldHalved,
                        onTap: () {},
                        colors: colors,
                        hasBorder: false,
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Cuenta',
                    colors: colors,
                    items: [
                      _buildNavigationItem(
                        title: 'Cerrar sesión',
                        icon: FontAwesomeIcons.rightFromBracket,
                        onTap: _showLogoutDialog,
                        colors: colors,
                      ),
                      _buildNavigationItem(
                        title: 'Eliminar cuenta',
                        subtitle: 'Esta acción es permanente',
                        icon: FontAwesomeIcons.trash,
                        onTap: _showDeleteAccountDialog,
                        colors: colors,
                        isDanger: true,
                        hasBorder: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFooter(colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(AppColorPalette colors) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.background, colors.surface, colors.background],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // FadeTransition(
        //   opacity: _glowAnimController.drive(CurveTween(curve: Curves.easeInOut)),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: RadialGradient(
        //         center: const Alignment(-1.5, -0.8),
        //         radius: 1.5,
        //         colors: [colors.primary.withAlpha(77), Colors.transparent],
        //       ),
        //     ),
        //   ),
        // ),
        // FadeTransition(
        //   opacity: _glowAnimController.drive(CurveTween(curve: Curves.easeInOut)),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: RadialGradient(
        //         center: const Alignment(1.5, 0.8),
        //         radius: 1.5,
        //         colors: [colors.secondary.withAlpha(77), Colors.transparent],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
    required AppColorPalette colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.primary.withAlpha(204),
              letterSpacing: 1,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface.withAlpha(150), // Fondo semi-transparente
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.primary.withAlpha(51)),
            ),
            child: Column(children: items),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSwitchItem({
    required String title,
    String? subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppColorPalette colors,
    bool hasBorder = true,
  }) {
    return _buildSettingItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      colors: colors,
      hasBorder: hasBorder,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: colors.primary,
        inactiveTrackColor: colors.surface,
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required AppColorPalette colors,
    bool isDanger = false,
    bool hasBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: _buildSettingItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
        colors: colors,
        isDanger: isDanger,
        hasBorder: hasBorder,
        trailing: Icon(FontAwesomeIcons.chevronRight, size: 16, color: isDanger ? colors.error : colors.textGrey.withAlpha(128)),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    required IconData icon,
    required Widget trailing,
    required AppColorPalette colors,
    bool isDanger = false,
    bool hasBorder = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: hasBorder
            ? Border(bottom: BorderSide(color: colors.primary.withAlpha(26)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isDanger ? colors.error : colors.primary).withAlpha(38),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, size: 20, color: isDanger ? colors.error : colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDanger ? colors.error : colors.textDark,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: colors.textGrey.withAlpha(179),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildFooter(AppColorPalette colors) {
    return Column(
      children: [
        Text(
          'KymBta v1.0.0',
          style: GoogleFonts.poppins(fontSize: 14, color: colors.textGrey.withAlpha(179)),
        ),
        const SizedBox(height: 4),
        Text(
          'Hecho con ❤️ para Cuba',
          style: GoogleFonts.poppins(fontSize: 12, color: colors.textGrey.withAlpha(128)),
        ),
      ],
    );
  }
}