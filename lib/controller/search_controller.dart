import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {

  TextEditingController searchController = TextEditingController();
  var userList = <UserModel>[].obs;
  var isLoading = false.obs;
  var allUserList = <UserModel>[].obs;


  @override
  void onInit() {
    super.onInit();

    getData();
    allUserList.value = userList;
  }

  getData() async {
    isLoading.value = true;

    User? user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        userList.clear();
        value.docs.forEach((word) {
          if (word['uid'] != user!.uid) {
            userList.add(UserModel(
                uid: word['uid'],
                fullName: word['fullName'],
                email: word['email'],
                profilePic: word ['profilePic']
            ));
          }
        });
      }).catchError((error) {
        isLoading.value = false;
      });
    } on Exception catch (e) {
      isLoading.value = false;
      print('Error');
    }
    finally{
      allUserList.value = userList;
      print(allUserList.value.length);
      isLoading.value = false;
    }
  }

  void filterUser(String userName) {
    List<UserModel> result = <UserModel>[].obs;

    if (userName.isEmpty) {
      result = userList;
    } else {
      result = userList.where((element) =>
          element.fullName.toString().toLowerCase().contains(
              userName.toLowerCase())).toList();
      allUserList.value = result;
    }
  }
}