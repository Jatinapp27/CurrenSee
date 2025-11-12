import 'package:currensee_pkr/data/services/auth_service.dart';
import 'package:currensee_pkr/features/auth/screens/register_screen.dart';
import 'package:currensee_pkr/shared_widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Google icon

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();

  bool _loading = false;

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final res = await _auth.signIn(
      email: _email.text,
      password: _password.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (res != "Success") {
      _showSnack(res);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _loading = true);
    final res = await _auth.signInWithGoogle();

    if (!mounted) return;
    setState(() => _loading = false);

    if (res != "Success") _showSnack(res);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(Icons.currency_exchange, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  "Welcome Back to CurrenSee",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                        v != null && v.contains('@') ? null : "Enter valid email",
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (v) =>
                        v != null && v.length >= 6 ? null : "Min 6 characters",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _loading
                    ? const LoadingSpinner(message: "Signing in...")
                    : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loginUser,
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                        onPressed: _googleLogin,
                        label: const Text("Sign in with Google"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text("Don’t have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
