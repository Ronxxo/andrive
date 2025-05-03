class TrailerModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> features; // Campo para las características del trailer

  TrailerModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.features, // Inicialización del campo
  });

  // Método para convertir desde JSON
  factory TrailerModel.fromJson(Map<String, dynamic> json) {
    return TrailerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      features: List<String>.from(
        json['features'] ?? [],
      ), // Parseo de características
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'features': features, // Incluye las características en el mapa
    };
  }

  toJson() {}
}
