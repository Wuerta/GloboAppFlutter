import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globoapp/constants/assets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _loadingRecoveryPasword = false;
  bool _showRecoveryPasswordMessage = false;

  Future<void> _validateEmailField() async {
    if (_loadingRecoveryPasword) return;
    setState(() => _loadingRecoveryPasword = true);

    if (_formKey.currentState!.validate()) {
      return _sendRecoveryPasswordEmail();
    }

    setState(() => _loadingRecoveryPasword = false);
  }

  Future<void> _sendRecoveryPasswordEmail() async {
    final email = _emailController.text;
    final auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      setState(() => _showRecoveryPasswordMessage = true);
    } catch (_) {
      if (!mounted) return;

      const errorMessage =
          'Ocorreu um erro ao tentar recuperar sua senha. Tente novamente.';

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

    setState(() => _loadingRecoveryPasword = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esqueci minha senha'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Builder(
            builder: (context) {
              if (_showRecoveryPasswordMessage) {
                return Column(
                  children: [
                    Text(
                      'Tudo certo!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SvgPicture.asset(emailImage, height: 320),
                    const SizedBox(height: 8),
                    Text(
                      'Enviaremos um link para recuperação de senha no seu e-mail!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Voltar'),
                      ),
                    ),
                  ],
                );
              }

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Informe o seu email para a recuperação de senha',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        label: Text('E-mail'),
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (_) => _validateEmailField(),
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
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: _loadingRecoveryPasword
                            ? null
                            : _validateEmailField,
                        child: const Text('Enviar email'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
