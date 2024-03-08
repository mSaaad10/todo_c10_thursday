import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  String lableText;
  Validator? validator;

  TextEditingController? controller;
  int? maxLines;

  CustomTextFormField(
      {required this.lableText,
      this.validator,
      this.controller,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: maxLines,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          labelText: lableText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(26))),
    );
  }
}
