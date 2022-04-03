class UserModel {
  String? uid;
  String? email;
  String? userName;

  UserModel({this.uid, this.email, this.userName});

  //data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],

    );
  }

  //envoyer la data a notre serveur

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,

    };
  }
  }