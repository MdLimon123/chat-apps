class UserModel{
  String? uid;
  String? fullName;
  String? email;
  String? profilePic;

  UserModel({required this.uid, required this.fullName, required this.email, required this.profilePic});


  UserModel.fromMap(Map<String, dynamic> map){
    uid = map['uid'];
    fullName= map['fullName'];
    email = map['email'];
    profilePic = map['profilePic'];
  }

  Map<String, dynamic> toMap(){
    return{
      "uid":uid,
      "fullName":fullName,
      "email":email,
      "profilePic":profilePic
    };
  }

}