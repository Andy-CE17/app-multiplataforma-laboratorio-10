import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/movie_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

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
              Center(
                child: InkWell(
                  onTap: () => _editProfile(context, repository),
                  borderRadius: BorderRadius.circular(65),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: NovaColors.cyan,
                        child: UserAvatar(
                          radius: 57,
                          imageBytes: repository.profilePhotoBytes,
                        ),
                      ),
                      const Positioned(
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
    final update = await showDialog<_ProfileUpdate>(
      context: context,
      builder: (context) => _EditProfileDialog(
        initialName: repository.userName,
        initialEmail: repository.email,
        initialPhoto: repository.profilePhotoBytes,
      ),
    );
    if (update == null) return;
    repository.updateProfile(
      update.name,
      update.email,
      photoBytes: update.photoBytes,
    );
    if (context.mounted) _message(context, 'Perfil actualizado correctamente');
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _ProfileUpdate {
  const _ProfileUpdate({
    required this.name,
    required this.email,
    this.photoBytes,
  });

  final String name;
  final String email;
  final Uint8List? photoBytes;
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.initialName,
    required this.initialEmail,
    this.initialPhoto,
  });

  final String initialName;
  final String initialEmail;
  final Uint8List? initialPhoto;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  Uint8List? _photoBytes;
  bool _selectingPhoto = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _photoBytes = widget.initialPhoto;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar perfil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(radius: 48, imageBytes: _photoBytes),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _selectingPhoto ? null : _pickPhoto,
                icon: _selectingPhoto
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.photo_library_outlined),
                label: const Text('Cambiar foto'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa tu nombre'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Ingresa tu correo';
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _pickPhoto() async {
    setState(() => _selectingPhoto = true);
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 900,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photoBytes = bytes);
    } finally {
      if (mounted) setState(() => _selectingPhoto = false);
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      _ProfileUpdate(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        photoBytes: _photoBytes,
      ),
    );
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
