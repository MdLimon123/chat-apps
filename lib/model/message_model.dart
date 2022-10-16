class MessageModel{
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({required this.sender, required this.text, required this.seen, required this.createdon, required this.messageId});


  MessageModel.fromMap(Map<String, dynamic> map){
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdon = map['createdon'].toDate();
    messageId = map['messageId'];
  }

  Map<String, dynamic> toMap(){
    return{
      "sender":sender,
      "text":text,
      "seen":seen,
      "createdon":createdon,
      "messageId":messageId
    };
  }

}