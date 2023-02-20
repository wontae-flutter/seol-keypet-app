import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccine {
  final String vname;
  final String vet;
  final int dose;
  final String lastdate;
  final String nextdate;

  Vaccine({
    required this.vname,
    required this.vet,
    required this.dose,
    required this.lastdate,
    required this.nextdate,
  });

  factory Vaccine.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Vaccine(
      vname: data?['vname'],
      vet: data?['vet'],
      dose: data?['dose'],
      lastdate: data?['lastdate'],
      nextdate: data?['nextdate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (vname != null) "vname": vname,
      if (vet != null) "vet": vet,
      if (dose != null) "dose": dose,
      if (lastdate != null) "lastdate": lastdate,
      if (nextdate != null) "nextdate": nextdate,
    };
  }
}
