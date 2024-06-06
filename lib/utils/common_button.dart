import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          42,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            11,
          ),
        ),
      ),
      child: title.text
          .color(Colors.white)
          .size(16)
          .fontWeight(FontWeight.w700)
          .make(),
    );
  }
}
