import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPets {
  final String vet;
  final int dose;
  final String lastdate;
  final String nextdate;

  UsersPets({
    required this.vet,
    required this.dose,
    required this.lastdate,
    required this.nextdate,
  });

  factory UsersPets.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UsersPets(
      vet: data?['vet'],
      dose: data?['dose'],
      lastdate: data?['lastdate'],
      nextdate: data?['nextdate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (vet != null) "vet": vet,
      if (dose != null) "dose": dose,
      if (lastdate != null) "lastdate": lastdate,
      if (nextdate != null) "nextdate": nextdate,
    };
  }
}
