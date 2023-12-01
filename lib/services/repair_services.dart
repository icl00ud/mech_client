// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mech_client/services/user_services.dart';

import '../models/account_user_model.dart';

class RepairServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserServices userServices = UserServices();

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

      AccountUser? user = await userServices.getUserByUid(userId);

      if (user != null) {
        DocumentReference documentReference =
            await _firestore.collection('Repairs').add({
          'customer': user.toMap(),
          'title': title,
          'description': description,
          'plate': plate,
          'model': model,
          'year': year,
          'motor': motor,
          'assigned_mechanic_id': null,
          'status': 'pending',
          'dt_creation': FieldValue.serverTimestamp(),
          'id': '',
        });

        String repairId = documentReference.id;
        await documentReference.update({'id': repairId});
      } else {
        print('Usuário não encontrado para criar a solicitação de serviço.');
      }
    } catch (e) {
      print('Erro ao adicionar serviço: $e');
      throw e;
    }
  }

  Stream<List<Map<String, dynamic>>> getAcceptedRequestsForCustomer() {
    return _firestore
        .collection('Repairs')
        .where('customer.userId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return doc.data()!;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getPendingRequestsForCustomer() {
    return _firestore
        .collection('Repairs')
        .where('customer.userId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return doc.data()!;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getPendingRequestsForMechanic() {
    return _firestore
        .collection('Repairs')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return doc.data()!;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getAcceptedRequestsForMechanic() {
    return _firestore
        .collection('Repairs')
        .where('assigned_mechanic_id',
            isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return doc.data()!;
      }).toList();
    });
  }

  Future<void> deleteRepair(String repairId) async {
    try {
      await _firestore.collection('Repairs').doc(repairId).delete();
    } catch (e) {
      print('Erro ao excluir reparo: $e');
      throw e;
    }
  }

  Future<void> confirmRepairAssignment(String repairId) async {
    try {
      String currentUserId = _firebaseAuth.currentUser!.uid;
      await _firestore.collection('Repairs').doc(repairId).update({
        'assigned_mechanic_id': currentUserId,
        'status': 'accepted',
      });
    } catch (e) {
      print('Erro ao confirmar atribuição de reparo: $e');
      throw e;
    }
  }

  Future<String> getMechanicName(String mechanicId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> mechanicSnapshot =
          await _firestore.collection('Users').doc(mechanicId).get();

      if (mechanicSnapshot.exists) {
        String mechanicName = mechanicSnapshot.data()?['name'] ?? '';
        return mechanicName;
      } else {
        return 'Aguardando ser aceito por alguma mecânica';
      }
    } catch (e) {
      print('Erro ao obter nome do mecânico: $e');
      throw e;
    }
  }

  Future<List<String>> getPlates(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        List<String> plates =
            (userSnapshot.data()?['vehicles'] ?? <String>[]).cast<String>();
        return plates;
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao obter placas: $e');
      throw e;
    }
  }
}
