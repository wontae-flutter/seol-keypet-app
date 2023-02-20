import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import "../../styles/styles.dart";
import '../../enums/enum_auth.dart';
import '../../providers/provider_auth.dart';
import './widgets/widgets.dart';
import '../../common/commons.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: AppLayout.formPageContainerWOBottomPadding,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: const <Widget>[
              SizedBox(height: 15),
              MainLogo(),
              SizedBox(height: 15),
              RegisterEmailInput(),
              RegisterPasswordInput(),
              RegisterPasswordConfirmInput(),
              SizedBox(height: 15),
              Align(alignment: Alignment.center, child: RegisterButton()),
              SizedBox(height: 60),
              // ThirdPartyIconContainer(),
              Privacy(),
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

class RegisterEmailInput extends ConsumerWidget {
  const RegisterEmailInput({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 이게 문제구만...
    final registerFieldNotifier =
        ref.watch(registerFieldNotifierProvider.notifier);
    return TextField(
      onChanged: (email) {
        registerFieldNotifier.setEmail(email);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '이메일',
        helperText: '',
      ),
    );
  }
}

class RegisterPasswordInput extends ConsumerWidget {
  const RegisterPasswordInput({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerFieldNotifier =
        ref.watch(registerFieldNotifierProvider.notifier);
    return TextField(
      onChanged: (password) {
        registerFieldNotifier.setPassword(password);
        print("password: $password");
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "비밀번호",
        helperText: "",
      ),
    );
  }
}

class RegisterPasswordConfirmInput extends ConsumerWidget {
  const RegisterPasswordConfirmInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerFieldNotifier =
        ref.watch(registerFieldNotifierProvider.notifier);
    final registerPassword = ref.watch(registerFieldNotifierProvider).password;
    final registerPasswordConfirm =
        ref.watch(registerFieldNotifierProvider).passwordConfirm;

    return TextField(
      onChanged: (passwordConfirm) {
        registerFieldNotifier.setPasswordConfirm(passwordConfirm);
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: "비밀번호 확인",
          helperText: "",
          errorText: registerPassword != registerPasswordConfirm
              ? "비밀번호가 일치하지 않습니다."
              : null),
    );
  }
}

class RegisterButton extends ConsumerWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final registerEmail = ref.watch(registerFieldNotifierProvider).email;
    final registerPassword = ref.watch(registerFieldNotifierProvider).password;
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.porochiLogoColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await authRepository
              .registerWithEmail(registerEmail, registerPassword)
              .then((registerStatus) {
            if (registerStatus == AuthStatus.registered) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text("회원가입이 완료되었습니다.")));
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text("회원가입을 실패했습니다. 다시 시도해주세요.")));
              // Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            }
          });
        },
        child: Text('회원가입'),
      ),
    );
  }
}

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
          text: "가입하면 KEYPET의 ",
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: "운영원칙, 개인정보 처리방침",
              style: TextStyle(color: theme.primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await launchUrl(Uri.parse(
                      "https://m.blog.naver.com/seol62691/222976217012?afterWebWrite=true"));
                  // await launch("https://www.naver.com");
                },
            ),
            // onTap: () => launchUrl("https:www.naver.com"),
            TextSpan(
                text:
                    "에 동의하게 됩니다. KEYPET은 개인정보 처리방침에 명시된 목적에 따라 이메일 주소 등 연락처 정보를 사용할 수 있습니다."),
          ]),
    );
  }
}
