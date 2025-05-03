class Component {
  final String id;
  final String name;
  final double price;

  Component({required this.id, required this.name, required this.price});

  /// Convierte el componente a un mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }

  /// Crea una instancia de `Component` desde un mapa de Firestore.
  static Component fromMap(Map<String, dynamic> map) {
    return Component(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  /// Lista estática de componentes disponibles
  static List<Component> availableComponents = [
    Component(id: '1', name: 'Plancha de 60x40', price: 370000),
    Component(id: '2', name: 'Freidora', price: 220000),
    Component(id: '3', name: 'Vaporera', price: 250000),
    Component(id: '4', name: 'Parrillas a carbón', price: 475000),
    Component(id: '5', name: 'Parrilla piedra volcánica', price: 400000),
    Component(id: '6', name: 'Parrilla a gas', price: 325000),
    Component(id: '7', name: 'Plancha acero inoxidable', price: 525000),
    Component(id: '8', name: 'Cajones interiores', price: 680000),
    Component(
      id: '9',
      name: 'Lavaplatos con cajón (sistema por gravedad)',
      price: 650000,
    ),
    Component(id: '10', name: 'Hornos para pizza', price: 750000),
    Component(id: '11', name: 'Vitrinas independientes', price: 300000),
    Component(id: '12', name: 'Exprimidores de naranja', price: 125000),
    Component(id: '13', name: 'Televisor de 32 pulgadas', price: 830000),
    Component(id: '14', name: 'Sonido', price: 2300000),
    Component(id: '15', name: 'Congeladores', price: 1800000),
    Component(id: '16', name: 'Mesones en acero inoxidable', price: 150000),
  ];
}
