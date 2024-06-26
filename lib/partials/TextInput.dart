import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/Validador.dart';

class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double width;
  TextInputFormatter? formatter;
  int maxLength = 20;

  TextInput(
      {super.key,
      required this.label,
      required this.controller,
      required this.width,
      this.formatter,
      this.maxLength = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        style: const TextStyle(fontSize: 16),
        maxLength: maxLength,
        textCapitalization: TextCapitalization.characters,
        controller: controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 14),
          label: Text(label),
          hintText: label,
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        validator: (value) => Validador().add(Validar.OBRIGATORIO).validar(value),
        inputFormatters: (formatter != null) ? [formatter!] : [],
      ),
    );
  }
}
