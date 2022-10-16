import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FirebaseHelper{

  static Future<UserModel?> getUserModel(String uid) async{
    UserModel? userModel;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(documentSnapshot.data() !=null){
      userModel = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);

      return userModel;
    }

  }

}