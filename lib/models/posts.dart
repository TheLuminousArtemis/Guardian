import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? description;
  String? uid;
  String? username;
  String? postId;
  DateTime? datePublished;
  String? postUrl;
  String? profileImage;
  String? city;

  Post({
    this.description,
    this.uid,
    this.username,
    this.postId,
    this.datePublished,
    this.postUrl,
    this.profileImage,
    this.city,
  });

  Post.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        uid = json['uid'],
        username = json['username'],
        postId = json['postId'],
        datePublished = json['datePublished'],
        postUrl = json['postUrl'],
        profileImage = json['profileImage'],
        city = json['city'];

  Map<String, dynamic> toJson() => {
    'description': description,
    'uid': uid,
    'username': username,
    'postId': postId,
    'datePublished': datePublished,
    'postUrl': postUrl,
    'profileImage': profileImage,
    'city': city,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      city: snapshot['city'],
    );
  }
}
