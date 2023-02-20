import "package:flutter_riverpod/flutter_riverpod.dart";

import '../models/qr.dart';
import "../notifiers/notifier_qr.dart";

final qrNotifierProvider = StateNotifierProvider<QRNotifier, QR?>((ref) {
  return QRNotifier();
});

final qrRepositoryProvider = Provider((ref) {
  return ref.watch(qrNotifierProvider.notifier);
});

final qrProvider = Provider((ref) {
  return ref.watch(qrNotifierProvider);
});
