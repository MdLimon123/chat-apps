import 'dart:developer';
import 'dart:io';


import 'package:chat_app/controller/profile_controller.dart';
import 'package:chat_app/firebase_helper/UIHelper.dart';
import 'package:chat_app/view/screen/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/user_model.dart';
class CompleteProfilePage extends StatelessWidget {
   CompleteProfilePage({Key? key, required this.userModel,required this.firebaseUser }) : super(key: key);
    final UserModel userModel;
    final User firebaseUser;

  final ProfileController _profileController = Get.put(ProfileController());


   void checkValues(BuildContext context){
     String fullName =_profileController. fullNameController.text.trim();
     
     if(fullName == "" || _profileController.imageFile.value == null){
       print('Please fill all the fields');
       UIHelper.showAlertDialog(context, 'Incomplete Data', 'Please fill all the fields and upload a profile picture');
     }else{

       uploadData(context);
       log('data uploading');
     }
   }

   // upload image and full name for firebase firestorage

   void uploadData(BuildContext context) async{

     UIHelper.showLoadingDialog(context, 'Uploading image...');

     UploadTask uploadTask = FirebaseStorage.instance.ref('profilepictures').child(userModel.uid.toString()).putFile(File(_profileController.imageFile.value));

     TaskSnapshot taskSnapshot = await uploadTask;

     String? imageUrl = await taskSnapshot.ref.getDownloadURL();
     String? fullName =_profileController. fullNameController.text.trim();

     userModel.fullName = fullName;
     userModel.profilePic = imageUrl;

     await FirebaseFirestore.instance.collection('users').doc(userModel.uid).set(userModel.toMap()).then((value){
       log('data uploaded');
       Navigator.popUntil(context, (route) => route.isFirst);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
         return HomePage(userModel: userModel, firebaseUser: firebaseUser);
       }));

     });


   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Complete Profile', style: TextStyle(fontSize: 18.sp, color: const Color(0xFFFFFFFF)),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          ()=> ListView(
            children: [
              SizedBox(height: 8.h,),
              CupertinoButton(
                onPressed: (){
                  // showPhotoOption
                  _profileController.showPhotoOption(context);

                },
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  radius: 15.w,
                  backgroundImage:(_profileController.imageFile.value !=null)? FileImage(File(_profileController.imageFile.value)):null,
                  child:(_profileController.imageFile.value == null)? Icon(Icons.person,
                  size: 20.w,):null,
                ),
              ),
              SizedBox(height: 3.h,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                child:  TextField(
                  controller:_profileController.fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    fillColor: Color(0xFFFEE4D8),
                    filled: true
                  ),
                ),
              ),
              SizedBox(height: 3.h,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                child: InkWell(
                  onTap: (){

                    checkValues(context);

                  },
                  child: Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF85100),
                        borderRadius: BorderRadius.circular(8.w)
                    ),
                    child: Center(child: Text('Submit', style: TextStyle(fontSize: 18.sp, color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
