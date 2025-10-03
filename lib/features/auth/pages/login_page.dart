import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';

// --- Paleta de Colores de Vibra ---
const Color kVibraTurquoise = Color.fromARGB(255, 44, 59, 108);
const Color kVibraPurple = Color(0xFF7B1FA2);
const Color kVibraBackground = Color.fromARGB(255, 26, 92, 192);
const Color kVibraDarkText = Color(0xFF333333);
const Color kVibraSubtleText = Color(0xFF757575);
const Color kVibraBorder = Color.fromARGB(255, 20, 1, 1);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Estado local para la UI
  bool _isLoading = false;
  bool _isLoginPressed = false;
  bool _isGooglePressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmail() {
    if (_isLoading) return;
    context.read<AuthBloc>().add(
          AuthLoginWithEmailPasswordRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }

  void _signInWithGoogle() {
    if (_isLoading) return;
    context.read<AuthBloc>().add(const AuthLoginWithGoogleRequested());
  }

  // --- Widget de Botón Animado Personalizado ---
  Widget _buildAnimatedButton({
    required VoidCallback onTap,
    required bool isPressed,
    required ValueChanged<bool> setPressed,
    required Widget child,
    required Color color,
  }) {
    const duration = Duration(milliseconds: 150);
    return GestureDetector(
      onTapDown: (_) => setPressed(true),
      onTapUp: (_) => setPressed(false),
      onTapCancel: () => setPressed(false),
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPressed
              ? [] // Sin sombra al presionar para efecto de "hundimiento"
              : [
                  BoxShadow(
                    color: color.withAlpha(77),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        transform: isPressed ? Matrix4.diagonal3Values(0.96, 0.96, 1.0) : Matrix4.identity(),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Actualiza el estado de carga local basado en el AuthBloc
        setState(() {
          _isLoading = (state is AuthLoading);
        });

        if (state is Authenticated) {
          Navigator.of(context).pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: kVibraBackground,
        appBar: AppBar(
          title: const Text('Iniciar Sesión', style: TextStyle(color: kVibraDarkText)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: kVibraDarkText),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Campos de Texto Estilizados ---
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined, color: kVibraSubtleText),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kVibraBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kVibraBorder),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline, color: kVibraSubtleText),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kVibraBorder),
                      ),
                       enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kVibraBorder),
                      ),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signInWithEmail(),
                  ),
                  const SizedBox(height: 32),

                  // --- Botón de Email Animado ---
                  _buildAnimatedButton(
                    onTap: _isLoading ? () {} : _signInWithEmail,
                    isPressed: _isLoginPressed,
                    setPressed: (pressed) => setState(() => _isLoginPressed = pressed),
                    color: kVibraTurquoise,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Iniciar Sesión',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: kVibraBorder)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('O', style: TextStyle(color: kVibraSubtleText)),
                      ),
                      Expanded(child: Divider(color: kVibraBorder)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Botón de Google Animado ---
                  _buildAnimatedButton(
                    onTap: _isLoading ? () {} : _signInWithGoogle,
                    isPressed: _isGooglePressed,
                    setPressed: (pressed) => setState(() => _isGooglePressed = pressed),
                    color: Colors.white,
                    child: const Text(
                      'Continuar con Google',
                      style: TextStyle(fontSize: 16, color: kVibraDarkText, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
