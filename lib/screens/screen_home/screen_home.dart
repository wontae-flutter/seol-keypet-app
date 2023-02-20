import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palestine_console/palestine_console.dart';
import 'package:porocci_main/common/MainLogo.dart';
import 'dart:developer' as developer;

import '../../models/user_detail.dart';
import '../../providers/provider_auth.dart';
import '../../styles/styles.dart';
import 'widgets/HomeArea.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailProvider);
    final uid = user?.uid;
    final usertype = user?.usertype;

    developer.log("User with ${uid}, userType: ${usertype}", name: "Usertype");

    final authNotifier = ref.watch(authNotifierProvider.notifier);
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          (uid == null)
              ? IconButton(
                  onPressed: () => Navigator.of(context).pushNamed("/login"),
                  icon: Icon(
                      color: Colors.white,
                      IconData(
                        0xe3b2,
                        fontFamily: 'MaterialIcons',
                      )))
              : Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                        // authNotifier.logout().then((_) =>
                        //     ScaffoldMessenger.of(context)
                        //       ..hideCurrentSnackBar()
                        //       ..showSnackBar(
                        //           SnackBar(content: Text("로그아웃 되었습니다."))));
                        // Navigator.of(context).pushNamed("/home");
                      },
                      icon: Icon(
                        Icons.settings,
                        // Icons.logout_outlined,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          padding: AppLayout.endDrawbarPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [MainLogo(), SizedBox(width: 5), Text("$usertype")],
              ),
              Divider(),
              // TextButton(
              //     onPressed: () {
              //       Navigator.of(context).pushNamed("/mypage");
              //     },
              //     child: Text("마이페이지")),
              LogoutButton(),
              WithdrawButton(),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true, //* body위에 appbar
      body: Container(
        color: AppColor.homeScreenBackgroundColor,
        child: Column(
          children: [
            const HeroImage(),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: HomeArea(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    //! 이것도 USERprovider로 ? : 해야함
    return Image.asset(
      height: MediaQuery.of(context).size.height * 0.38,
      "assets/images/hero/dog3.jpeg",
      fit: BoxFit.cover,
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    Future<bool> isLogoutDesired() async {
      return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text("로그아웃 하시겠습니까?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("로그아웃하기"),
                          style: TextButton.styleFrom(
                              // foregroundColor: AppColor.porochiLogoColor,
                              )),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("취소"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          )),
                    ],
                  )) ??
          false;
    }

    return TextButton(
      onPressed: () async {
        if (await isLogoutDesired()) {
          authNotifier.logout().then((_) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("로그아웃 되었습니다."))));
          Navigator.of(context).pushNamed("/home");
        }
      },
      child: Text("로그아웃"),
    );
  }
}

class WithdrawButton extends ConsumerWidget {
  const WithdrawButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    Future<bool> isWithdrawlDesired() async {
      return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text("회원탈퇴 하시겠습니까?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("회원탈퇴 하기"),
                          style: TextButton.styleFrom(
                              // foregroundColor: AppColor.porochiLogoColor,
                              )),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("취소"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          )),
                    ],
                  )) ??
          false;
    }

    return TextButton(
      onPressed: () async {
        if (await isWithdrawlDesired()) {
          authNotifier.withdrawl().then((_) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("회원탈퇴 되었습니다."))));
          Navigator.of(context).pushNamed("/home");
        }
      },
      child: Text("회원탈퇴"),
    );
  }
}



  // Future<void> _onExitPressed() async {
  //   final isConfirmed = await _isExitDesired();
  //   if (isConfirmed && mounted) {
  //     _exitSetup();
  //   }
  // }

  // Future<bool> _isExitDesired() async {
  //   return await showDialog<bool>(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //                 title: Text("Are you sure?"),
  //                 content: Text(
  //                     'If you exit device setup, your progress will be lost.'),
  //                 actions: [
  //                   TextButton(
  //                       onPressed: () => Navigator.of(context).pop(true),
  //                       child: Text("Leave")),
  //                   TextButton(
  //                       onPressed: () => Navigator.of(context).pop(false),
  //                       child: Text("Stay")),
  //                 ],
  //               )) ??
  //       false;
  // }

  // void _exitSetup() {
  //   Navigator.of(context).pop();
  // }