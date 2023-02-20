import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vaccine.dart';
import '../models/pet.dart';
import "../notifiers/notifier_vaccine.dart";
import "../providers/provider_pet.dart";

final vaccineNotifierProvider =
    StateNotifierProvider<VaccineNotifier, List<Vaccine?>>((ref) {
  return VaccineNotifier();
});

final vaccineRepositoryProvider = Provider((ref) {
  return ref.watch(vaccineNotifierProvider.notifier);
});

final vaccineProvider = Provider((ref) {
  return ref.watch(vaccineNotifierProvider);
});

final allVaccinesOfPetProvider =
    FutureProvider.autoDispose.family<List<Vaccine?>, String>((ref, pid) {
  final petRepository = ref.watch(vaccineRepositoryProvider);
  petRepository.getAllVaccinesofPet(pid);
  final allVaccinesOfPet = ref.watch(vaccineProvider);
  return allVaccinesOfPet;
});
