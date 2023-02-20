//* Firebase와의 통신 등 인증 관련 회원 정보 전반을 다루는 Provider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/model_login_field.dart';
import '../models/model_register_field.dart';

import '../models/user_detail.dart';
import "../notifiers/notifier_auth.dart";

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, UserDetail?>((ref) {
  return AuthNotifier();
});

final authRepositoryProvider = Provider((ref) {
  return ref.watch(authNotifierProvider.notifier);
});

final userDetailProvider = Provider((ref) {
  return ref.watch(authNotifierProvider);
});

final uidProvider = Provider((ref) {
  return ref.watch(userDetailProvider)?.uid;
});

final userTypeProvider = Provider((ref) {
  return ref.watch(userDetailProvider)?.usertype;
});

// final usersPetsProvider = Provider((ref) {
//   return ref.watch(userDetailProvider)?.;
// });

//? 어짜피 authRepositoryProvider의 메소드에서 .then으로 status를 받아버리니까
//? 따로 만들어서 필요하진 않음? 정말?
//todo isLogin을 보려면 봐야하지 않을까? 그런데...
// final loginStatusProvider = FutureProvider.autoDispose
//     //! {email:email, password:password} 형태로 받아야 합니다.
//     //! AuthInput타입을 만들어야하겠네요.
//     // family<리턴타입, 파라미터타입>
//     .family<AuthStatus, LoginField>((ref, loginField) async {
//   final authRepository = ref.watch(authRepositoryProvider);
//   final loginStatus = await authRepository.loginWithEmail(
//       loginField.email, loginField.password);
//   return loginStatus;
// });

// final registerStatusProvider = FutureProvider.autoDispose
//     .family<AuthStatus, LoginField>((ref, loginField) async {
//   final authRepository = ref.watch(authRepositoryProvider);
//   final loginStatus = await authRepository.loginWithEmail(
//       loginField.email, loginField.password);
//   return loginStatus;
// });

//todo authRepo의 property를 직접 가져오는 방식, prefs 못해먹겠어요 시발
// final loginStatusProvider = Provider((ref) {
//   AuthStatus loginStatus = ref.watch(authRepositoryProvider).loginStatus;
//   return loginStatus;
// });

// final registerStatusProvider = Provider((ref) {
//   AuthStatus registerStatus = ref.watch(authRepositoryProvider).registereStatus;
//   return registerStatus;
// });

//! 각 property(=getter)와 setter를 가져오는 방법!
final loginFieldNotifierProvider =
    StateNotifierProvider<LoginFieldNotifier, LoginField>((ref) {
  return LoginFieldNotifier();
});

final registerFieldNotifierProvider =
    StateNotifierProvider<RegisterFieldNotifier, RegisterField>((ref) {
  return RegisterFieldNotifier();
});
