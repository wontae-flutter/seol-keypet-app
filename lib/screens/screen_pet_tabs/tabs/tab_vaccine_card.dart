import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/provider_vaccine.dart';
import "../../../models/pet.dart";
import "../../../models/vaccine.dart";
import '../../../styles/styles.dart';
import '../../../common/commons.dart';

class VaccineCardTab extends ConsumerWidget {
  final String pid;
  final Pet pet;
  const VaccineCardTab({
    super.key,
    required this.pid,
    required this.pet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allVaccinesOfpet = ref.watch(allVaccinesOfPetProvider(pid));

    return allVaccinesOfpet.when(
      loading: () => Scaffold(
        body: Center(),
      ),
      error: (error, stackTrace) => Text("백신 정보를 가져오지 못했습니다. 다시 시도해 주세요."),
      data: (data) => Center(
        child: Container(
          padding: AppLayout.tabContainerPadding,
          child: Column(
            children: [
              DogImage(
                  image:
                      "https://ggsc.s3.amazonaws.com/images/uploads/The_Science-Backed_Benefits_of_Being_a_Dog_Owner.jpg"),
              SizedBox(height: 15),
              Expanded(child: VaccineCardContainer(allVaccinesOfpet: data)),
            ],
          ),
        ),
      ),
    );
  }
}

class VaccineCardContainer extends ConsumerWidget {
  final List<Vaccine?> allVaccinesOfpet;
  const VaccineCardContainer({
    super.key,
    required this.allVaccinesOfpet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: AppLayout.cardBoxShadow,
        color: AppColor.skyblue,
      ),
      padding: AppLayout.tabContentPadding,
      child: Column(
        children: [
          Text(
            "예방접종 증명내역서",
            style: TextStyle(
              color: AppColor.blue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: allVaccinesOfpet.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return VaccineCard(
                  vaccineName: allVaccinesOfpet[index]!.vname,
                  dose: allVaccinesOfpet[index]!.dose,
                  date: allVaccinesOfpet[index]!.lastdate,
                  vet: allVaccinesOfpet[index]!.vet,
                  nextdate: allVaccinesOfpet[index]!.nextdate,
                );
                // return Text("hi");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VaccineCard extends StatelessWidget {
  //* 접종차수 dose, date, vet, nextdate
  String vaccineName;
  int dose;
  String date;
  String vet;
  String nextdate;
  VaccineCard({
    super.key,
    required this.vaccineName,
    required this.dose,
    required this.date,
    required this.vet,
    required this.nextdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 180,
      decoration: BoxDecoration(
        color: AppColor.homeScreenBackgroundColor,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(width: 1, color: Colors.black38),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              color: AppColor.blue,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  vaccineName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "접종차수",
                          style: AppText.tableAccent,
                        ),
                        Row(children: [
                          Text(
                            "${dose}차",
                            style: AppText.tableBody,
                          ),
                          SizedBox(width: 4),
                          (dose == 0) ? SizedBox() : CheckMark()
                        ]),
                        Text(
                          "담당 수의사",
                          style: AppText.tableAccent,
                        ),
                        Text(
                          vet,
                          style: AppText.tableBody,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "접종일자",
                          style: AppText.tableAccent,
                        ),
                        Text(
                          date,
                          style: AppText.tableBody,
                        ),
                        Text(
                          "다음 예정일",
                          style: AppText.tableAccent,
                        ),
                        Text(
                          nextdate,
                          style: AppText.tableBody,
                        ),
                      ],
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

class CheckMark extends StatelessWidget {
  const CheckMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -4),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: Color(0xffbbddff),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              IconData(0xe15a, fontFamily: 'MaterialIcons'),
              size: 16,
              color: Color(0xff74abf3),
            ),
            SizedBox(width: 4),
            Text(
              "접종완료",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
