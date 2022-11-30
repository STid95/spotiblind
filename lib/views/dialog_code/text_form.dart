import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    Key? key,
    required this.formKey,
    required this.codeController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: codeController,
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'Veuillez entrer au moins 4 chiffres';
            }
            return null;
          },
          keyboardType: TextInputType.phone,
        ),
      ),
    );
  }
}
