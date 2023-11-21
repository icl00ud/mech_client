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

      Map<String, dynamic> repairData = {
        'date': '28/10/2003',
        'description': 'Gostaria de fazer um orçamento relacionado a troca de oleo, filtro de ar e pastilhas de freio',
        'plate': 'MJJ-2251',
      };

      // Preencha os controladores do objeto Repair com os dados obtidos.
      repair.date.text = repairData['date'] ?? 'campo vazio';
      repair.description.text = repairData['description'] ?? 'campo vazio';
      repair.plate.text = repairData['plate'] ?? 'campo vazio';
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