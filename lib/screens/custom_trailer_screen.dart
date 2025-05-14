import 'package:flutter/material.dart';
import 'package:food_trailer_quotation/services/pdf_service.dart';
import 'package:food_trailer_quotation/screens/login_screen.dart';
import 'package:food_trailer_quotation/models/component_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:food_trailer_quotation/services/quotation_service.dart';

class CustomTrailerScreen extends StatefulWidget {
  const CustomTrailerScreen({super.key});

  @override
  State<CustomTrailerScreen> createState() => _CustomTrailerScreenState();
}

class _CustomTrailerScreenState extends State<CustomTrailerScreen> {
  String? _selectedBase;
  final List<String> _selectedComponents = [];
  double _totalPrice = 0;
  int _currentStep = 0;

  final List<Map<String, dynamic>> _trailerBases = [
    {
      'id': '1',
      'name': 'Base Tipo 1',
      'price': 5800000,
      'description': '160 de ancho x 2 metros de largo x 2 mts de altura',
      'features': [
        'Iluminación',
        'PVC',
        'Tres Toma corriente',
        'Piso tapete alfajor',
        'Pintura interna y externa',
        'Brazos hidráulicos',
      ],
    },
    {
      'id': '2',
      'name': 'Base Tipo 2',
      'price': 8700000,
      'description': '2 mts de ancho x 3 metros de largo x 2 mts de altura',
      'features': [
        'Iluminación',
        'PVC',
        'Tres Toma corriente',
        'Piso tapete alfajor',
        'Pintura interna y externa',
        'Brazos hidráulicos',
        'Ventanas de atención',
      ],
    },
    {
      'id': '3',
      'name': 'Base Tipo 3',
      'price': 8000000,
      'description': '2 mts de ancho x 4 metros de largo x 2 mts de altura',
      'features': [
        'Iluminación',
        'PVC',
        'Tres Toma corriente',
        'Piso tapete alfajor',
        'Pintura interna y externa',
        'Brazos hidráulicos',
        'Ventanas de atención',
      ],
    },
  ];

  void _calculateTotalPrice() {
    double basePrice =
        _trailerBases
            .firstWhere(
              (base) => base['id'] == _selectedBase,
              orElse: () => {'price': 0},
            )['price']
            .toDouble();

    double componentsPrice = _selectedComponents.fold(0, (sum, componentId) {
      final component = Component.availableComponents.firstWhere(
        (c) => c.id == componentId,
        orElse: () => Component(id: '', name: '', price: 0),
      );
      return sum + component.price;
    });

    setState(() {
      _totalPrice = basePrice + componentsPrice;
    });
  }

  void _generateQuotation() {
    if (_selectedBase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una base')),
      );
      return;
    }

    final selectedBase = _trailerBases.firstWhere(
      (base) => base['id'] == _selectedBase,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LoginScreen(
              onLoginSuccess: (name, email, phone) async {
                final pdfService = PdfService();
                final quotationService = QuotationService();

                String description = '${selectedBase['name']}\n';
                description += '${selectedBase['description']}\n\n';
                description += 'Características:\n';
                description += selectedBase['features'].join('\n');
                description += '\n\nComponentes seleccionados:\n';
                description += _selectedComponents
                    .map((id) {
                      final component = Component.availableComponents
                          .firstWhere((c) => c.id == id);
                      return '- ${component.name}: \$${component.price.toStringAsFixed(0)}';
                    })
                    .join('\n');

                try {
                  // Guarda la cotización en Firestore
                  await quotationService.saveQuotation(
                    name: name,
                    email: email,
                    phone: phone,
                    details: description,
                    price: _totalPrice,
                    trailerName: '${selectedBase['name']}',
                    trailerDetails: description,
                  );

                  // Genera el PDF
                  await pdfService.generateQuotation(
                    name,
                    email,
                    phone,
                    description,
                    _totalPrice,
                    // imagePath: 'ruta/a/imagen.jpg', // Si quieres agregar una imagen
                    onFile: (file) async {
                      await Share.shareFiles([
                        file.path,
                      ], text: 'Cotización para ${selectedBase['name']}');
                    },
                  );
                  if (!context.mounted) return;

                  await showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Cotización generada'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '¿Qué deseas hacer con la cotización?',
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Total: \$${_totalPrice.toStringAsFixed(0)}',
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
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
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
                      SnackBar(content: Text('Error al generar PDF: $e')),
                    );
                  }
                }
              },
            ),
      ),
    );
  }

  Widget _buildBaseSelection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Selecciona la base del trailer:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._trailerBases.map(
            (base) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RadioListTile<String>(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      base['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(base['description']),
                    const SizedBox(height: 4),
                    Text(
                      '\$${base['price'].toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                value: base['id'],
                groupValue: _selectedBase,
                onChanged: (value) {
                  setState(() {
                    _selectedBase = value;
                    _calculateTotalPrice();
                    _currentStep = 1;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentSelection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      children: [
        const Text(
          'Componentes adicionales:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 2 : 3,
              childAspectRatio: 1.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: Component.availableComponents.length,
            itemBuilder: (context, index) {
              final component = Component.availableComponents[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_selectedComponents.contains(component.id)) {
                        _selectedComponents.remove(component.id);
                      } else {
                        _selectedComponents.add(component.id);
                      }
                      _calculateTotalPrice();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _selectedComponents.contains(component.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedComponents.add(component.id);
                              } else {
                                _selectedComponents.remove(component.id);
                              }
                              _calculateTotalPrice();
                            });
                          },
                        ),
                        Text(
                          component.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${component.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                });
              },
              child: const Text('Atrás'),
            ),
            ElevatedButton(
              onPressed: _generateQuotation,
              child: const Text('Generar Cotización'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trailer Personalizado'),
        centerTitle: true,
        actions:
            _currentStep == 1
                ? [
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      final selectedBase = _trailerBases.firstWhere(
                        (base) => base['id'] == _selectedBase,
                      );
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text(selectedBase['name']),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(selectedBase['description']),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Características:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...selectedBase['features']
                                        .map<Widget>(
                                          (feature) => Text('- $feature'),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ]
                : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _currentStep == 0
                ? _buildBaseSelection()
                : _buildComponentSelection(),
      ),
      bottomNavigationBar:
          _currentStep == 1
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
