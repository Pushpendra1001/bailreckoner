import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/bail_application.dart';
import '../core/utils.dart';

class PDFService {
  Future<File> generateBailApplicationPDF(BailApplication application) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'BAIL APPLICATION',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'IN THE COURT OF ${application.courtName.toUpperCase()}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 30),
          _buildSection('Case Number', application.caseNumber),
          _buildSection('Applicant Name', application.applicantName),
          _buildSection('Date', Utils.formatDate(application.generatedDate)),
          pw.SizedBox(height: 20),
          _buildDetailedSection('CASE SUMMARY', application.summary),
          _buildDetailedSection('LEGAL REASONING', application.legalReasoning),
          _buildDetailedSection('ARGUMENTS FOR BAIL', application.arguments),
          _buildDetailedSection(
            'MITIGATION FACTORS',
            application.mitigationFactors,
          ),
          pw.SizedBox(height: 40),
          pw.Text(
            'Respectfully submitted,',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Counsel for the Applicant',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    // Use application documents directory for better compatibility
    Directory? output;
    try {
      if (Platform.isAndroid) {
        output = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        output = await getApplicationDocumentsDirectory();
      } else {
        output = await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      output = await getApplicationDocumentsDirectory();
    }

    final fileName =
        'bail_application_${application.caseNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output!.path}/$fileName');

    // Ensure directory exists
    await file.parent.create(recursive: true);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildSection(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  pw.Widget _buildDetailedSection(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 15),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            decoration: pw.TextDecoration.underline,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          content,
          style: const pw.TextStyle(fontSize: 11),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    );
  }

  Future<void> printPDF(File file) async {
    final bytes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  Future<void> sharePDF(File file) async {
    try {
      final bytes = await file.readAsBytes();
      await Printing.sharePdf(
        bytes: bytes,
        filename: file.uri.pathSegments.last,
      );
    } catch (e) {
      // Fallback: Try to open the PDF for viewing
      try {
        final bytes = await file.readAsBytes();
        await Printing.layoutPdf(onLayout: (_) async => bytes);
      } catch (e2) {
        throw Exception('Unable to share/view PDF: ${e2.toString()}');
      }
    }
  }

  Future<String> savePDF(File file) async {
    return file.path;
  }

  // Alternative method that doesn't require file path - generates and shares directly
  Future<void> generateAndSharePDF(BailApplication application) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'BAIL APPLICATION',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'IN THE COURT OF ${application.courtName.toUpperCase()}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 30),
          _buildSection('Case Number', application.caseNumber),
          _buildSection('Applicant Name', application.applicantName),
          _buildSection('Date', Utils.formatDate(application.generatedDate)),
          pw.SizedBox(height: 20),
          _buildDetailedSection('CASE SUMMARY', application.summary),
          _buildDetailedSection('LEGAL REASONING', application.legalReasoning),
          _buildDetailedSection('ARGUMENTS FOR BAIL', application.arguments),
          _buildDetailedSection(
            'MITIGATION FACTORS',
            application.mitigationFactors,
          ),
          pw.SizedBox(height: 40),
          pw.Text(
            'Respectfully submitted,',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Counsel for the Applicant',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();

    // Share or view directly without saving to file
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'bail_application_${application.caseNumber}.pdf',
    );
  }
}
