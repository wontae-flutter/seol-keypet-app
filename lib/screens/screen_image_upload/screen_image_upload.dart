import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

//! camera_app에는 저장한 사진을 가져와서 프리뷰로 보여주는데... 요 부분에서 막힌다면 그것도 필요하다

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //* 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future getImage(ImageSource imageSource) async {
    //* 카메라와 갤러리에서 이미지를 가져온다. 면. 이게 이전꺼에서 가져와야하는거 아냐?
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path);
    });
  }

  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path))));
    //! 요 이미지가 현재 위젯 밖으로 나가야하는데 그게 안 되지...
    //! 유저 정보에 이미지로 들어가있으면 되지 않을까
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("사진 등록하기"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25.0),
            showImage(),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 카메라 촬영 버튼
                FloatingActionButton(
                  heroTag: "taking button",
                  child: Icon(Icons.add_a_photo),
                  tooltip: 'take photos',
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  heroTag: "fetching button",
                  child: Icon(Icons.wallpaper),
                  tooltip: 'fetch image',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //* 가로고정 혹은 세로고정 해제
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
  }
}
