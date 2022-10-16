import 'package:chat_app/controller/authController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  String text;
  IconData icon;
  CustomTextField({
    super.key,required this.text,
    required this.icon
  });

  final AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.w),
      child: TextField(
        controller: _authController.emailController,
        decoration: InputDecoration(
            labelText: text,
            border: const OutlineInputBorder(),

            prefixIcon: Icon(icon)
        ),
      ),
    );
  }
}