import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,  
      child: VxTextField(
        controller: controller,
        hint: hint,
        fillColor: Colors.transparent,
        borderColor: Colors.blue,
        borderType: VxTextFieldBorderType.underLine,
        keyboardType: keyboardType,
      ),
    );
  }
}
