import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CatalogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> catalogItems = [
    {
      'title': 'Catálogo Completo 2023',
      'description': 'Todos nuestros modelos y componentes disponibles',
      'url': 'https://ejemplo.com/catalogo.pdf',
    },
    {
      'title': 'Folleto Promocional',
      'description': 'Ofertas especiales y paquetes',
      'url': 'https://ejemplo.com/folleto.pdf',
    },
    {
      'title': 'Guía de Mantenimiento',
      'description': 'Cuidado y mantenimiento de tu trailer',
      'url': 'https://ejemplo.com/mantenimiento.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo Digital')),
      body: ListView.builder(
        itemCount: catalogItems.length,
        itemBuilder: (context, index) {
          final item = catalogItems[index];
          return Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(
                Icons.picture_as_pdf,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(item['title'], style: TextStyle(color: Colors.white)),
              subtitle: Text(
                item['description'],
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Icon(
                Icons.download,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => _launchUrl(item['url']),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
