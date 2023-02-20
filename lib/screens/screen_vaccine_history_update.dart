import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import "../common/commons.dart";
import "dart:developer" as developer;
import '../providers/provider_vaccine.dart';
import '../models/vaccine.dart';
import '../styles/styles.dart';

List<String> vaccineList = [
  "종합예방접종(DHPPL)",
  "코로나바이러스장염(Coronavirus)",
  "기관ㆍ기관지염 (Kennel Cough)",
  "독감접종 (Influenza)",
  "심장사상충 및 내부기생충",
  "외부기생",
  "광견",
];

//* 각자 펫의 백신을 하는거니까, 얘도 pid 필요하지

class VaccineHistoryUpdateScreen extends ConsumerStatefulWidget {
  // final String pid;
  const VaccineHistoryUpdateScreen({
    super.key,
    // required this.pid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VaccineHistoryUpdateScreenState();
}

class _VaccineHistoryUpdateScreenState
    extends ConsumerState<VaccineHistoryUpdateScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _formChanged = false;
  List<int> doseList = List.generate(250, (index) => index);
  final DateFormat formatter = DateFormat('yyyy.MM.dd');

  int selectedVaccineIndex = 0;
  int selectedDoseIndex = 0;
  DateTime selectedDate = DateTime.now();

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String pid = arguments["pid"];

    final vaccineRepository = ref.watch(vaccineRepositoryProvider);
    final allVaccinesOfpet = ref.watch(allVaccinesOfPetProvider(pid));
    return allVaccinesOfpet.when(
        loading: () => Scaffold(
              body: Center(),
            ),
        error: (error, stackTrace) => Text("백신 정보를 가져오지 못했습니다. 다시 시도해 주세요."),
        data: (data) {
          return Scaffold(
            appBar: AppBar(
              title: Text("접종내역 업데이트"),
              shape: Border(bottom: BorderSide(color: Colors.black26)),
            ),
            body: Center(
                child: Container(
              padding: AppLayout.formPageContainerPadding,
              child: Form(
                key: formKey,
                onChanged: _onFormChange,
                onWillPop: _onWillPop,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 53),
                    DogImage(image: "image"),
                    SizedBox(height: 60),
                    SizedElevatedButton(
                        child: Text('백신: ${data[selectedVaccineIndex]!.vname}'),
                        onPressed: () => _showDialog(CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: 32,
                              onSelectedItemChanged: (int selectedItemIndex) {
                                setState(() {
                                  selectedVaccineIndex = selectedItemIndex;
                                });
                              },
                              children: List<Widget>.generate(
                                  vaccineList.length, (int index) {
                                return Center(
                                  child: Text(data[index]!.vname),
                                );
                              }),
                            ))),
                    SizedElevatedButton(
                        child: Text('회차: ${selectedDoseIndex}'),
                        onPressed: () => _showDialog(CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: 32,
                              onSelectedItemChanged: (int selectedItemIndex) {
                                setState(() {
                                  selectedDoseIndex = selectedItemIndex;
                                });
                              },
                              children: List<Widget>.generate(doseList.length,
                                  (int index) {
                                return Center(
                                  child: Text(
                                    "${doseList[index]}",
                                  ),
                                );
                              }),
                            ))),
                    SizedElevatedButton(
                      // data[selectedVaccineIndex].doc.data()!.lastdate
                      // String to Datetime
                      child: Text("날짜: ${formatter.format(selectedDate)}"),
                      onPressed: () => _showDialog(CupertinoDatePicker(
                        initialDateTime: formatter
                            .parse(data[selectedVaccineIndex]!.lastdate),
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => selectedDate = newDate);
                        },
                      )),
                    )
                  ],
                ),
              ),
            )),
            bottomSheet: InkWell(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  developer.log("Vaccine update form input is valid",
                      name: "vaccineUpdateForm");

                  try {
                    formKey.currentState!.save();
                    developer.log(
                        "Vaccine update form's current state is NOT null, hence input is saved",
                        name: "vaccineUpdateForm");
                  } catch (e) {
                    developer.log(
                        "Vaccine update form's current state IS null, hence input is NOT saved",
                        error: e,
                        name: "vaccineUpdateForm");
                  }

                  try {
                    vaccineRepository.updateVaccine(
                        pid, data[selectedVaccineIndex]!.vname, {
                      "dose": doseList[selectedDoseIndex],
                      "lastdate": formatter.format(selectedDate)
                    });
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("백신 등록 성공"),
                      ));
                    // Navigator.of(context).pushReplacementNamed("/pet_tabs",
                    //     arguments: {"pid": pid});
                    Navigator.of(context).pop();
                  } catch (e) {
                    throw (e);
                  }
                } else {
                  developer.log("Vaccine update form input is NOT valid",
                      name: "vaccineUpdateForm");
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                decoration: BoxDecoration(color: AppColor.porochiLogoColor),
                child: Center(
                    child: Text("등록하기",
                        style: TextStyle(fontSize: 20, color: Colors.white))),
              ),
            ),
          );
        });
  }

  void _onFormChange() {
    if (_formChanged) return;
    setState(() {
      _formChanged = true;
    });
  }

  Future<bool> _onWillPop() {
    if (!_formChanged) return Future<bool>.value(true);
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("입력을 중지하시겠습니까?\n입력 중인 모든 정보가 사라집니다."),
          actions: <Widget>[
            TextButton(
              child: Text("계속"),
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.porochiLogoColor,
              ),
            ),
            TextButton(
              child: Text("입력 중지"),
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
