import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/enum_auth.dart';
import '../models/pet.dart';

class UserDetail {
  final String uid;
  final String? name;
  final String? nickName;
  final String email;
  final String usertype;
  final String? homeBackgroundImagePath;
  final String? vetCertificate;

  UserDetail({
    required this.uid,
    this.name,
    this.nickName,
    required this.email,
    required this.usertype,
    this.homeBackgroundImagePath,
    this.vetCertificate,
  });

  factory UserDetail.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDetail(
      uid: data?['uid'],
      name: data?['name'],
      nickName: data?['nickName'],
      email: data?['email'],
      usertype: data?['usertype'],
      homeBackgroundImagePath: data?['homeBackgroundImagePath'],
      vetCertificate: data?['vetCertificate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (name != null) "name": name,
      if (nickName != null) "nickName": nickName,
      if (email != null) "email": email,
      if (usertype != null) "usertype": usertype,
      if (homeBackgroundImagePath != null)
        "homeBackgroundImagePath": homeBackgroundImagePath,
      if (vetCertificate != null) "vetCertificate": vetCertificate,
    };
  }
}
