import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import "dart:developer" as developer;
import '../models/pet.dart';
import '../models/vaccine.dart';

Map<String, List<String>> speciesVaccineMap = {
  "강아지": [
    "종합예방접종\n(DHPPL)",
    "코로나바이러스장염\n(Coronavirus)",
    "기관ㆍ기관지염\n(Kennel Cough)",
    "독감접종\n(Influenza)",
    "심장사상충\n내부기생충",
    "외부기생충",
    "광견병",
  ],
  "고양이": [
    "혼합예방주사\n(CVRP)",
    "고양이백혈병\n(Feline Leukemia)",
    "전염성복막염\n(FIP)",
    "광견병",
  ],
};

//! 이게 아직 list가 안됐습니다
class PetNotifier extends StateNotifier<List<Pet?>> {
  PetNotifier() : super([]);
  FirebaseFirestore db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  //todo PetProfile은 따로 할 수 있도록, 모델에서 빼야합니다.
  Future<Pet?> getPet(String pid) async {
    try {
      final petCollRef = db.collection("pets").withConverter(
          fromFirestore: Pet.fromFirestore,
          toFirestore: (Pet pet, options) => pet.toFirestore());

      //todo pid, 즉 doc 이름을 어떻게 가져올 것인가?
      final docSnap = await petCollRef.doc(pid).get();
      final pet = docSnap.data();
      state = [pet];
      developer.log("Fetching pet $pid successuful", name: "getPet");
      return state[0];
    } catch (e) {
      developer.log("Fetching pet $pid failed", error: e, name: "getPet");
      throw (e);
    }
  }

  // 그럼 얘가 어디서 쓰이느냐...
  Future<String?> addPet(Pet pet) async {
    //! params로 넣을건데, 타입이 File이거든?
    //todo flutter에서의 File...
    //todo 노노 filepath가 있네요. File 타입이 맞고, 그러면 putFileaksgownaus ehlqslek.
    try {
      final petCollRef = db.collection("pets").withConverter(
          fromFirestore: Pet.fromFirestore,
          toFirestore: (Pet pet, options) => pet.toFirestore());
      final docSnap = await petCollRef.add(pet);
      final pid = docSnap.id;

//       try {
//         //? storage filepath는 일단 정함

//         final petProfileRef = storageRef.child("pets/profiles/$pid.jpg");
//         await petProfileRef.putFile(petProfile);
//         //todo
// //todo Once you've created an appropriate reference, you then call the putFile(), putString(), or putData() method to upload the file to Cloud Storage.

//         developer.log("Pet profile image successfully stored",
//             name: "petProfileStorageRef");
//       } catch (e) {
//         developer.log("Pet profile image successfully stored",
//             error: e, name: "petProfileStorageRef");
//         throw (e);
//       }

      developer.log("key-value successfully matched at speciesVaccineMap",
          name: "speciesVaccineMap");

      final vaccineCollRef = db
          .collection("pets")
          .doc(pid)
          .collection("vaccines")
          .withConverter(
              fromFirestore: Vaccine.fromFirestore,
              toFirestore: (Vaccine vaccine, options) => vaccine.toFirestore());

      List<String> vaccines = speciesVaccineMap[pet.species]!;
      developer.log("key-value successfully matched at speciesVaccineMap",
          name: "speciesVaccineMap");

      var now = DateTime.now();
      String formatDate = DateFormat('yyyy.MM.dd').format(now);

      for (int i = 0; i < vaccines.length; i++) {
        await vaccineCollRef.doc(vaccines[i]).set(
              Vaccine(
                vname: vaccines[i],
                vet: "미지정",
                dose: 0,
                lastdate: formatDate,
                nextdate: formatDate,
              ),
            );
      }
      developer.log("Adding pet $pid successuful", name: "addPet");

      await updatePet(pid, {"pid": pid});
      return pid;
    } catch (e) {
      developer.log("Adding pet failed", error: e, name: "addPet");
    }
  }

  // //todo 리스트로합시다
  // Future<List<DocumentChange<Pet>>> getAllPetsofUser(String uid) async {
  //   try {
  //     final petCollRef = db.collection("pets").withConverter(
  //         fromFirestore: Pet.fromFirestore,
  //         toFirestore: (Pet pet, options) => pet.toFirestore());

  //     //* 이건가...
  //     final docSnap = await petCollRef.where("uid", isEqualTo: uid).get();
  //     final usersPets = docSnap.docChanges;
  //     developer.log("Fetching all pets of the user $uid successful",
  //         name: "getAllPetsofUser");
  //     return usersPets;
  //   } catch (e) {
  //     developer.log("Fetching all pets of the user $uid failed",
  //         error: e, name: "getAllPetsofUser");
  //     throw (e);
  //   }
  // }

  Future<List<Pet>> getAllPetsofUser(String uid) async {
    try {
      final petCollRef = db.collection("pets").withConverter(
          fromFirestore: Pet.fromFirestore,
          toFirestore: (Pet pet, options) => pet.toFirestore());

      //* 이건가...
      final docSnap = await petCollRef.where("uid", isEqualTo: uid).get();
      final usersPets = docSnap.docs
          .map((usersPetSnapshot) => usersPetSnapshot.data())
          .toList();

      state = usersPets;
      developer.log("Fetching all pets of the user $uid successful",
          name: "getAllPetsofUser");
      return usersPets;
    } catch (e) {
      developer.log("Fetching all pets of the user $uid failed",
          error: e, name: "getAllPetsofUser");
      throw (e);
    }
  }

  //todo 아직 안쓰임
  Future updatePet(String pid, Map<String, dynamic> updates) async {
    try {
      final petCollRef = db.collection("pets").withConverter(
          fromFirestore: Pet.fromFirestore,
          toFirestore: (Pet pet, options) => pet.toFirestore());

      final docSnap = petCollRef.doc(pid).update(updates);
      developer.log("Updating pet $pid successful", name: "updatePet");
    } catch (e) {
      developer.log("Updating pet $pid failed", error: e, name: "updatePet");
    }
  }
}
