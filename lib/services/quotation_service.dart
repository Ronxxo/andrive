import 'package:cloud_firestore/cloud_firestore.dart';

class QuotationService {
  final CollectionReference quotations = FirebaseFirestore.instance.collection(
    'quotations',
  );

  Future<void> saveQuotation({
    required String name,
    required String email,
    required String phone,
    required String trailerName,
    required String trailerDetails,
    required double price,
    String? imagePath,
    DateTime? date,
    required String details,
  }) async {
    await quotations.add({
      'name': name,
      'email': email,
      'phone': phone,
      'trailerName': trailerName,
      'trailerDetails': trailerDetails,
      'price': price,
      'imagePath': imagePath,
      'date': date ?? DateTime.now(),
    });
  }
}
