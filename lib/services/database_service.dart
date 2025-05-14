// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_trailer_quotation/models/trailer_base_model.dart';
import '../models/trailer_model.dart';
import '../models/component_model.dart';
import '../models/quotation_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener trailers predefinidos
  Future<List<TrailerModel>> getPredefinedTrailers() async {
    try {
      var trailerDocs = await _firestore.collection('trailers').get();
      return trailerDocs.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return TrailerModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error al obtener trailers: $e');
      return [];
    }
  }

  // Obtener trailer por ID
  Future<TrailerModel?> getTrailerById(String id) async {
    try {
      var doc = await _firestore.collection('trailers').doc(id).get();
      if (doc.exists) {
        var data = doc.data()!;
        data['id'] = doc.id;
        return TrailerModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error al obtener trailer: $e');
      return null;
    }
  }

  // Obtener componentes
  Future<List<ComponentModel>> getComponents() async {
    try {
      var componentDocs = await _firestore.collection('components').get();
      return componentDocs.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return ComponentModel.fromJson(data); // Corrected class name
      }).toList();
    } catch (e) {
      print('Error al obtener componentes: $e');
      return [];
    }
  }

  // Guardar cotización
  Future<String?> saveQuotation(QuotationModel quotation) async {
    try {
      var quotationData = quotation.toJson();
      var docRef = await _firestore.collection('quotations').add(quotationData);
      return docRef.id;
    } catch (e) {
      print('Error al guardar cotización: $e');
      return null;
    }
  }

  // Obtener cotizaciones por usuario
  Future<List<Object>> getQuotationsByUser(String userId) async {
    try {
      var quotationDocs =
          await _firestore
              .collection('quotations')
              .where('userId', isEqualTo: userId)
              .get();

      return quotationDocs.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return QuotationModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error al obtener cotizaciones del usuario: $e');
      return [];
    }
  }

  // Actualizar URL del PDF
  Future<bool> updatePdfUrl(String quotationId, String pdfUrl) async {
    try {
      await _firestore.collection('quotations').doc(quotationId).update({
        'pdfUrl': pdfUrl,
      });
      return true;
    } catch (e) {
      print('Error al actualizar URL del PDF: $e');
      return false;
    }
  }

  // Inicializar datos (solo para desarrollo)
  Future<void> initializeData() async {
    if (bool.fromEnvironment('dart.vm.product')) {
      print('Inicialización de datos deshabilitada en producción');
      return;
    }

    // Trailers predefinidos
    await _initializeTrailers();

    // Componentes para trailers personalizados
    await _initializeComponents();
  }

  // Inicializar trailers predefinidos
  Future<void> _initializeTrailers() async {
    var trailersCollection = _firestore.collection('trailers');
    var trailerDocs = await trailersCollection.get();

    if (trailerDocs.docs.isEmpty) {
      var trailers = [
        {
          'name': 'Trailer de Exhibición',
          'type': 'exhibition',
          'price': 6400000.0,
          'features': [
            'Medidas 160 de ancho 2.00 de largo 2.00 de altura',
            'Tubería 4*8 c-18',
            'Tuberia 1\'pulgada',
            'Tubería 3/4',
            'Piso en fibra de madera 1.5mm',
            'Lamina galvanizada c-26',
            'Mesas en acero inoxidable',
            'Vitrina frontal parte baja',
            'Techo en pvc',
            'Iluminacion 110',
            'Iluminación 12 voltios',
            '2 toma corrientes',
          ],
          'description':
              'Ideal para exhibición de productos, con vitrina frontal y mesas en acero inoxidable.',
          'imageUrl': 'https://example.com/exhibition_trailer.jpg',
        },
        {
          'name': 'Trailer de Cocina',
          'type': 'kitchen',
          'price': 8700000.0,
          'features': [
            'Plancha de 60*40',
            'Freidora',
            'Vaporera',
            'Parrillas a carbón',
            'Parrilla a gas',
            'Topping 1/9 unidad',
            'Campana extractora',
            'Lavaplatos con cajón sistema por gravedad',
            'Bodega para gas',
          ],
          'description':
              'Equipado con todo lo necesario para una cocina móvil profesional.',
          'imageUrl': 'https://example.com/kitchen_trailer.jpg',
        },
        {
          'name': 'Trailer de Heladería',
          'type': 'icecream',
          'price': 7800000.0,
          'features': [
            '170 ancho x 2 de altura',
            '2 mesas de trabajo acero inoxidable',
            'Lavaplatos',
            'Sistema por gravedad',
            'Toping en acero inoxidable',
            'Cajón aéreo',
            'Espacio para refrigerador',
            'Iluminación',
            'Tres toma corriente',
            'Pintura interna y externa',
            '2 ventanas laterales',
            'Puerta de ingreso',
          ],
          'description':
              'Diseñado específicamente para negocios de helados y postres fríos.',
          'imageUrl': 'https://example.com/icecream_trailer.jpg',
        },
      ];

      for (var trailer in trailers) {
        await trailersCollection.add(trailer);
      }
    }
  }

  // Inicializar componentes
  Future<void> _initializeComponents() async {
    var componentsCollection = _firestore.collection('components');
    var componentDocs = await componentsCollection.get();

    if (componentDocs.docs.isEmpty) {
      var components = [
        {
          'name': 'Plancha de 60x40',
          'price': 370000.0,
          'category': 'Cocina',
          'description': 'Plancha profesional para cocinar',
        },
        {
          'name': 'Freidora',
          'price': 220000.0,
          'category': 'Cocina',
          'description': 'Freidora para alimentos',
        },
        {
          'name': 'Vaporera',
          'price': 250000.0,
          'category': 'Cocina',
          'description': 'Vaporera para cocción al vapor',
        },
        {
          'name': 'Parrilla a carbón',
          'price': 475000.0,
          'category': 'Cocina',
          'description': 'Parrilla profesional a carbón',
        },
      ];

      for (var component in components) {
        await componentsCollection.add(component);
      }
    }
  }

  // Obtener información del usuario actual
  Future<UserModel?> getCurrentUserInfo() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? 'Usuario desconocido',
          email: user.email ?? 'Correo no disponible',
          createdAt: user.metadata.creationTime ?? DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('Error al obtener información del usuario: $e');
      return null;
    }
  }
}

class QuotationModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final TrailerModel? predefinedTrailer;
  final TrailerBase? trailerBase;
  final List<ComponentModel> components;
  final double totalPrice;
  final DateTime date;

  QuotationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.predefinedTrailer,
    this.trailerBase,
    this.components = const [],
    required this.totalPrice,
    required this.date,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      predefinedTrailer:
          json['predefinedTrailer'] != null
              ? TrailerModel.fromJson(json['predefinedTrailer'])
              : null,
      trailerBase:
          json['trailerBase'] != null
              ? TrailerBase.fromJson(json['trailerBase'])
              : null,
      components:
          json['components'] != null
              ? List<ComponentModel>.from(
                json['components'].map((x) => ComponentModel.fromJson(x)),
              )
              : [],
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'predefinedTrailer': predefinedTrailer?.toJson(),
      'trailerBase': trailerBase?.toJson(),
      'components': components.map((x) => x.toJson()).toList(),
      'totalPrice': totalPrice,
      'date': Timestamp.fromDate(date),
    };
  }
}

class ComponentModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String description;

  ComponentModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'description': description,
    };
  }
}
