import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RepairRequestWidget extends StatelessWidget {
  final String requestTitle;
  final String requestDetails;

  const RepairRequestWidget({
    Key? key,
    required this.requestTitle,
    required this.requestDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 2,
            offset: Offset(2, 1.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            requestTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            requestDetails,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}