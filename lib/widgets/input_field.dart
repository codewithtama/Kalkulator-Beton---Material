import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? suffixText;
  final String? hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.suffixText,
    this.hintText,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$labelText tidak boleh kosong';
              }
              if (double.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              if (double.parse(value) <= 0) {
                return 'Nilai harus lebih dari 0';
              }
              return null;
            },
        onChanged: onChanged,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
