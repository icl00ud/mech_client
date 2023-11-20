import 'package:mech_client/models/repair_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RepairServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void getRepair(Repair repair) async {
    try {
      // Substitua esta parte com a lógica para obter os dados do veículo
      // a partir da sua fonte de dados (por exemplo, Firebase Firestore).
      // Você precisa adaptar isso de acordo com a estrutura do seu banco de dados.
      // Aqui estou usando dados fictícios para fins de demonstração.

      Map<String, dynamic> repairData = {
        'date': '28/10/2003',
        'description':
            'Gostaria de fazer um orçamento relacionado a troca de oleo, filtro de ar e pastilhas de freio',
        'plate': 'MJJ-2251',
      };

      // Preencha os controladores do objeto Repair com os dados obtidos.
      repair.date.text = repairData['date'] ?? 'campo vazio';
      repair.description.text = repairData['description'] ?? 'campo vazio';
      repair.plate.text = repairData['plate'] ?? 'campo vazio';
    } catch (e) {
      print('Erro ao obter informações do conserto: $e');
    }
  }
}
