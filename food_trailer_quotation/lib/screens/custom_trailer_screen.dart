import 'package:flutter/material.dart';

class CustomTrailerScreen extends StatefulWidget {
  @override
  _CustomTrailerScreenState createState() => _CustomTrailerScreenState();
}

class _CustomTrailerScreenState extends State<CustomTrailerScreen> {
  String? selectedBase;
  List<String> selectedComponents = [];
  double totalPrice = 0;

  final List<Map<String, dynamic>> trailerBases = [
    {'name': 'Base Tipo 1', 'price': 5800000},
    {'name': 'Base Tipo 2', 'price': 8700000},
    {'name': 'Base Tipo 3', 'price': 8000000},
  ];

  final List<Map<String, dynamic>> components = [
    {'name': 'Plancha de 60x40', 'price': 370000},
    {'name': 'Freidora', 'price': 220000},
    {'name': 'Vaporera', 'price': 250000},
    {'name': 'Parrillas a carbón', 'price': 475000},
    {'name': 'Parrilla piedra volcánica', 'price': 400000},
    {'name': 'Parrilla a gas', 'price': 325000},
    {'name': 'Plancha acero inoxidable', 'price': 525000},
    {'name': 'Cajones interiores', 'price': 680000},
    {'name': 'Lavaplatos con cajón', 'price': 650000},
  ];

  void _calculateTotalPrice() {
    double basePrice =
        trailerBases.firstWhere(
          (base) => base['name'] == selectedBase,
        )['price'];
    double componentsPrice = selectedComponents.fold(
      0,
      (sum, component) =>
          sum +
          components.firstWhere((comp) => comp['name'] == component)['price'],
    );
    setState(() {
      totalPrice = basePrice + componentsPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Trailer Personalizado'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: Text('Selecciona una base'),
            value: selectedBase,
            items:
                trailerBases.map((base) {
                  return DropdownMenuItem<String>(
                    value: base['name'],
                    child: Text('${base['name']} (\$${base['price']})'),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedBase = value;
                _calculateTotalPrice();
              });
            },
          ),
          Expanded(
            child: ListView(
              children:
                  components.map((component) {
                    return CheckboxListTile(
                      title: Text(
                        '${component['name']} (\$${component['price']})',
                      ),
                      value: selectedComponents.contains(component['name']),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedComponents.add(component['name']);
                          } else {
                            selectedComponents.remove(component['name']);
                          }
                          _calculateTotalPrice();
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
          Text(
            'Precio Total: \$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
