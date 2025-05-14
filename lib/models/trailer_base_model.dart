class TrailerBase {
  final String id;
  final String name;
  final String description;
  final double price;

  TrailerBase({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  /// Convierte la base del trailer a un mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description, 'price': price};
  }

  /// Crea una instancia de `TrailerBase` desde un mapa de Firestore.
  static TrailerBase fromMap(Map<String, dynamic> map) {
    return TrailerBase(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  /// Lista estática de bases de trailers disponibles
  static List<TrailerBase> availableBases = [
    TrailerBase(
      id: '1',
      name: 'Base Tipo 1',
      description: '''
160 de ancho x 2 metros de largo x 2 mts de altura.
- Iluminación
- PVC
- Tres Toma corriente
- Piso tapete alfajor
- Pintura interna y externa
- Brazos hidráulicos
''',
      price: 5800000, // 5 millones 800 mil
    ),
    TrailerBase(
      id: '2',
      name: 'Base Tipo 2',
      description: '''
2 mts de ancho x 3 metros de largo x 2 mts de altura.
- Iluminación
- PVC
- Tres Toma corriente
- Piso tapete alfajor
- Pintura interna y externa
- Brazos hidráulicos
- Ventanas de atención
''',
      price: 8700000, // 8 millones 700 mil
    ),
    TrailerBase(
      id: '3',
      name: 'Base Tipo 3',
      description: '''
2 mts de ancho x 2 metros de largo x 2 mts de altura.
- Iluminación
- PVC
- Tres Toma corriente
- Piso tapete alfajor
- Pintura interna y externa
- Brazos hidráulicos
- Ventanas de atención
''',
      price: 8000000, // 8 millones
    ),
  ];

  static fromJson(json) {}

  toJson() {}
}
