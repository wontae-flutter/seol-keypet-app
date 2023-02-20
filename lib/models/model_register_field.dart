import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterField {
  String email = "";
  String password = "";
  String passwordConfirm = "";

  RegisterField({
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });
}

class RegisterFieldNotifier extends StateNotifier<RegisterField> {
  RegisterFieldNotifier()
      : super(RegisterField(email: "", password: "", passwordConfirm: ""));

  //* 아래 함수들은 state를 변화시키고 consumer(=UI)에게 알려야 하기 때문에 notifyListerners()를 사용합니다.
  void setEmail(String email) {
    state = RegisterField(
      email: email,
      password: state.password,
      passwordConfirm: state.passwordConfirm,
    );
  }

  void setPassword(String password) {
    state = RegisterField(
      email: state.email,
      password: password,
      passwordConfirm: state.passwordConfirm,
    );
  }

  void setPasswordConfirm(String passwordConfirm) {
    state = RegisterField(
      email: state.email,
      password: state.password,
      passwordConfirm: passwordConfirm,
    );
  }
}
