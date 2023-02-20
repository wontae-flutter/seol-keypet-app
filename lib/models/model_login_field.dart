import 'package:flutter_riverpod/flutter_riverpod.dart';

//* 로그인 필드의 데이터를 관리하는 모델
//* Provider랑 합쳐놓았습니다. 밑에 메소드는 프로바이더로 가는 게 맞아요
//* Firebase와의 통신은 auth모델이 필수적으로 필요합니다.
class LoginField {
  String email = "";
  String password = "";

  LoginField({
    required this.email,
    required this.password,
  });
}

//* 지금 이게 안되는 것
class LoginFieldNotifier extends StateNotifier<LoginField> {
  // LoginField라는 class가 대체 어떤놈인지를 알아야 하는데...

  LoginFieldNotifier()
      : super(LoginField(
          email: "",
          password: "",
        ));
  void setEmail(String email) {
    state = LoginField(
      email: email,
      password: state.password,
    );
  }

  void setPassword(String password) {
    state = LoginField(
      email: state.email,
      password: password,
    );
  }
}


// * 아 여기에 넣어야되나...state로 가능할듯!!