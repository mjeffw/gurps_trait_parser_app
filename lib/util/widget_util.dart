import 'package:flutter/material.dart';

TextField buildTextField(
    {TextEditingController controller,
    bool enabled,
    int maxLines,
    String helperText,
    String labelText}) {  
  return TextField(
    enabled: enabled,
    maxLines: maxLines ?? 5,
    controller: controller,
    decoration: InputDecoration(
        helperText: helperText, labelText: labelText ?? 'Trait Description'),
  );
}
