import 'package:flutter/material.dart';

class ModifierProfilScreen extends StatefulWidget {
  const ModifierProfilScreen({super.key});

  @override
  State<ModifierProfilScreen> createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends State<ModifierProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController(text: 'Elève Junior');
  final _emailController = TextEditingController(text: 'junior@educonnect.com');
  final _telController = TextEditingController(text: '+509 3333-3333');

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF0D47A1),
                    child: const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Validasyon Non
              TextFormField(
                controller: _nomController,
                decoration: _buildInputDecoration('Nom Complet', isDark),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Silvouplè, antre non ou';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Validasyon Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration('Email', isDark),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Silvouplè, antre yon imel';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Fòma imel sa a pa kòrèk (manke @ oswa .com)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Validasyon Telefòn
              TextFormField(
                controller: _telController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration('Téléphone', isDark),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Silvouplè, antre nimewo telefòn ou';
                  }
                  if (value.trim().length < 8) {
                    return 'Nimewo telefòn lan dwe gen omwen 8 chif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil mis à jour avec succès !')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}