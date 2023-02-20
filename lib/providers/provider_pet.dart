import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet.dart';
import "../notifiers/notifier_pet.dart";
import "../providers/provider_auth.dart";

final petNotifierProvider =
    StateNotifierProvider<PetNotifier, List<Pet?>>((ref) {
  return PetNotifier();
});
// final petNotifierProvider = StateNotifierProvider<PetNotifier, Pet?>((ref) {
//   return PetNotifier();
// });

final petRepositoryProvider = Provider((ref) {
  return ref.watch(petNotifierProvider.notifier);
});

// final petProvider = Provider((ref) {
//   return ref.watch(petNotifierProvider);
// });

// //* pet은 유저와 다르게 여러 pet
final petProvider = FutureProvider.family<Pet?, String>((ref, pid) {
  final petRepository = ref.watch(petRepositoryProvider);
  final pet = petRepository.getPet(pid);
  return pet;
});

final allPetsofUserProvider = Provider.family<List<Pet?>, String>((ref, uid) {
  final petRepository = ref.watch(petRepositoryProvider);
  petRepository.getAllPetsofUser(uid);
  return ref.watch(petNotifierProvider);
});

// final allPetsofUserProvider =
//     FutureProvider.family<List<DocumentChange<Pet>>, String>((ref, uid) {
//   final petRepository = ref.watch(petRepositoryProvider);
//   final userPets = petRepository.getAllPetsofUser(uid);
//   return userPets;
// });
