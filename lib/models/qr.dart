import 'package:cloud_firestore/cloud_firestore.dart';

class QR {
  final String qid;
  final String pid;

  QR({
    required this.qid,
    required this.pid,
  });

  factory QR.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return QR(
      qid: data?['qid'],
      pid: data?['pid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (qid != null) "qid": qid,
      if (pid != null) "pid": pid,
    };
  }
}
