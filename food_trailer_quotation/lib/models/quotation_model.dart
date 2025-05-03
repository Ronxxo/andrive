import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_trailer_quotation/models/trailer_base_model.dart';
import 'trailer_model.dart';
import 'component_model.dart';

class Quotation {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final TrailerModel? predefinedTrailer;
  final TrailerBase? trailerBase;
  final List<Component> components;
  final double totalPrice;
  final DateTime date;

  Quotation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.predefinedTrailer,
    this.trailerBase,
    this.components = const [],
    required this.totalPrice,
    required this.date,
  }) : assert(totalPrice >= 0, 'El precio total no puede ser negativo'),
       assert(
         userName.isNotEmpty,
         'El nombre del usuario no puede estar vacío',
       ),
       assert(
         userEmail.isNotEmpty,
         'El correo del usuario no puede estar vacío',
       );

  /// Convierte la cotización a un mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'predefinedTrailer': predefinedTrailer?.toMap(),
      'trailerBase': trailerBase?.toMap(),
      'components': components.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'date': Timestamp.fromDate(date),
    };
  }

  /// Crea una instancia de `Quotation` desde un mapa de Firestore.
  static Quotation fromMap(Map<String, dynamic> map) {
    return Quotation(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
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
    );
  }

  /// Calcula el precio total basado en la base y los componentes.
  double calculateTotalPrice() {
    double basePrice = trailerBase?.price ?? 0;
    double componentsPrice = components.fold(
      0,
      (sum, component) => sum + component.price,
    );
    return basePrice + componentsPrice;
  }

  /// Devuelve la fecha formateada como `dd/MM/yyyy`.
  String formattedDate() {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  String toString() {
    return 'Quotation(id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, totalPrice: $totalPrice, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Quotation &&
        other.id == id &&
        other.userId == userId &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ totalPrice.hashCode;
}
