import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? email;
  String? username;
  String? uid;
  String? photoUrl;
  String? city;

  User({
    this.email,
    this.username,
    this.uid,
    this.photoUrl,
    this.city,
  });

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    uid = json['uid'];
    photoUrl = json['photoUrl'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['uid'] = uid;
    data['photoUrl'] = photoUrl;
    data['city'] = city;
    return data;
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot["email"],
      username: snapshot["username"],
      uid: snapshot["uid"],
      photoUrl: snapshot["photoUrl"],
      city: snapshot["city"],
    );
  }
}
