import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/provider_auth.dart';
import "../../../styles/styles.dart";

class PetRegisterContainer extends ConsumerWidget {
  const PetRegisterContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid = ref.watch(uidProvider);
    return Container(
      margin: AppLayout.containerInsideListviewMargin,
      padding: AppLayout.registerButtonContainerPadding,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.black12),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                spreadRadius: 2.0,
                offset: Offset(2.0, 2.0)), // shadow direction: bottom right),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (uid != null) {
                Navigator.of(context).pushNamed("/pet_register");
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("로그인이 필요합니다."),
                  ));
              }
            },
            child: Icon(
              IconData(0xee3c, fontFamily: 'MaterialIcons'),
              size: 60,
              color: Colors.black38,
            ),
          ),
          Text(
            "포로치 등록하기",
          ),
          Text(
            "포로치의 반려동물 등록번호를 연동시켜주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
