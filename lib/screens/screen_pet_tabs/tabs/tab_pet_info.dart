import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../models/pet.dart";
import '../../../styles/styles.dart';

class PetInfoTab extends ConsumerWidget {
  final String pid;
  final Pet pet;
  const PetInfoTab({
    super.key,
    required this.pid,
    required this.pet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        boxShadow: AppLayout.cardBoxShadow,
      ),
      margin: AppLayout.tabContainerMargin,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.4,
              color: AppColor.placeHolderBackgroundColor,
              child: Stack(children: [
                Image.asset(
                  "assets/images/icons/pet_icon.png",
                  // fit: BoxFit,
                ),
              ]),
              // child: Image.network(
              //   "https://ggsc.s3.amazonaws.com/images/uploads/The_Science-Backed_Benefits_of_Being_a_Dog_Owner.jpg",
              //   fit: BoxFit.fitHeight,
              // ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: AppColor.lightgrey,
              ),
              child: Padding(
                padding: AppLayout.tabContentPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(pet.name, style: AppText.petCertificateTitle),
                    ),
                    SizedBox(height: 5),
                    Text.rich(TextSpan(
                      text: "🎂",
                      style: AppText.tableBody,
                      children: [
                        TextSpan(
                          text: pet.birthdate,
                        )
                      ],
                    )),
                    Text.rich(TextSpan(
                      text: "성별: ",
                      style: AppText.tableBody,
                      children: [
                        TextSpan(
                          text: pet.sex,
                        )
                      ],
                    )),
                    Text.rich(TextSpan(
                      text: "중성화 여부: ",
                      style: AppText.tableBody,
                      children: [
                        TextSpan(
                          text: pet.isneutered,
                        )
                      ],
                    )),
                    Text.rich(TextSpan(
                      text: "동물 등록번호: ",
                      style: AppText.tableBody,
                      children: [
                        TextSpan(
                          text: pet.registernumber,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )),
                    SizedBox(height: 5),
                    Text(
                      '알러지: ${pet.allergies ?? "없음"}',
                      style: AppText.tableAccent,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColor.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        pet.remarks ?? "없음",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
