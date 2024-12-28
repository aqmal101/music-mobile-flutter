import 'package:flutter/material.dart';
import 'package:music_app/components/input_column.dart';
import 'package:music_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person_outline,
                            color: Colors.orange),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.orange),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Colors.orange),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Register Button
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields.'),
                              ),
                            );
                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            final success = await authProvider.register(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _confirmPasswordController.text,
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Registration successful! Please login.'),
                                ),
                              );
                              Navigator.pop(context); // Redirect to login page
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage),
                                ),
                              );
                            }
                          }
                        },
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
                          'Register',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                const SizedBox(height: 20),

                // Footer Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Redirect to login page
                      },
                      child: const Text('Login',
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
