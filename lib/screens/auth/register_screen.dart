import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = 'Étudiant'; // Default ròl nan makèt la

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Créer un Compte',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Rejoigner EduConnect Pro',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            // Prenom ak Nom sou menm liy
            Row(
              children: [
                Expanded(child: _buildTextField('Prénom')),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField('Nom')),
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField('Email'),
            const SizedBox(height: 15),
            _buildTextField('Téléphone'),
            const SizedBox(height: 15),
            _buildTextField('Mot de passe', obscure: true),
            const SizedBox(height: 15),
            _buildTextField('Confirmer le mot de passe', obscure: true),
            const SizedBox(height: 20),

            // Seksyon Chwa Ròl la (Je suis:)
            const Text('Je suis:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _roleCard('Étudiant', Icons.school)),
                const SizedBox(width: 15),
                Expanded(child: _roleCard('Enseignant', Icons.person)),
              ],
            ),
            const SizedBox(height: 30),

            // Bouton S'inscrire
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("S'inscrire", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),

            // Lyen pou tounen nan Connexion
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Déjà un compte ? "),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("Se connecter", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _roleCard(String role, IconData icon) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 30),
            const SizedBox(height: 8),
            Text(role, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.black87)),
          ],
        ),
      ),
    );
  }
}