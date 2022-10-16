import 'package:chat_app/firebase_helper/UIHelper.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view/screen/complete_profile_page.dart';
import 'package:chat_app/view/screen/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AuthController extends GetxController{

  var isVisibility = true.obs;
  var isLoading = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController nameController = TextEditingController();


  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    confirmPassword.dispose();
    nameController.dispose();
  }

  // signUp for firebase and firebaseforestore

  void sigUp(String email, String password, String cPassword, BuildContext context) async{

    UIHelper.showLoadingDialog(context, 'Sign In....');

    UserCredential? credential;

    try{
     credential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    }on FirebaseAuthException catch (e){
      Navigator.pop(context);
      UIHelper.showAlertDialog(context, 'An occured', e.toString());

    }

    if(credential != null){
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          fullName: '',
          email: email,
          profilePic: ''
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).set(newUser.toMap()).then((value){
        print('new user created');

        Get.to(CompleteProfilePage(userModel: newUser, firebaseUser: credential!.user!,));

      });

    }

  }

  // Login for firebase and data store firebasefirestore

  void login(String email, String password, BuildContext context)async{


    UIHelper.showLoadingDialog(context, 'Logging In....');
    UserCredential? credential;

    try{

      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    }on FirebaseAuthException  catch(e){
      Navigator.pop(context);

      UIHelper.showAlertDialog(context, 'An error occured', e.toString());

    }
    if(credential != null){
      String uid = credential.user!.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return HomePage(userModel: userModel, firebaseUser: credential!.user!);
      }));
    }

  }

  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }


}