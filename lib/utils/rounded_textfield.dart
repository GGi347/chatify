import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String hint;
  bool obscureText;
  TextInputType inputType;
  RoundedTextField({required this.hint, required this.onChanged, required this.obscureText, required this.inputType});
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      obscureText: obscureText,
      keyboardType: inputType,
      onChanged: (value) => {onChanged(value)},
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),

      ),
    );
  }
}
