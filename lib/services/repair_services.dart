import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RepairServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createRepair({
    required String title,
    required String description,
    required String plate,
    required String model,
    required String year,
    required String motor,
  }) async {
    try {
      String userId = _firebaseAuth.currentUser!.uid;

      await _firestore.collection('Repairs').add({
        'userId': userId,
        'title': title,
        'description': description,
        'plate': plate,
        'model': model,
        'year': year,
        'motor': motor,
        'assigned_mechanic_id': null,
        'is_accepted': false,
        'dt_creation': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao solicitar serviço: $e');
      throw e;
    }
  }

  Stream<List<Map<String, dynamic>>> getAcceptedRequests() {
    return _firestore
        .collection('Repairs')
        .where('userId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return doc.data()!;
      }).toList();
    });
  }
}