import 'package:firebase_auth/firebase_auth.dart';

class UserModal {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  UserModal({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  factory UserModal.fromFirebase(User user) {
    return UserModal(
      uid: user.uid,
      displayName: user.displayName ?? "",
      email: user.email ?? "",
      photoUrl: user.photoURL ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory UserModal.fromMap(Map<String, dynamic> map) {
    return UserModal(
      uid: map['uid'],
      displayName: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }
}
