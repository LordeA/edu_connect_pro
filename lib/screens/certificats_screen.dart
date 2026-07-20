import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart'; // Asire w ou ajoute pakè a nan pubspec.yaml

class Certificate {
  final String title;
  final String date;
  bool isDownloaded;
  String? filePath; // Nou ajoute sa pou nou konnen kote fichye a ye

  Certificate({
    required this.title, 
    required this.date, 
    this.isDownloaded = false,
    this.filePath
  });
}

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  List<Certificate> certificates = [
    Certificate(title: 'Certification Flutter Avancé', date: '15/06/2026'),
    Certificate(title: 'Maîtrise Firebase Database', date: '02/07/2026'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Certificats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: certificates.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cert = certificates[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
              ),
              child: ListTile(
                leading: const Icon(Icons.verified, color: Colors.amber),
                title: Text(cert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Obtenu le: ${cert.date}'),
                onTap: () => cert.isDownloaded ? _openCertificate(cert) : _downloadCertificate(index),
                trailing: IconButton(
                  icon: Icon(
                    cert.isDownloaded ? Icons.picture_as_pdf : Icons.download,
                    color: cert.isDownloaded ? Colors.red : Colors.blue,
                  ),
                  onPressed: () => cert.isDownloaded ? _openCertificate(cert) : _downloadCertificate(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Fonksyon pou simile telechajman
  void _downloadCertificate(int index) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Téléchargement de ${certificates[index].title}...')));
    
    await Future.delayed(const Duration(seconds: 2)); // Tan pou simile download

    setState(() {
      certificates[index].isDownloaded = true;
      // Isit la, apre download, ou ta dwe bay chemen fichye a (filePath)
      certificates[index].filePath = "/path/to/your/file.pdf"; 
    });
  }

  // Fonksyon pou ouvri fichye a ak OpenFilex
  Future<void> _openCertificate(Certificate cert) async {
    if (cert.filePath != null) {
      final result = await OpenFilex.open(cert.filePath!);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur: Impossible douvri le fichier')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fichier introuvable')));
    }
  }
}