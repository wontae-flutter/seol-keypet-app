import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porocci_main/providers/provider_pet.dart';
import '../../../providers/provider_auth.dart';
import 'package:go_router/go_router.dart';

import 'dart:developer' as developer;

import '../../../models/user_detail.dart';
import "../../../styles/styles.dart";

class PetListViewContainer extends ConsumerWidget {
  const PetListViewContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 요기는 FutureProvider 쓰면 된다
    final uid = ref.watch(uidProvider);
    // final userDetail = ref.watch(userDetailProvider);
    final allPetsofUser =
        (uid == null) ? null : ref.watch(allPetsofUserProvider(uid));

    return (allPetsofUser == null)
        ? const PetPlaceHolder()
        : (allPetsofUser.isEmpty)
            ? const PetPlaceHolder()
            : Container(
                height: 105,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: allPetsofUser.length,
                  itemBuilder: (context, index) {
                    return PetProfileButton(
                        //! 사실 요거는 Storage에서 pid만으로 파일을 ㅅ다가져오기때문에
                        //! petProfile이란 섹션이 아예 필요없을수가 이
                        //! 이게 없구나
                        pid: allPetsofUser[index]!.pid,
                        // petProfile: data[index].doc.data()!.image,
                        // petProfile: data[index].doc.data()!.image,
                        petName: allPetsofUser[index]!.name);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 20);
                  },
                ),
              );

    // return (allPetsofUser == null)
    //     ? const PetPlaceHolder()
    //     : allPetsofUser.when(
    //         loading: () => const PetPlaceHolder(),
    //         error: (error, stackTrace) => Text("펫 정보를 가져오지 못했습니다. 다시 시도해 주세요."),
    //         data: (data) {
    //           developer.log("${data.length}", name: "number of pets");
    //           return (data.isEmpty)
    //               ? const PetPlaceHolder()
    //               : Container(
    //                   height: 105,
    //                   child: ListView.separated(
    //                     physics: BouncingScrollPhysics(),
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: data.length,
    //                     itemBuilder: (context, index) {
    //                       return PetProfileButton(
    //                           //! 사실 요거는 Storage에서 pid만으로 파일을 ㅅ다가져오기때문에
    //                           //! petProfile이란 섹션이 아예 필요없을수가 이
    //                           pid: data[index].doc.id,
    //                           // petProfile: data[index].doc.data()!.image,
    //                           // petProfile: data[index].doc.data()!.image,
    //                           petName: data[index].doc.data()!.name);
    //                     },
    //                     separatorBuilder: (context, index) {
    //                       return SizedBox(width: 20);
    //                     },
    //                   ),
    //                 );
    //         });
  }
}

class PetProfileButton extends StatelessWidget {
  final String pid;
  // String petProfile;
  String petName;
  PetProfileButton({
    super.key,
    required this.pid,
    // required this.petProfile,
    required this.petName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/pet_tabs',
        arguments: {'pid': pid},
      ),
      // onTap: () {
      //   context.go("/pet_tabs/${pid}");
      // },
      //todo 얘떄문에 그랬구나.
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.lightgrey),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  // child: Text("ddsds"),
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/icons/pet_icon.png"),
                  ),
                ),
              ),
            ],
          ),
          Text(
            petName,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PetPlaceHolder extends StatelessWidget {
  const PetPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColor.lightgrey),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/hero/placeholder_dog.png"),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "기다려요!",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
