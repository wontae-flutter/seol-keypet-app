// ignore_for_file: prefer_const_constructors

import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porocci_main/common/DogImage.dart';
import 'package:porocci_main/models/pet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import "dart:developer" as developer;
import '../providers/provider_auth.dart';
import '../providers/provider_pet.dart';
import '../providers/provider_qr.dart';
import '../styles/styles.dart';
import "../constants/qr_serial_numbers.dart";

class PetRegisterScreen extends ConsumerStatefulWidget {
  const PetRegisterScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PetRegisterScreenState();
}

class _PetRegisterScreenState extends ConsumerState<PetRegisterScreen> {
  final formKey = GlobalKey<FormState>();
  File? petProfile;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    //* 카메라와 갤러리에서 이미지를 가져온다. 면. 이게 이전꺼에서 가져와야하는거 아냐?
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      petProfile = File(image!.path);
    });
  }

  void showImagePicker(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('갤러리에서 가져오기'),
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('새로운 사진 찍기'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  String petImagePath =
      "https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074__340.jpg";
  String? name;
  String? birthdate;
  String species = "강아지";
  String breed = "요크셔테리어";
  String sex = "남아";
  String isneutered = "완료";
  String? registernumber = "11-1111111";
  bool _formChanged = false;
  String qid = "";

  @override
  Widget build(BuildContext context) {
    final petRepository = ref.watch(petRepositoryProvider);
    final qrRepository = ref.watch(qrRepositoryProvider);
    String? uid = ref.watch(uidProvider);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.backspace_rounded),
        // onPressed: () => Navigator.of(context).pushReplacementNamed("/home"),
        // ),
        title: Text("반려동물 등록"),
        shape: Border(bottom: BorderSide(color: Colors.black26)),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.home))],
      ),
      body: Center(
        child: Container(
          padding: AppLayout.formPageContainerPadding,
          child: Form(
            key: formKey,
            onChanged: _onFormChange,
            onWillPop: _onWillPop,
            autovalidateMode: AutovalidateMode.always,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                DogImage(image: "image"),
                // CameraButton(
                //     petProfile: petProfile, showImagePicker: showImagePicker),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "반려동물 이름",
                    hintText: "이름을 입력해주세요. (2~10 글자/영문/한글)",
                  ),
                  onSaved: (String? value) {
                    name = value;
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? '이름을 입력해주세요. (2~10 글자/영문/한글)'
                      : null,
                ),
                SizedBox(height: 15),
                // DropdownButtonFormField(
                //   // borderRadius: BorderRadius.circular(6),
                //   decoration: InputDecoration(
                //     labelText: "품/품종 선택",
                //     border: OutlineInputBorder(),
                //   ),
                //   value: species,
                //   onSaved: (String? value) {
                //     species = value!;
                //   },
                //   onChanged: (String? value) {
                //     setState(() {
                //       species = value!;
                //     });
                //   },
                //   items: <String>['강아지', '고양이', 'Tiger', 'Lion']
                //       .map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value, style: TextStyle(fontSize: 20)),
                //     );
                //   }).toList(),
                // ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "생년월일",
                    hintText: "YYYY.MM.DD",
                  ),
                  onSaved: (String? value) {
                    birthdate = value!;
                  },
                  validator: (value) =>
                      isDate(value!) ? null : "정확한 날짜 형식을 입력해주세요.",
                ),
                SizedBox(height: 15),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "성별",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "남아",
                        groupValue: sex,
                        onChanged: (value) {
                          setState(() {
                            sex = value!;
                          });
                        },
                      ),
                      Text("남아"),
                      Radio(
                        value: "여아",
                        groupValue: sex,
                        onChanged: (value) {
                          setState(() {
                            sex = value!;
                          });
                        },
                      ),
                      Text("여아")
                    ],
                  ),
                ]),
                SizedBox(height: 15),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "중성화",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "완료",
                        groupValue: isneutered,
                        onChanged: (value) {
                          setState(() {
                            isneutered = value!;
                          });
                        },
                      ),
                      Text("완료"),
                      Radio(
                        value: "미완료",
                        groupValue: isneutered,
                        onChanged: (value) {
                          setState(() {
                            isneutered = value!;
                          });
                        },
                      ),
                      Text("미완료")
                    ],
                  ),
                ]),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "동물 등록번호",
                    hintText: "동물 등록번호를 입력해 주세요.",
                  ),
                  onSaved: (String? value) {
                    registernumber = value!;
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? '정확한 형식의 동물 등록번호를 입력해 주세요.'
                      : null,
                ),
                SizedBox(height: 15),
                //todo 이거 해야해!
                QRRegisterButton(qid: qid),
              ],
            ),
          ),
        ),
      ),
      //todo 여기서 Formstate.state save해서 보내던가 해야함
      bottomSheet: InkWell(
        onTap: () async {
          if (formKey.currentState!.validate()) {
            developer.log("Pet register form input is valid",
                name: "petRegisterForm");

            try {
              formKey.currentState!.save();
              developer.log(
                  "Pet register form's current state is NOT null, hence input is saved",
                  name: "petRegisterForm");
            } catch (e) {
              developer.log(
                  "Pet register form's current state IS null, hence input is NOT saved",
                  error: e,
                  name: "petRegisterForm");
            }

            try {
              final petId = await petRepository.addPet(
                Pet(
                  pid: "",
                  uid: uid!,
                  species: species,
                  breed: breed,
                  image: petImagePath,
                  name: name!,
                  sex: sex,
                  isneutered: isneutered,
                  birthdate: birthdate!,
                  registernumber: registernumber!,
                ),
              );

// await petRepository.ge
              //todo 이 qid 가지고...
              //! pid를 못 가져오는구나
              await qrRepository.matchPidToQid(petId!, qid);

              // petProfile!);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("펫 등록 성공"),
                ));
              Navigator.of(context).pushReplacementNamed("/home");
            } catch (e) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("펫 등록 실패"),
                ));
              throw (e);
            }
          } else {
            developer.log("Pet register form input is NOT valid",
                name: "petRegisterForm");
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
  }

  isDate(String value) {
    String pattern = r'^[\d]{4}.[\d]{2}.[\d]{2}$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value) ? true : false;
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
                  // foregroundColor: AppColor.porochiLogoColor,
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

//todo 카메라버튼에 기능좀 넣어봤음

class CameraButton extends StatelessWidget {
  File? petProfile;
  Function showImagePicker;
  CameraButton({
    super.key,
    required this.petProfile,
    required this.showImagePicker,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: () {
          //todo 카메라 기능을 서포트하는 image_upload로 가야지
          // Navigator.of(context).pushNamed("/image_upload");
        },
        child: Stack(
          children: [
            petProfile != null
                ? Image.file(
                    File(petProfile!.path),
                    width: 80,
                  )
                : Image.asset(
                    "assets/images/logo/logo_rect.png",
                    width: 80,
                  ),
            Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(3),
                    child: Icon(IconData(0xef1e, fontFamily: 'MaterialIcons'))))
          ],
        ),
      ),
    );
  }
}

class QRRegisterButton extends StatelessWidget {
  String qid;
  QRRegisterButton({super.key, required this.qid});

  //todo 이것도 버튼이 있으려나?
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.porochiLogoColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () async {
        //todo 여기에 이미 등록되어있는지 안되어있는지 로직 가진 애들이 필요하겠지
        final String args =
            await Navigator.pushNamed(context, "/qr_register") as String;
        String resultMsg;
        try {
          if (QrSerialNumbers.contains(args)) {
            qid = args;
          }
          resultMsg = "일련번호 $qid 등록 성공";
        } catch (e) {
          // throw (e);
          resultMsg = "등록되지 않은 일련번호의의 QR코드입니다.";
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(resultMsg),
          ));
      },
      child: Text(
        "QR 일련번호 등록하기",
      ),
    );
  }
}
