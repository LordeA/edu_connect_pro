import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'student';

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
          child: Form(
            key: _formKey,
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
                    'Rejoindre EduConnect Pro',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Prénom',
                        controller: _firstnameController,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Obligatoire' : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildTextField(
                        'Nom',
                        controller: _lastnameController,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Obligatoire' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@') ? 'Email invalide' : null,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Téléphone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Obligatoire' : null,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Mot de passe',
                  controller: _passwordController,
                  obscure: true,
                  validator: (value) => value == null || value.length < 6 ? 'Minimum 6 caractères' : null,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Confirmer le mot de passe',
                  controller: _confirmPasswordController,
                  obscure: true,
                  validator: (value) => value != _passwordController.text ? 'Les mots de passe ne correspondent pas' : null,
                ),
                const SizedBox(height: 20),

                const Text('Je suis:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _roleCard('student', 'Étudiant', Icons.school)),
                    const SizedBox(width: 15),
                    Expanded(child: _roleCard('teacher', 'Enseignant', Icons.person)),
                  ],
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                final success = await authProvider.register(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  nom: '${_firstnameController.text.trim()} ${_lastnameController.text.trim()}'.trim(),
                                  role: _selectedRole,
                                  institution: 'École',
                                );
                                if (!mounted) return;
                                if (success) {
                                  if (!context.mounted) return;
                                  final route = AuthService.dashboardRouteForRole(authProvider.role);
                                  Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
                                } else {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(authProvider.errorMessage ?? 'Inscription impossible.')),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('S\'inscrire', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Déjà un compte ? '),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Se connecter', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _roleCard(String value, String label, IconData icon) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.black87)),
          ],
        ),
      ),
    );
  }
}