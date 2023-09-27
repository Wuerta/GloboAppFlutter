import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _loadingCreateAccount = false;

  Future<void> _validateCreateAccountFields() async {
    if (_loadingCreateAccount) return;
    setState(() => _loadingCreateAccount = true);

    if (_formKey.currentState!.validate()) return _createAccount();

    setState(() => _loadingCreateAccount = false);
  }

  Future<void> _createAccount() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final auth = FirebaseAuth.instance;

    try {
      final credentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credentials.user!.updateDisplayName(name);

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1200),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          content: Text(
            'Conta criada com sucesso!',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      const errorMessage = 'Ocorreu um erro ao criar a conta, tente novamente';

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

    setState(() => _loadingCreateAccount = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Preencha os dados e descubra\nlugares incríveis!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Nome'),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('E-mail'),
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
                    label: const Text('Senha'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_showPassword,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Confirmar senha'),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (_) => _validateCreateAccountFields(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }

                    final password = _passwordController.text;
                    if (value != password) return 'As senhas não condizem';

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _loadingCreateAccount
                        ? null
                        : _validateCreateAccountFields,
                    child: const Text('Criar conta'),
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
