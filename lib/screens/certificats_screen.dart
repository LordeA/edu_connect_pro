import 'package:flutter/material.dart';

// Klas sa a rete la a, li pa bezwen yon fichye apa
class Certificate {
  final String title;
  final String date;
  bool isDownloaded;

  Certificate({
    required this.title, 
    required this.date, 
    this.isDownloaded = false
  });
}

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  // Lis sètifika yo
  List<Certificate> certificates = [
    Certificate(title: 'Certification Flutter Avancé', date: '15/06/2026'),
    Certificate(title: 'Maîtrise Firebase Database', date: '02/07/2026'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Certificats'),
      ),
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
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.verified, color: Colors.amber),
                title: Text(cert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Obtenu le: ${cert.date}'),
                trailing: IconButton(
                  icon: Icon(
                    cert.isDownloaded ? Icons.check_circle : Icons.download,
                    color: cert.isDownloaded ? Colors.green : Colors.blue,
                  ),
                  onPressed: () {
                    if (!cert.isDownloaded) {
                      _downloadCertificate(index);
                    } else {
                      _openCertificate(cert.title);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _downloadCertificate(int index) {
    setState(() {
      certificates[index].isDownloaded = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${certificates[index].title} a été téléchargé !')),
    );
  }

  void _openCertificate(String title) {
    // Isit la ou pral ajoute lojik pou ouvri PDF la pita
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ouverture de : $title')),
    );
  }
}