import 'package:flutter/material.dart';

import '../data/movie_repository.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepository.instance;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, child) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Perfil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(Icons.settings_outlined),
                ],
              ),
              const SizedBox(height: 28),
              const Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: NovaColors.cyan,
                      child: CircleAvatar(
                        radius: 57,
                        backgroundImage: AssetImage(
                          'assets/images/piero_avatar.png',
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: NovaColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                repository.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                repository.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: NovaColors.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A4A16), Color(0xFF151247)],
                  ),
                  border: Border.all(color: const Color(0xFFA98739)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.workspace_premium, color: Color(0xFFFFD66B)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NOVA Premium',
                            style: TextStyle(
                              color: Color(0xFFFFD66B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Disfruta de todo el contenido sin límites.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Material(
                color: NovaColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                  side: const BorderSide(color: NovaColors.border),
                ),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.edit_outlined,
                      title: 'Editar perfil',
                      onTap: () => _editProfile(context, repository),
                    ),
                    _ProfileTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Cambiar tema',
                      value: repository.darkMode ? 'Modo oscuro' : 'Modo claro',
                      onTap: () => repository.setDarkMode(!repository.darkMode),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_none),
                      title: const Text(
                        'Notificaciones',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: repository.notificationsEnabled,
                      onChanged: repository.setNotifications,
                    ),
                    _ProfileTile(
                      icon: Icons.tune,
                      title: 'Preferencias de contenido',
                      onTap: () => _message(context, 'Preferencias guardadas'),
                    ),
                    _ProfileTile(
                      icon: Icons.language,
                      title: 'Idioma',
                      value: 'Español',
                      onTap: () => _message(context, 'Idioma: Español'),
                    ),
                    _ProfileTile(
                      icon: Icons.info_outline,
                      title: 'Acerca de la app',
                      value: 'Versión 1.0.0',
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'NOVA STREAM',
                        applicationVersion: '1.0.0',
                        children: const [
                          Text(
                            'This product uses the TMDB API but is not endorsed or certified by TMDB.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: FilledButton.styleFrom(
                  backgroundColor: NovaColors.pink,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile(
    BuildContext context,
    MovieRepository repository,
  ) async {
    final name = TextEditingController(text: repository.userName);
    final email = TextEditingController(text: repository.email);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (saved == true) repository.updateProfile(name.text, email.text);
    name.dispose();
    email.dispose();
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: const TextStyle(color: NovaColors.textMuted, fontSize: 10),
            ),
          const Icon(Icons.chevron_right, size: 19),
        ],
      ),
      onTap: onTap,
    );
  }
}
