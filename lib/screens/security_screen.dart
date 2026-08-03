import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isTwoFactorEnabled = false;

  // Fonksyon pou afiche bwat dyalòg chanje modpas
  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe actuel'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mot de passe mis à jour avec succès !')),
              );
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }

  // Fonksyon pou gade aparèy ki konekte yo
  void _showConnectedDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appareils connectés'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              ListTile(
                leading: Icon(Icons.phone_android, color: Colors.green),
                title: Text('Smartphone Actuel'),
                subtitle: Text('Port-au-Prince, Haïti'),
                trailing: Text('Actif', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sécurité', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Paramètres de Sécurité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 1. Changer le mot de passe (Klike pou louvri bwat la)
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Color(0xFF0D47A1)),
            title: const Text('Changer le mot de passe', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mettre à jour votre mot de passe actuel'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(),

          // 2. Authentification à deux facteurs (Switch la ka aktive / dezaktive)
          SwitchListTile(
            secondary: const Icon(Icons.security, color: Color(0xFF0D47A1)),
            title: const Text('Authentification à deux facteurs', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ajouter une couche de sécurité supplémentaire'),
            value: isTwoFactorEnabled,
            activeColor: const Color(0xFF0D47A1),
            onChanged: (val) {
              setState(() {
                isTwoFactorEnabled = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(val ? 'Authentification à deux facteurs activée !' : 'Authentification à deux facteurs désactivée.')),
              );
            },
          ),
          const Divider(),

          // 3. Appareils connectés (Klike pou wè lis aparèy yo)
          ListTile(
            leading: const Icon(Icons.devices, color: Color(0xFF0D47A1)),
            title: const Text('Appareils connectés', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Gérer les sessions actives sur vos appareils'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: _showConnectedDevicesDialog,
          ),
        ],
      ),
    );
  }
}