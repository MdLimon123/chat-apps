import 'package:chat_app/model/chat_room_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
class ChatRoomPage extends StatelessWidget {

  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  ChatRoomPage({required this.targetUser, required this.userModel, required this.chatRoom, required this.firebaseUser});


  final messageController = TextEditingController();


  // send message
  void sendMessage() async{
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != ""){
      // send message
      MessageModel newMessage = MessageModel(
          sender: userModel.uid,
          text: msg,
          seen: false,
          createdon: DateTime.now(),
          messageId: uuid.v1()
      );

      FirebaseFirestore.instance.collection('chatrooms').doc(chatRoom.chatRoomId).collection('messages').doc(newMessage.messageId).set(newMessage.toMap());

      chatRoom.lastMessage = msg;
      FirebaseFirestore.instance.collection('chatrooms').doc(chatRoom.chatRoomId).set(chatRoom.toMap());
      print('message send');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(targetUser.profilePic.toString()),
            ),
            SizedBox(width: 2.w,),
            Column(
              children: [
                Text(targetUser.fullName.toString()),
                Text('online', style: TextStyle(fontSize: 12.sp),)
              ],
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Container(
          child: Column(
            children: [

              // message body
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('chatrooms').doc(chatRoom.chatRoomId).collection('messages').orderBy('createdon', descending: true).snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.connectionState == ConnectionState.active){

                          if(snapshot.hasData){
                            return ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index){
                                MessageModel currentMessage = MessageModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                                  return Row(
                                    mainAxisAlignment: currentMessage.sender == userModel.uid ? MainAxisAlignment.end: MainAxisAlignment.start ,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 2.w),
                                        padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 3.w),
                                        decoration: BoxDecoration(
                                          color:currentMessage.sender == userModel.uid? Colors.green: Colors.blue,
                                          borderRadius: BorderRadius.circular(2.w)
                                        ),
                                          child: Text(currentMessage.text.toString(), style: TextStyle(color: Colors.white, fontSize: 14.sp),)
                                      ),
                                    ],
                                  );
                                }
                            );

                          }else if(snapshot.hasError){

                            return const Center(
                              child: Text('An error occured! Please check your internet connection.'),
                            );
                          }
                          else{

                            return const Center(
                              child: Text("Say hi to your new friend"),
                            );
                          }

                        }
                        else{
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
              ),


              // type message method
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.w),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          decoration:const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter message'
                          ),
                          
                        )
                    ),
                    IconButton(
                        onPressed: (){
                          sendMessage();
                        },
                        icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary,)
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
