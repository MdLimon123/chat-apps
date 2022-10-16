import 'package:chat_app/controller/authController.dart';
import 'package:chat_app/view/screen/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../widget/customTextField.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);



  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    height: 30.h,
                    width: 180.w,
                    decoration: const BoxDecoration(
                     image: DecorationImage(
                        image: AssetImage('asstes/image/login.png')
                      )
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Text('Welcome to Login', style: TextStyle(fontSize: 15.sp, color: Color(0xFFF85100), fontWeight: FontWeight.bold),),
                  SizedBox(height: 2.h,),
                  CustomTextField(
                    text: 'Email',
                      icon: Icons.email,
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.w),
                    child: Obx(
                      ()=> TextField(
                        controller: _authController.passwordController,
                        obscureText: _authController.isVisibility.value,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            fillColor: const Color(0xFFFEE4D8),
                            prefixIcon:const Icon(Icons.lock),
                            suffixIcon: InkWell(
                              onTap: (){
                                _authController.isVisibility.value = !_authController.isVisibility.value;
                              },
                                child: Icon(_authController.isVisibility.value?Icons.visibility_off:Icons.visibility))
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  InkWell(
                    onTap: (){
                      _authController.login(
                          _authController.emailController.text.trim(),
                          _authController.passwordController.text.trim(),
                        context

                      );
                    },
                    child: Container(
                      height: 8.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF85100),
                        borderRadius: BorderRadius.circular(8.w)
                      ),
                      child: Center(child: Text('Login', style: TextStyle(fontSize: 18.sp, color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold),)),
                    ),
                  ),
                  SizedBox(height: 3.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(fontSize: 15.sp, color: const Color(0xFF007B87)),),
                      CupertinoButton(
                          child: Text('Sign Up', style: TextStyle(fontSize:15.sp, color: const Color(0xFFC84100) ),),
                          onPressed: (){
                            Get.to(SignUpScreen());
                          }
                      )
                    ],
                  )

                ],
              )
            ],
          )
      ),
    );
  }
}


