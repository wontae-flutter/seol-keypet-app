import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import "dart:developer" as developer;
import '../models/vaccine.dart';

class VaccineNotifier extends StateNotifier<List<Vaccine?>> {
  VaccineNotifier() : super([]);
  FirebaseFirestore db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<Vaccine?> getVaccine(String pid, String vname) async {
    try {
      final vaccineCollRef = db
          .collection("pets")
          .doc(pid)
          .collection("vaccines")
          .withConverter(
              fromFirestore: Vaccine.fromFirestore,
              toFirestore: (Vaccine vaccine, options) => vaccine.toFirestore());

      final docSnap = await vaccineCollRef.doc(vname).get();
      final vaccine = docSnap.data();
      state = [vaccine];
      developer.log("Fetching vaccine $vname of pet $pid successuful",
          name: "getVaccine");
      return state[0];
    } catch (e) {
      developer.log("Fetching vaccine $vname of pet $pid failed",
          error: e, name: "getVaccine");
      return null;
    }
  }

  Future updateVaccine(
      String pid, String vname, Map<String, dynamic> updates) async {
    try {
      final vaccineCollRef = db
          .collection("pets")
          .doc(pid)
          .collection("vaccines")
          .withConverter(
              fromFirestore: Vaccine.fromFirestore,
              toFirestore: (Vaccine vaccine, options) => vaccine.toFirestore());

      await vaccineCollRef.doc(vname).update(updates);
      await getVaccine(pid, vname);

      developer.log("Updating vaccine with pet $pid successful",
          name: "updateVaccine");
    } catch (e) {
      developer.log("Updating vaccine with pet $pid failed",
          error: e, name: "updateVaccine");
    }
  }

  Future<List<Vaccine>> getAllVaccinesofPet(String pid) async {
    try {
      final vaccineCollRef = db
          .collection("pets")
          .doc(pid)
          .collection("vaccines")
          .withConverter(
              fromFirestore: Vaccine.fromFirestore,
              toFirestore: (Vaccine vaccine, options) => vaccine.toFirestore());

      //todo pid, 즉 doc 이름을 어떻게 가져올 것인가?
      final docSnap = await vaccineCollRef.get();
      final vaccines = docSnap.docs
          .map((vaccineSnapshot) => vaccineSnapshot.data())
          .toList();
      developer.log("Fetching all the vaccines of the pet $pid successuful",
          name: "getAllVaccinesofPet");
      state = vaccines;
      return vaccines;
    } catch (e) {
      developer.log("Fetching all the vaccines of the pet $pid failed",
          error: e, name: "getAllVaccinesofPet");
      throw (e);
    }
  }
}
