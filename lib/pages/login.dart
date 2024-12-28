import 'package:flutter/material.dart';
import 'package:music_app/components/input_column.dart';
import 'package:music_app/pages/base.dart';
import 'package:music_app/pages/register.dart';
import 'package:music_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final loginProvider = Provider.of<AuthProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and password cannot be empty')),
      );
      return;
    }

    final success = await loginProvider.login(email, password);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BasePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginProvider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Let\'s Listen to Music',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: Colors.orange),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                  isPasswordField: true,
                ),

                const SizedBox(height: 30),

                // Login Button
                loginProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const BasePage()));
                        // },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Pill shape
                          ),
                          backgroundColor: Colors.orange,
                          minimumSize: const Size.fromHeight(50), // Full width
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 20),

                // Footer Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text('Register',
                          style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
