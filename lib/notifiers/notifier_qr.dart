import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import "dart:developer" as developer;
import '../models/qr.dart';

//! 이게 아직 list가 안됐습니다
class QRNotifier extends StateNotifier<QR?> {
  QRNotifier() : super(null);
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> getPidFromQid(String qid) async {
    try {
      final qrCollRef = db.collection("qrs").withConverter(
          fromFirestore: QR.fromFirestore,
          toFirestore: (QR qr, options) => qr.toFirestore());

      final docSnap = await qrCollRef.doc(qid).get();
      final qr = docSnap.data();
      final pid = qr!.pid;
      developer.log("Getting pid $pid from qid $qid successuful",
          name: "matchPidToQid");
      return pid;
    } catch (e) {
      developer.log("Getting pid from qid $qid failed",
          error: e, name: "matchPidToQid");
      throw (e);
    }
  }

  Future matchPidToQid(String pid, String qid) async {
    try {
      final qrCollRef = db.collection("qrs").withConverter(
          fromFirestore: QR.fromFirestore,
          toFirestore: (QR qr, options) => qr.toFirestore());

      final docSnap = await qrCollRef.doc(qid).set(QR(qid: qid, pid: pid));
      // final qr = docSnap.data();
      // state = qr;

      developer.log("Matching pid $pid with qid $qid successuful",
          name: "matchPidToQid");
    } catch (e) {
      developer.log("Matching pid $pid with qid $qid failed",
          error: e, name: "matchPidToQid");
      throw (e);
    }
  }
}
