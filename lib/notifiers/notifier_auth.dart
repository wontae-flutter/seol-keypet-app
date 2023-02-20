import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import "dart:developer" as developer;
import '../models/user_detail.dart';
import '../models/pet.dart';
import '../enums/enum_auth.dart';

//todo 얘는 uid를 이미 아는 상태에서 가져오는 거고
class AuthNotifier extends StateNotifier<UserDetail?> {
  AuthNotifier() : super(null);
  FirebaseAuth authClient = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<UserDetail?> getUserDetail(String uid) async {
    try {
      final userDetailCollRef = db.collection("users").withConverter(
          fromFirestore: UserDetail.fromFirestore,
          toFirestore: (UserDetail userDetail, options) =>
              userDetail.toFirestore());
      final docSnap = await userDetailCollRef.doc(uid).get();
      final userDetail = docSnap.data();
      state = userDetail;
      developer.log("Fetching user $uid successuful", name: "getUserDetail");
      return userDetail;
    } catch (e) {
      developer.log("Fetching user $uid failed",
          error: e, name: "getUserDetail");
      return null;
    }
  }

  Future addUserDetail(String uid, UserDetail userDetail) async {
    try {
      final userDetailCollRef = db.collection("users").withConverter(
          fromFirestore: UserDetail.fromFirestore,
          toFirestore: (UserDetail userDetail, options) =>
              userDetail.toFirestore());
      await userDetailCollRef.doc(uid).set(userDetail);

      //todo 여기에 서브컬렉션이 들어잇어야함
      final usersPetsCollRef = db
          .collection("users")
          .doc(uid)
          .collection("usersPets")
          .withConverter(
              fromFirestore: Pet.fromFirestore,
              toFirestore: (Pet pet, options) => pet.toFirestore());
      developer.log("Adding user $uid successuful", name: "addUserDetail");
    } catch (e) {
      developer.log("Adding user $uid", error: e, name: "addUserDetail");
    }
  }

  Future updateUserDetail(String uid, Map<String, dynamic> updates) async {
    try {
      final userDetailCollRef = db.collection("users").withConverter(
          fromFirestore: UserDetail.fromFirestore,
          toFirestore: (UserDetail userDetail, options) =>
              userDetail.toFirestore());

      await userDetailCollRef.doc(uid).update(updates);
      await getUserDetail(uid);
      developer.log("Updating user $uid successuful", name: "updateUserDetail");
    } catch (e) {
      developer.log("Updating user $uid failed",
          error: e, name: "addUserDetail");
    }
  }

  Future<AuthStatus> registerWithEmail(String email, String password) async {
    try {
      UserCredential credential = await authClient
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = credential.user!.uid;
      await addUserDetail(
          uid,
          UserDetail(
            uid: uid,
            name: null,
            nickName: null,
            email: email,
            usertype: "보호자",
            homeBackgroundImagePath: null,
            vetCertificate: null,
            //! 이것도 Subcollection 아니냐?
          ));
      //? 기본역할 보호자, uid, 이메일 정도는 기본으로 넣으면...
      //? 역할을 못가져와서그러자너, 기본을 보호자로 해놓으면 되지 않을까??
      //! 자동적으로 uid가 선택이 됩니다.
      return AuthStatus.registered;
    } catch (e) {
      print(e);
      return AuthStatus.notRegistered;
    }
  }

  Future<AuthStatus> loginWithEmail(String email, String password) async {
    try {
      await authClient
          .signInWithEmailAndPassword(email: email, password: password)
          //* 인증정보를 담고있는 객체
          .then((UserCredential credential) async {
        String uid = credential.user!.uid;

        UserDetail? userDetail = await getUserDetail(uid);
        developer.log(
            "User login with user email: ${state!.email.toString()} successful",
            name: "loginWithEmail");
        //! 비밀번호 hash하는 패키지를 당연히 사용해야 합니다
        // prefs.setString('password', password);
      });
      return AuthStatus.loggedIn;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        developer.log("Unregisted user email}",
            error: e, name: "user-not-found");
      } else if (e.code == 'wrong-password') {
        developer.log("Wrong password", error: e, name: "wrong-password");
      }
      return AuthStatus.notLoggedIn;
    }
  }

  //! 여기서부터 써드파티!
  //todo Federated Identity & Social
  //* Google Authentication
  // Future<AuthStatus> signInWithGoogle() async {
  //   try {
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //     await authClient.signInWithCredential(credential);
  //     return AuthStatus.loggedIn;
  //   } catch (e) {
  //     print(e);
  //     return AuthStatus.notLoggedIn;
  //   }
  //   ;
  // }

  //* Apple Authentication
  //* 네이버 카카오 도전? ㅋㅋㅋㅋㅋ

  //* 로그아웃 = 간단하게 모든 정보를 삭제하면 됩니다
  Future<void> logout() async {
    // // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool("isLogin", false);
    // prefs.setString("email", "");
    // prefs.setString("password", "");
    state = null;
    await authClient.signOut();
    print("로그아웃 되었습니다.");
  }

  Future<void> withdrawl() async {
    // // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool("isLogin", false);
    // prefs.setString("email", "");
    // prefs.setString("password", "");
    try {
      User? user = await authClient.currentUser;
      final userDetailCollRef = db.collection("users").withConverter(
          fromFirestore: UserDetail.fromFirestore,
          toFirestore: (UserDetail userDetail, options) =>
              userDetail.toFirestore());

      await userDetailCollRef.doc(user!.uid).delete();

      state = null;
      await user.delete();
      developer.log("User ${user.uid} delete successful", name: "withdrawl");
    } catch (e) {
      developer.log("User delete failed", name: "withdrawl");
    }

    print("로그아웃 되었습니다.");
  }
}
