import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import "../../../models/pet.dart";
import '../../../providers/provider_auth.dart';
import '../../../providers/provider_vaccine.dart';
import '../../../common/commons.dart';
import '../../../styles/styles.dart';

class VaccineHistoryTab extends ConsumerWidget {
  final String pid;
  final Pet pet;
  const VaccineHistoryTab({
    super.key,
    required this.pid,
    required this.pet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailProvider);
    final usertype = user?.usertype;
    final allVaccinesOfpet = ref.watch(allVaccinesOfPetProvider(pid));
    return allVaccinesOfpet.when(
      loading: () => const CircularProgressIndicator(),
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.lightgrey,
                    boxShadow: AppLayout.cardBoxShadow,
                  ),
                  padding: AppLayout.tabContentPadding,
                  child: Column(
                    children: [
                      Text(
                        "예방접종 내역",
                        style: AppText.homeScreenTitle,
                      ),
                      SizedBox(height: 15),
                      VaccineHistoryTitle(),
                      SizedBox(height: 15),
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            //! entries.map으로 하면
                            return VaccineListTile(
                              vaccineName: data[index]!.vname,
                              dose: data[index]!.dose,
                              date: data[index]!.nextdate,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: data.length,
                        ),
                      ),
                      Visibility(
                        visible: (usertype == "수의사"),
                        // visible: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/vaccine_history_update',
                              //todo Pid가져오는거에서 변함
                              // arguments: {'Vaccine': data},
                              arguments: {'pid': pid},
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColor.blue,
                                  border: Border.all(color: AppColor.blue),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                width: 180,
                                child: Text(
                                  "접종내역 업데이트",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VaccineHistoryTitle extends StatelessWidget {
  const VaccineHistoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: _buildTitle("백신")),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.16,
              child: _buildTitle("차수")),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: _buildTitle("예정일")),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.blue,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}

class VaccineListTile extends StatelessWidget {
  String vaccineName;
  int dose;
  String date;

  VaccineListTile({
    super.key,
    required this.vaccineName,
    required this.dose,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.blue),
        color: AppColor.skyblue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.23,
              child: Text(
                vaccineName,
                style: TextStyle(fontSize: 11),
              )),
          VerticalDivider(color: Colors.white, thickness: 3.0),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                "$dose",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              )),
          VerticalDivider(color: Colors.white, thickness: 3.0),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.23,
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              )),
        ],
      ),
    );
  }
}
