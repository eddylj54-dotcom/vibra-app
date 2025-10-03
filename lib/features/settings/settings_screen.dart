import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibra/core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  bool reminders = true;
  bool passcodeEnabled = false;
  bool faceIdEnabled = false;

  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _glowAnimation =
        Tween<double>(begin: 0.15, end: 0.4).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Lógica para eliminar cuenta
              Navigator.of(context).pop();
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: AppColors.dark().error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Lógica para cerrar sesión
              Navigator.of(context).pop();
            },
            child: Text(
              'Cerrar sesión',
              style: TextStyle(color: AppColors.dark().error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.background, colors.surface, colors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Positioned(
                  top: -50,
                  right: -80,
                  child: Opacity(
                    opacity: _glowAnimation.value,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 100,
                  left: -100,
                  child: Opacity(
                    opacity: _glowAnimation.value,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.secondary,
                      ),
                    ),
                  ),
                );
              },
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Notificaciones', colors),
                  _buildSettingsCard(
                    colors,
                    [
                      _buildSwitchSettingItem(
                        icon: FontAwesomeIcons.bell,
                        title: 'Recordatorios',
                        description: 'Recibe notificaciones de transmisiones',
                        value: reminders,
                        onChanged: (val) => setState(() => reminders = val),
                        colors: colors,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Seguridad', colors),
                  _buildSettingsCard(
                    colors,
                    [
                      _buildSwitchSettingItem(
                        icon: FontAwesomeIcons.lock,
                        title: 'Bloquear con código',
                        description: 'Protege tu cuenta con un código',
                        value: passcodeEnabled,
                        onChanged: (val) =>
                            setState(() => passcodeEnabled = val),
                        colors: colors,
                      ),
                      _buildSwitchSettingItem(
                        icon: FontAwesomeIcons.fingerprint,
                        title: 'Bloquear con Face ID',
                        description: 'Usa Face ID para desbloquear',
                        value: faceIdEnabled,
                        onChanged: (val) => setState(() => faceIdEnabled = val),
                        colors: colors,
                        noBorder: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Legal', colors),
                  _buildSettingsCard(
                    colors,
                    [
                      _buildNavigationSettingItem(
                        icon: FontAwesomeIcons.fileLines,
                        title: 'Términos de servicio',
                        onTap: () {},
                        colors: colors,
                      ),
                      _buildNavigationSettingItem(
                        icon: FontAwesomeIcons.shieldHalved,
                        title: 'Política de privacidad',
                        onTap: () {},
                        colors: colors,
                        noBorder: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Cuenta', colors),
                  _buildSettingsCard(
                    colors,
                    [
                      _buildNavigationSettingItem(
                        icon: FontAwesomeIcons.rightFromBracket,
                        title: 'Cerrar sesión',
                        description: 'Salir de tu cuenta',
                        onTap: _handleLogout,
                        colors: colors,
                      ),
                      _buildNavigationSettingItem(
                        icon: FontAwesomeIcons.trash,
                        title: 'Eliminar cuenta',
                        description: 'Esta acción es permanente',
                        onTap: _handleDeleteAccount,
                        colors: colors,
                        isDanger: true,
                        noBorder: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text('Vibra v1.0.0',
                            style: TextStyle(color: colors.textGrey)),
                        const SizedBox(height: 4),
                        Text('Hecho con ❤️ para Cuba',
                            style: TextStyle(color: colors.surface)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorPalette colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colors.primary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(AppColorPalette colors, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(51),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.primaryDark.withAlpha(128)),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildSwitchSettingItem({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppColorPalette colors,
    bool noBorder = false,
  }) {
    return _buildSettingItem(
      noBorder: noBorder,
      colors: colors,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildSettingInfo(
              icon: icon,
              title: title,
              description: description,
              colors: colors,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.primary,
            inactiveTrackColor: colors.surface,
            thumbColor: WidgetStateProperty.all(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSettingItem({
    required IconData icon,
    required String title,
    String? description,
    required VoidCallback onTap,
    required AppColorPalette colors,
    bool isDanger = false,
    bool noBorder = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: _buildSettingItem(
        noBorder: noBorder,
        colors: colors,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildSettingInfo(
                icon: icon,
                title: title,
                description: description,
                colors: colors,
                isDanger: isDanger,
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: isDanger ? colors.error : colors.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required Widget child,
    required AppColorPalette colors,
    bool noBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: noBorder
            ? null
            : Border(
                bottom: BorderSide(color: colors.surface.withAlpha(128)),
              ),
      ),
      child: child,
    );
  }

  Widget _buildSettingInfo({
    required IconData icon,
    required String title,
    String? description,
    required AppColorPalette colors,
    bool isDanger = false,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDanger
                ? colors.error.withAlpha(38)
                : colors.primary.withAlpha(38),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 22, color: isDanger ? colors.error : colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDanger ? colors.error : colors.textDark,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textGrey,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
