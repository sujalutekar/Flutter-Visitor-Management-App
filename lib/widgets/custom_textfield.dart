import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    required this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLength = 700,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          TextField(
            maxLength: maxLength,
            controller: controller,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0).copyWith(left: 4),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
          ),
        ],
      ),
    );
  }
}
