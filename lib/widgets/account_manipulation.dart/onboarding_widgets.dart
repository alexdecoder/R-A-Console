import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Create new customers in the R&A Landscaping + Irrigation customer directory. This information is available to all employees.',
        style: TextStyle(
          color: Colors.white38,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class OnboardingInputField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  OnboardingInputField(
      {required this.title,
      this.controller,
      required this.validator,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      onSaved: onSaved,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      cursorColor: Theme.of(context).primaryColor,
    );
  }
}
