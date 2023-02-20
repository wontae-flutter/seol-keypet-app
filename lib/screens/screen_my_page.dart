import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:go_router/go_router.dart';

import "dart:developer" as developer;

import '../models/user_detail.dart';
import '../../common/commons.dart';
import '../providers/provider_auth.dart';
import '../styles/styles.dart';
import "../utils/form_utils.dart";

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? name;
  String? nickName;
  // String? email;
  String usertype = "보호자";
  // String? homeBackgroundImagePath;
  // String? vetCertificate;

  bool _formChanged = false;
  //* user 프로바이더로 가져오면 됩니다...... 모델 프로바이더 어떻게 하더라??, no
  //* 이미지를 가져와야지... register button들이 각각 이미지를 보여주는것으로 바뀌면 됩니다.

  // 이미지는 따로 해볼까?
  File? _image;
  File? vetCertiImage;
  File? homeBackgroundImage;
  final picker = ImagePicker();
  //! 클로져?
  Future getImage(ImageSource imageSource) async {
    //* 카메라와 갤러리에서 이미지를 가져온다. 면. 이게 이전꺼에서 가져와야하는거 아냐?
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path);
    });
  }

  //!! 사용되지 않고 있습니다
  Future uploadFile() async {
    if (_image == null) return;
    final fileName = Path.basename(_image!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_image!);
    } catch (e) {
      print('error occured');
    }
  }

  void showImagePicker(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
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
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    String? uid = ref.watch(uidProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("마이페이지"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: Colors.black26)),
        elevation: 0.0,
      ),
      // endDrawer: Drawer(),
      body: Container(
        padding: AppLayout.formPageContainerPadding,
        child: Form(
          key: formKey,
          onChanged: _onFormChange,
          onWillPop: _onWillPop,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              MainLogo(),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "이름",
                  hintText: "이름을 입력해주세요.",
                ),
                onSaved: (String? value) {
                  name = value;
                },
                validator: (value) =>
                    (value == null || value.isEmpty) ? '이름을 입력해주세요.' : null,
              ),
              SizedBox(height: 10),
              // TextFormField(
              //   decoration: InputDecoration(
              //     labelText: "이메일",
              //     hintText: "이메일을 입력해주세요.",
              //   ),
              //   onSaved: (String? value) {
              //     email = value;
              //   },
              //   validator: (value) =>
              //       isEmail(value!) ? null : "정확한 이메일 형식을 입력해주세요.",
              // ),
              // SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "닉네임",
                  hintText: "닉네임을 입력해주세요.",
                ),
                onSaved: (String? value) {
                  nickName = value;
                },
                validator: (value) =>
                    (value == null || value.isEmpty) ? '닉네임을 입력해주세요.' : null,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploadArea(
                    image: _image,
                    showImagePicker: showImagePicker,
                    title: "홈화면 배경사진 바꾸기",
                    aspectRatio: 2 / 3,
                  ),
                  Text("역할", style: TextStyle(color: Colors.grey)),
                  FormField(builder: (context) {
                    return Row(
                      children: [
                        Radio(
                          value: "보호자",
                          groupValue: usertype,
                          onChanged: (inValue) {
                            setState(() {
                              usertype = inValue!;
                            });
                          },
                        ),
                        Text("보호자"),
                        Radio(
                          value: "수의사",
                          groupValue: usertype,
                          onChanged: (inValue) {
                            setState(() {
                              usertype = inValue!;
                            });
                          },
                        ),
                        Text("수의사")
                      ],
                    );
                  }),
                  Visibility(
                    visible: usertype == "수의사",
                    child: ImageUploadArea(
                        image: _image,
                        showImagePicker: showImagePicker,
                        title: "수의사 면허증 등록하기",
                        aspectRatio: 1 / 1.414),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: _formChanged
            ? () async {
                if (formKey.currentState!.validate()) {
                  developer.log("Userdetail update form input is valid",
                      name: "userDetailUpdateForm");

                  try {
                    formKey.currentState!.save();
                    developer.log(
                        "Userdetail update form's current state is NOT null, hence input is saved",
                        name: "userDetailUpdateForm");
                  } catch (e) {
                    developer.log(
                        "Userdetail update form's current state IS null, hence input is NOT saved",
                        error: e,
                        name: "userDetailUpdateForm");
                  }
                  try {
                    await authRepository.updateUserDetail(uid!, {
                      "name": name,
                      "nickName": nickName,
                      // "email": email!,
                      "usertype": usertype
                    });
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("내 정보 수정 성공"),
                      ));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("내 정보 수정 실패"),
                      ));
                  }
                } else {
                  developer.log("Userdetail update form input is NOT valid",
                      name: "userDetailUpdateForm");
                }
              }
            : null,
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

  isEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
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

//! 나중에 form으로 돌아올 수 있게, 이미지를 올리는 법
class ImageUploadArea extends StatelessWidget {
  Function showImagePicker;
  File? image;
  double aspectRatio;
  String title;
  ImageUploadArea(
      {super.key,
      required this.image,
      required this.showImagePicker,
      required this.aspectRatio,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: AppText.homeScreenTitle,
          ),
        ),
        Container(
          margin: AppLayout.containerInsideListviewMargin,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.black12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1,
                    spreadRadius: 1.0,
                    offset: Offset(1.0, 1.0)),
              ]),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: image != null
                ? Image.file(image!)
                : InkWell(
                    onTap: () {
                      showImagePicker(context);
                    },
                    child: Icon(
                      IconData(0xee3c, fontFamily: 'MaterialIcons'),
                      size: 70,
                      color: Colors.black38,
                    ),
                  ),
            // SizedBox(height: 10),
          ),
        ),
      ],
    );
  }
}

//! 이것도 수의사면허증이랑 같이 넣으면 되겠네요.
//! 여전히 반대 화면으로 가져가게끔 해야 되네.
class HeroImageEditButton extends StatelessWidget {
  const HeroImageEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.blue),
        onPressed: () {
          Navigator.of(context).pushNamed("/image_upload");
          // context.go('/image_upload');
        },
        child: Text(
          "홈커버 편집",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ));
  }
}
