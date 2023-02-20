import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:porocci_main/styles/styles.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

import './screens/screens.dart';

// final _router = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
//     GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
//     GoRoute(
//         path: '/image_upload',
//         builder: (context, state) => const ImageUploadScreen()),
//     GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
//     GoRoute(
//         path: '/user_register',
//         builder: (context, state) => const RegisterScreen()),
//     GoRoute(path: '/mypage', builder: (context, state) => const MyPageScreen()),
//     GoRoute(
//         path: '/pet_tabs/:pid',
//         builder: (context, state) {
//           String pid = state.params["pid"]!;
//           return PetTabsScreen(pid: pid);
//         }),
//     GoRoute(
//         path: '/pet_register',
//         builder: (context, state) => const PetRegisterScreen()),
//     GoRoute(
//         path: '/vaccine_history_update',
//         builder: (context, state) => const VaccineHistoryUpdateScreen()),
//     GoRoute(
//         path: '/qr_scan', builder: (context, state) => const QRScannerScreen()),
//   ],
// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routerConfig: _router,
      title: 'Porocci',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        // primaryColor: AppColor.porochiLogoColor,
        // textTheme: TextTheme(),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ),
        pageTransitionsTheme: PageTransitionsTheme(builders: const {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/image_upload": (context) => const ImageUploadScreen(),
        "/login": (context) => const LoginScreen(),
        "/user_register": (context) => const RegisterScreen(),
        "/mypage": (context) => const MyPageScreen(),
        //todo 각각 펫아이디에 해줘야하는데, 요거는 넘버링하지않고 유저아이디 + 펫아이디가 합쳐져있어야 할 것 같아요.
        "/pet_register": (context) => const PetRegisterScreen(),
        "/pet_tabs": (context) => const PetTabsScreen(),
        "/vaccine_history_update": (context) =>
            const VaccineHistoryUpdateScreen(),
        "/qr_scan": (context) => const QRScanScreen(),
        "/qr_register": (context) => const QRRegisterScreen(),
        "/qr_result": (context) => const QRResultScreen(),
      },
    );
  }
}

// 로그아웃을 만들어야겠음