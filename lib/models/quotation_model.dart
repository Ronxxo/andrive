import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_trailer_quotation/models/trailer_base_model.dart';
import 'trailer_model.dart';
import 'component_model.dart';

class Quotation {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final TrailerModel? predefinedTrailer;
  final TrailerBase? trailerBase;
  final List<Component> components;
  final double totalPrice;
  final DateTime date;
  final String? pdfUrl;

  Quotation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    this.predefinedTrailer,
    this.trailerBase,
    this.components = const [],
    required this.totalPrice,
    required this.date,
    this.pdfUrl,
  }) : assert(totalPrice >= 0, 'El precio total no puede ser negativo'),
       assert(
         userName.isNotEmpty,
         'El nombre del usuario no puede estar vacío',
       ),
       assert(
         userEmail.isNotEmpty,
         'El correo del usuario no puede estar vacío',
       ),
       assert(
         userPhone.isNotEmpty,
         'El teléfono del usuario no puede estar vacío',
       );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'predefinedTrailer': predefinedTrailer?.toMap(),
      'trailerBase': trailerBase?.toMap(),
      'components': components.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'date': Timestamp.fromDate(date),
      'pdfUrl': pdfUrl,
    };
  }

  static Quotation fromMap(Map<String, dynamic> map) {
    return Quotation(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPhone: map['userPhone'] ?? '',
      predefinedTrailer:
          map['predefinedTrailer'] != null
              ? TrailerModel.fromJson(map['predefinedTrailer'])
              : null,
      trailerBase:
          map['trailerBase'] != null
              ? TrailerBase.fromMap(map['trailerBase'])
              : null,
      components:
          map['components'] != null
              ? List<Component>.from(
                map['components']?.map((x) => Component.fromMap(x)),
              )
              : [],
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      date: (map['date'] as Timestamp).toDate(),
      pdfUrl: map['pdfUrl'],
    );
  }

  double calculateTotalPrice() {
    double basePrice = trailerBase?.price ?? 0;
    double componentsPrice = components.fold(
      0,
      (sum, component) => sum + component.price,
    );
    return basePrice + componentsPrice;
  }

  String formattedDate() {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  String toString() {
    return 'Quotation(id: $id, userName: $userName, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quotation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
