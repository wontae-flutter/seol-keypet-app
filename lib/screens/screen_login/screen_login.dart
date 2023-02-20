import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../styles/styles.dart';
import '../../providers/provider_auth.dart';
import './widgets/widgets.dart';
import '../../enums/enum_auth.dart';
import '../../common/commons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: AppLayout.formPageContainerWOBottomPadding,
        child: Form(
          // onChanged: _onFormChange,
          // onWillPop: _onWillPop,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(height: 15),
              MainLogo(),
              SizedBox(height: 15),
              LoginEmailInput(),
              LoginPasswordInput(),
              SizedBox(height: 15),
              Align(alignment: Alignment.center, child: LoginButton()),
              SizedBox(height: 15),
              MoveToRegisterPageButton(),
              SizedBox(height: 60),
              SizedBox(height: 60),
              // ThirdPartyIconContainer(),
              SizedBox(height: 60),
              Copywrite(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// 지금 밑에게 매우 안되는 중
class LoginEmailInput extends ConsumerWidget {
  const LoginEmailInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 이게 문제구만...
    final loginFieldNotifier = ref.watch(loginFieldNotifierProvider.notifier);
    return TextFormField(
      validator: (value) => isEmail(value!) ? null : "정확한 이메일 형식을 입력해주세요.",
      onChanged: (email) {
        loginFieldNotifier.setEmail(email);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '이메일',
        helperText: '',
      ),
    );
  }

  isEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value) ? true : false;
  }
}

class LoginPasswordInput extends ConsumerWidget {
  const LoginPasswordInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFieldNotifier = ref.watch(loginFieldNotifierProvider.notifier);

    return TextField(
      onChanged: (password) {
        loginFieldNotifier.setPassword(password);
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "비밀번호",
        helperText: "",
      ),
    );
  }
}

//! user로 들어가는건 알겠는데, user가 수의사인지 아니면 일반사용자인지는 어떻게...?
class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final uid = ref.watch(uidProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    // final userDetailRepository = ref.watch(userDetailRepositoryProvider);

    //! 이게 아니라 폼으로 해야합니다. 그때는 폼을 몰랐어..ㅋㅋㅋ
    final loginEmail = ref.watch(loginFieldNotifierProvider).email;
    final loginPassword = ref.watch(loginFieldNotifierProvider).password;

    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.porochiLogoColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text("로그인"),
          onPressed: () {
            //! 이제 여기를 authStateProvider로 대체해야하는 것이다. 아니면 둘 다 있어야하나...?
            authRepository.loginWithEmail(loginEmail, loginPassword).then(
              (loginStatus) async {
                //todo 현재 여기가 실행되지 않음
                if (loginStatus == AuthStatus.loggedIn) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text("로그인 성공"),
                    ));
                  Navigator.of(context).pushReplacementNamed("/home");
                  context.go("/home");
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text("등록되지 않은 사용자 정보입니다."),
                    ));
                }
              },
            );
          },
        ));
  }
}

//! 자동로그인

//! 아이디찾기

//! 비밀번호재설정

//! 회원가입
class MoveToRegisterPageButton extends StatelessWidget {
  const MoveToRegisterPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed("/user_register");
        // context.go("/user_register");
      },
      child: Text(
        '이메일로 간단하게 회원가입 하기',
        style: TextStyle(
          color: AppColor.porochiLogoColor,
        ),
      ),
    );
  }
}

class CopyRightText extends StatelessWidget {
  final String copyRightText;
  const CopyRightText({
    super.key,
    required this.copyRightText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      copyRightText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey),
    );
  }
}
