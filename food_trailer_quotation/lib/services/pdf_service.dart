// services/pdf_service.dart
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfService {
  Future<File> generateQuotation(
    String name,
    String email,
    String details,
    double price,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Cotización', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Cliente: $name'),
                pw.Text('Correo: $email'),
                pw.SizedBox(height: 20),
                pw.Text('Detalles del Trailer:'),
                pw.Text(details),
                pw.SizedBox(height: 20),
                pw.Text('Precio Total: \$${price.toStringAsFixed(0)}'),
              ],
            ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/cotizacion.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
