import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:wakelock/wakelock.dart';

import '../common/commons.dart';
import '../providers/provider_qr.dart';
import "../constants/qr_serial_numbers.dart";

class QRScanScreen extends ConsumerStatefulWidget {
  const QRScanScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends ConsumerState<QRScanScreen> {
  MobileScannerController mobileScannerController = MobileScannerController();
  String barcodeInfo = "QR 코드를 스캔해보세요.";
  late bool canVibrate;
  bool isFirstDetected = false;

  @override
  void initState() {
    super.initState();
    _init();
    //* 화면 세로 고정
  }

  _init() async {
    canVibrate = await Vibrate.canVibrate;
    canVibrate ? debugPrint('진동 가능 디바이스') : debugPrint('진동 불가능 디바이스');
    Wakelock.enable();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final qrRepository = ref.watch(qrRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR코드 스캐너"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              mobileScannerController.switchCamera();
            },
            icon: const Icon(Icons.camera_rear_outlined),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: mobileScannerController.torchState,
              builder: (context, state, child) {
                if (state == null) {
                  return const Icon(
                    Icons.flash_off,
                    color: Colors.grey,
                  );
                }
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(
                      Icons.flash_off,
                      color: Colors.grey,
                    );
                  case TorchState.on:
                    return const Icon(
                      Icons.flash_on,
                      color: Colors.yellow,
                    );
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => mobileScannerController.toggleTorch(),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: mobileScannerController,
                  allowDuplicates: false,
                  onDetect: (barcode, args) async {
                    //! 플래그 세워서 여러개 QR이 있어 동시인식되어도 최초 하나만 되게끔,
                    if (isFirstDetected == true) return;
                    setState(() {
                      isFirstDetected = true;
                      barcodeInfo = barcode.rawValue!;
                      FlutterBeep.beep();
                      if (canVibrate) Vibrate.feedback(FeedbackType.heavy);
                    });

                    //todo 밥 먹고, 있는건지 아닌건지!
                    if (QrSerialNumbers.contains(barcodeInfo)) {
                      final petId =
                          await qrRepository.getPidFromQid(barcodeInfo);
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        '/pet_tabs',
                        arguments: {'pid': petId},
                      );
                    } else {
                      setState(() {
                        barcodeInfo = "등록되지 않은 일련번호의 QR코드입니다.\n다시 시도해 주세요.";
                        isFirstDetected = false;
                      });
                    }
                  },
                ),
                QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
                child: Text(
              barcodeInfo,
              textAlign: TextAlign.center,
            )),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    //* 가로고정 혹은 세로고정 해제
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
    Wakelock.disable();
  }
}
