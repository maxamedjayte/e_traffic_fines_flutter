import 'package:e_traffic_fines/theme/colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final bool validatedField;
  final bool readOnly;
  final bool obscureText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  const MyTextField(
      {Key? key,
      this.onTap,
      this.onChanged,
      this.keyboardType,
      this.controller,
      this.hintText,
      this.labelText,
      this.readOnly = false,
      this.validatedField = true,
      this.errorText = 'Cannot be empty',
      this.leadingIcon,
      this.suffixIcon,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: primary,
      readOnly: readOnly,
      obscureText: obscureText,
      style: TextStyle(height: 1),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        focusColor: primary,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: leadingIcon != null ? leadingIcon : null,
        suffixIcon: suffixIcon != null ? suffixIcon : null,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        labelText: labelText,
        errorText: validatedField ? null : errorText,
      ),
    );
  }
}
