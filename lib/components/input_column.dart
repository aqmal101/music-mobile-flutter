import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon prefixIcon;
  final bool
      isPasswordField; // Menambahkan parameter untuk menentukan apakah ini field password

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.isPasswordField = false, // Default false jika bukan field password
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Menyembunyikan password secara default

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPasswordField
          ? _obscureText
          : false, // Hanya menyembunyikan jika ini password field
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[800],
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.orange,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle visibility
                  });
                },
              )
            : null, // Menampilkan icon hanya pada field password
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
