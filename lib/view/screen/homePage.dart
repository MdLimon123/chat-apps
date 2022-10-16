import 'package:chat_app/controller/authController.dart';
import 'package:chat_app/firebase_helper/UIHelper.dart';
import 'package:chat_app/firebase_helper/firebase_helper.dart';
import 'package:chat_app/model/chat_room_model.dart';
import 'package:chat_app/view/screen/chat_room_page.dart';
import 'package:chat_app/view/screen/search_page.dart';
import 'package:chat_app/view/screen/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/user_model.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

 final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat app'),
        centerTitle: true,
        actions: [
            InkWell(
              onTap: (){
                _authController.signOut();
                Get.to(SignUpScreen());
              },
              child: Image.asset('asstes/image/log_out.png',
        height: 10.h,width: 10.w,color: Colors.white,),
            )
        ],
      ),
      body: SafeArea(
        child:Container(
        child:StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chatrooms").where("participants.${userModel.uid}", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active) {
            if(snapshot.hasData) {
              QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

              return ListView.builder(
                itemCount: chatRoomSnapshot.docs.length,
                itemBuilder: (context, index) {
                  ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                  Map<String, dynamic> participants = chatRoomModel.participants!;

                  List<String> participantKeys = participants.keys.toList();
                  participantKeys.remove(userModel.uid);

                  return FutureBuilder(
                    future: FirebaseHelper.getUserModel(participantKeys[0]),
                    builder: (context, userData) {
                      if(userData.connectionState == ConnectionState.done) {
                        if(userData.data != null) {
                          UserModel targetUser = userData.data as UserModel;

                          return ListTile(
                            onTap: (){
                              Navigator.popUntil(context, (route) => route.isFirst);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> ChatRoomPage(
                                  targetUser: targetUser,
                                  userModel: userModel,
                                  chatRoom: chatRoomModel,
                                  firebaseUser: firebaseUser
                              )));
                            },

                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(targetUser.profilePic.toString()),
                            ),
                            title: Text(targetUser.fullName.toString()),
                            subtitle: (chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString()) : Text("Say hi to your new friend!", style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),),
                          );
                        }
                        else {
                          return Container();
                        }
                      }
                      else {
                        return Container();
                      }
                    },
                  );
                },
              );
            }
            else if(snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            else {
              return Center(
                child: Text("No Chats"),
              );
            }
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){



          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SearchPage(userModel: userModel, firebaseUser: firebaseUser);
          }));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
