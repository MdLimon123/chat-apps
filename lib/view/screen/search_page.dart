import 'dart:math';

import 'package:chat_app/controller/search_controller.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/view/screen/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/chat_room_model.dart';
import '../../model/user_model.dart';
class SearchPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  SearchPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

 final SearchController _searchController = Get.put(SearchController());


 Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async{

   ChatRoomModel chatRoom;
   
   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('chatrooms').
   where('participants.${userModel.uid}', isEqualTo:true).where('participants.${targetUser.uid}', isEqualTo:true).get();

   if(snapshot.docs.length > 0){


     var docData = snapshot.docs[0].data();
     ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
     chatRoom = existingChatRoom;

   }else{
     ChatRoomModel newChatRoom = ChatRoomModel(
         chatRoomId: uuid.v1(),
         participants: {userModel.uid.toString():true,
         targetUser.uid.toString():true},
         lastMessage: "",
     );
     
     await FirebaseFirestore.instance.collection('chatrooms').doc(newChatRoom.chatRoomId).set(newChatRoom.toMap());

     chatRoom = newChatRoom;

     print('New Chatroom Created');

   }
   return chatRoom;


 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: Obx(
            ()=> Column(
              children: [TextField(
                    controller: _searchController.searchController,
                  onChanged:(value)=> _searchController.filterUser(value),
                  decoration: const InputDecoration(
                      labelText: 'Search people',
                      border: OutlineInputBorder(),
                    ),

                  ),

               SizedBox(height: 4.h,),
               Expanded(
                    child:ListView.separated(
                        itemCount: _searchController.allUserList.length,
                          itemBuilder: (context, int index){

                          return ListTile(
                            onTap: ()async{
                              ChatRoomModel? chatRoomModel = await getChatRoomModel(_searchController.allUserList[index]);

                              if(chatRoomModel != null){

                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatRoomPage(
                                  targetUser:_searchController.allUserList[index],
                                  userModel: userModel,
                                  chatRoom: chatRoomModel,
                                  firebaseUser: firebaseUser,
                                )));

                              }

                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(_searchController.allUserList[index].profilePic.toString()),
                            ),
                            title: Text(_searchController.allUserList[index].fullName.toString()),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          );

                          }, separatorBuilder: (BuildContext context, int index)=> SizedBox(height: 2.h,),
                      ),
                    ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
