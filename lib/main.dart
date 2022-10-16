
import 'package:chat_app/model/firebase_helper.dart';
import 'package:chat_app/view/screen/homePage.dart';
import 'package:chat_app/view/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import 'model/user_model.dart';


var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  User? currentUser = FirebaseAuth.instance.currentUser;

  if(currentUser !=null){
    // Logged In

    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null){
      runApp( MyAppLoggedIN(userModel: thisUserModel, firebaseUser: currentUser));
    }else{
      runApp(const MyApp());
    }
    
  }else{
    // Not logged In

    runApp(const MyApp());
    
  }


}

// Not Login In

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType){
        return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LoginScreen()
    );
  }
    );
}
}
// Already Login In

class MyAppLoggedIN extends StatelessWidget {

  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIN({super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType){
          return GetMaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(

                primarySwatch: Colors.blue,
              ),
              home:HomePage(userModel: userModel, firebaseUser: firebaseUser,)
          );
        }
    );
  }
}


