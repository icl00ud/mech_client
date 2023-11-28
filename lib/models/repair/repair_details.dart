import 'package:cloud_firestore/cloud_firestore.dart';

class RepairDetails {
  final String title;
  final String description;
  final String creationDate;
  final String assignedMechanic;
  final String status;
  final String carModel;
  final String plate;
  final String documentId;

  RepairDetails({
    required this.title,
    required this.description,
    required this.creationDate,
    required this.assignedMechanic,
    required this.status,
    required this.carModel,
    required this.plate,
    required this.documentId
  });
}