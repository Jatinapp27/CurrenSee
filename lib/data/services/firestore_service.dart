import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // A helper to get the current user ID
  String? get _userId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> saveConversion({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
    required double toAmount,
    required double rate,
  }) async {
    if (_userId == null) return;
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('conversions')
          .add({
        'fromCurrency': fromCurrency,
        'toCurrency': toCurrency,
        'fromAmount': fromAmount,
        'toAmount': toAmount,
        'rate': rate,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving conversion: $e");
    }
  }

  Stream<QuerySnapshot> getConversionHistory() {
    if (_userId == null) return Stream.empty();
    return _db
        .collection('users')
        .doc(_userId)
        .collection('conversions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> setDefaultBaseCurrency(String currencyCode) async {
    if (_userId == null) return;
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .update({'defaultBaseCurrency': currencyCode});
    } catch (e) {
      print("Error saving preference: $e");
    }
  }

  Stream<DocumentSnapshot> getUserPreferences() {
    if (_userId == null) return Stream.empty();
    return _db.collection('users').doc(_userId).snapshots();
  }
}