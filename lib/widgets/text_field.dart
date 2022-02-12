import 'package:flutter/material.dart';

class VoluntariusTextField extends StatelessWidget {
  final String placeholder;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool obscureText;
  const VoluntariusTextField(this.placeholder,{this.validator, this.controller, this.obscureText = false, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 250,
        child: TextFormField(
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: placeholder,
          ),
        ),
      ),
    );
  }
}