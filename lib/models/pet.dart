import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String pid;
  final String uid;
  final String species;
  final String breed;
  final String image;
  final String name;
  final String sex;
  final String birthdate;
  final String registernumber;
  final String? isneutered;
  final List<String>? allergies;
  final String? remarks;

  Pet({
    required this.pid,
    required this.uid,
    required this.species,
    required this.breed,
    required this.image,
    required this.name,
    required this.sex,
    required this.birthdate,
    required this.registernumber,
    this.isneutered,
    this.allergies,
    this.remarks,
  });

  factory Pet.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Pet(
      pid: data?['pid'],
      uid: data?['uid'],
      species: data?['species'],
      breed: data?['breed'],
      image: data?['image'],
      name: data?['name'],
      sex: data?['sex'],
      birthdate: data?['birthdate'],
      registernumber: data?['registernumber'],
      isneutered: data?['isneutered'],
      allergies:
          data?['allergies'] is Iterable ? List.from(data?['allergies']) : null,
      remarks: data?['remarks'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (pid != null) "pid": pid,
      if (uid != null) "uid": uid,
      if (species != null) "species": species,
      if (breed != null) "breed": breed,
      if (image != null) "image": image,
      if (name != null) "name": name,
      if (sex != null) "sex": sex,
      if (birthdate != null) "birthdate": birthdate,
      if (registernumber != null) "registernumber": registernumber,
      if (isneutered != null) "isneutered": isneutered,
      if (allergies != null) "allergies": allergies,
      if (remarks != null) "remarks": remarks,
    };
  }
}
