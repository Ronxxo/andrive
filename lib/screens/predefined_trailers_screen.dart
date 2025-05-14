import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'login_screen.dart';
import '../services/pdf_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:food_trailer_quotation/services/quotation_service.dart';

class PredefinedTrailersScreen extends StatelessWidget {
  final PdfService pdfService = PdfService();

  final List<Map<String, dynamic>> trailers = [
    {
      'name': 'Trailer de Exhibición',
      'description': '''
Medidas 160 de ancho x 2.00 de largo x 2.00 de altura
- Tubería 4*8 c-18
- Tubería 1 pulgada
- Tubería 3/4
- Tubería estructural
- Tubería 5*5 c-14
- Piso en fibra de madera 1.5mm
- Lámina galvanizada c-26 y c-28
- Sobre piso en tapete de alfanjor
- Mesas en acero inoxidable
- Vitrina frontal parte baja
- Vidrio para vitrina
- Pintura interior y exterior personalizada
- Techo en PVC
- Iluminación 110 y 12 voltios
- Brazos hidráulicos para ventanas
- 2 tomas corrientes
- 1 enganche 7/8
- 1 eje remanufacturado
- 2 llantas y rines remanufacturados
- 1 chapa de seguridad
- Caja para chapa
- Pasadores de seguridad
- Esquineros en lámina de alfanjor y galvanizada
''',
      'price': 6400000,
      'image': 'assets/images/trailer_1.jpg',
      'features': [
        '2 metros de altura',
        'Iluminación 110V y 12V',
        'Brazos hidráulicos',
        'Pintura personalizada',
      ],
    },
    {
      'name': 'Trailer de Cocina',
      'description': '''
- Plancha de 60*40: \$370,000
- Freidora: \$220,000
- Vaporera: \$250,000
- Parrillas a carbón: \$475,000
- Parrilla de piedra volcánica: \$400,000
- Parrilla a gas: \$325,000
- Topping 1/9: \$30,000 unidad
- Topping 1/6: \$40,000
- Topping 1/3: \$50,000 unidad
- Lámina en alfajor de aluminio para piso: \$500,000
- Diseño, impresión e instalación: \$780,000
- Campana extractora de 1m x 40cm: \$1,400,000
- Plancha en acero inoxidable: \$525,000
- Cajones interiores: \$680,000
- Entrepaños en acero inoxidable: \$180,000 c/u
- Lavaplatos con cajón (sistema por gravedad): \$650,000
- Bodega para gas: \$350,000
''',
      'price': 8700000,
      'image': 'assets/images/trailer_2.jpg',
      'features': [
        'Equipo profesional completo',
        'Plancha de 60x40',
        'Freidora incluida',
        'Ventilación profesional',
        '8.7 millones',
      ],
    },
    {
      'name': 'Trailer de Heladería',
      'description': '''
Medidas 170 de ancho x 2 de altura
- 2 mesas de trabajo en acero inoxidable
- Lavaplatos con sistema por gravedad
- Topping en acero inoxidable
- Cajón aéreo
- Espacio para refrigerador
- Iluminación LED profesional
- 3 tomas corrientes
- Pintura interna y externa
- 2 ventanas laterales
- Puerta de ingreso
- Diseño, impresión e instalación gráfica
- Piso en tapete de alfanjor
''',
      'price': 7800000,
      'image': 'assets/images/trailer_3.jpg',
      'features': [
        'Acero inoxidable',
        'Espacio refrigerado',
        'Diseño personalizado',
        'Iluminación LED',
        '7.8 millones',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trailers Predefinidos')),
      body: ListView.builder(
        itemCount: trailers.length,
        itemBuilder: (context, index) {
          final trailer = trailers[index];
          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del trailer
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      trailer['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre y precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trailer['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${trailer['price'].toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Características principales
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        (trailer['features'] as List<String>)
                            .map(
                              (feature) => Chip(
                                label: Text(feature),
                                backgroundColor: Colors.grey[200],
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Descripción (con botón "Ver más")
                  ExpansionTile(
                    title: const Text(
                      'Ver detalles completos',
                      style: TextStyle(fontSize: 14),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          trailer['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botón de cotización
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LoginScreen(
                                  onLoginSuccess: (name, email, phone) {
                                    _handleQuotation(
                                      context,
                                      trailer,
                                      name,
                                      email,
                                      phone,
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('SOLICITAR COTIZACIÓN'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleQuotation(
    BuildContext context,
    Map<String, dynamic> trailer,
    String name,
    String email,
    String phone,
  ) async {
    try {
      final quotationService = QuotationService();

      // Guarda la cotización en Firestore
      await quotationService.saveQuotation(
        name: name,
        email: email,
        phone: phone,
        details: '${trailer['name']}\n\n${trailer['description']}',
        price: trailer['price'].toDouble(),
        trailerName: '${trailer['name']}',
        trailerDetails: trailer['description'],
      );

      // Genera el PDF
      await pdfService.generateQuotation(
        name,
        email,
        phone,
        '${trailer['name']}\n\n${trailer['description']}',
        trailer['price'].toDouble(),
        imagePath: trailer['image'],
        onFile: (file) async {
          // Solo en móvil/desktop, compartir PDF
          await Share.shareFiles([
            file.path,
          ], text: 'Cotización de ${trailer['name']}');
        },
      );

      if (!context.mounted) return;

      // Muestra el diálogo de éxito
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Cotización generada'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¿Qué deseas hacer con la cotización?'),
                  const SizedBox(height: 20),
                  Text(
                    'Total: \$${trailer['price'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (kIsWeb)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'El PDF se descargó automáticamente.',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar cotización: $e')),
        );
      }
    }
  }
}
