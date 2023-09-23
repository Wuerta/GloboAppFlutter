import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globoapp/constants/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _loadingAuthentication = false;

  void _validateLoginFields() {
    if (_loadingAuthentication) return;
    setState(() => _loadingAuthentication = true);

    if (_formKey.currentState!.validate()) _login();
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final auth = FirebaseAuth.instance;

    try {
      final credentials = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(credentials.user!.uid);
    } catch (_) {
      if (!mounted) return;
      const errorMessage = 'Ocorreu um erro ao autenticar, tente novamente';

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            errorMessage,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      );
    }

    setState(() => _loadingAuthentication = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(logoImage, height: 170),
                const SizedBox(height: 8),
                Text(
                  'GloboApp',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'E-mail',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }

                    if (!EmailValidator.validate(value)) {
                      return 'E-mail inválido';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_showPassword,
                  onFieldSubmitted: (_) => _validateLoginFields(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed:
                        _loadingAuthentication ? null : _validateLoginFields,
                    child: const Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
