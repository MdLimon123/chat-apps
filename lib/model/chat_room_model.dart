class ChatRoomModel{

  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;


  ChatRoomModel({required this.chatRoomId, required this.participants, required this.lastMessage,});


  ChatRoomModel.fromMap(Map<String, dynamic> map){
    chatRoomId= map['chatRoomId'];
    participants = map['participants'];
    lastMessage = map['lastmessage'];

  }

  Map<String, dynamic> toMap(){
    return{
      'chatRoomId':chatRoomId,
      'participants':participants,
      'lastmessage': lastMessage,

    };
  }


}