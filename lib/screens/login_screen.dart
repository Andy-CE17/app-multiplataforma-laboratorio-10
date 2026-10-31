import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/nova_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@nova.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _remember = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushReplacementNamed(context, '/browse');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/nova_login_bg.png', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33000000),
                  Color(0x77010A20),
                  Color(0xFF03102A),
                ],
                stops: [0, .45, 1],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 48, 22, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    const NovaLogo(large: true),
                    const SizedBox(height: 26),
                    const Text(
                      'Un universo de\nhistorias te espera',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 35),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                          ? 'Ingresa un correo válido'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Mínimo 6 caracteres'
                          : null,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _remember,
                          onChanged: (value) =>
                              setState(() => _remember = value ?? false),
                        ),
                        const Text(
                          'Recordarme',
                          style: TextStyle(fontSize: 12),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Enlace de recuperación enviado',
                                      ),
                                    ),
                                  ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                              child: const FittedBox(
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GradientButton(
                      label: 'Iniciar sesión',
                      icon: Icons.arrow_forward_rounded,
                      onTap: _login,
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: NovaColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'o continúa con',
                            style: TextStyle(
                              color: NovaColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: NovaColors.border)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          label: 'G',
                          onTap: () => _socialMessage('Google'),
                        ),
                        _SocialButton(
                          label: '●',
                          onTap: () => _socialMessage('Apple'),
                        ),
                        _SocialButton(
                          label: 'f',
                          onTap: () => _socialMessage('Facebook'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xAA102145),
                        border: Border.all(color: NovaColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 12),
                          Text(
                            'Usuario de prueba\nCorreo: demo@nova.com\nContraseña: 123456',
                            style: TextStyle(fontSize: 11, height: 1.45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _socialMessage(String service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inicio con $service disponible próximamente')),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: NovaColors.card,
            border: Border.all(color: NovaColors.border),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
