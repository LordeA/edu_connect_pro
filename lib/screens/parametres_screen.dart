import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/main.dart'; 

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  bool notificationsEnabled = true; // Eta notifikasyon

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        children: [
          // Mode Sombre
          SwitchListTile(
            title: const Text("Mode Sombre"),
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(val),
          ),
          
          // Langue ak chwa miltip
          ListTile(
            title: const Text("Langue"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(context),
          ),
          
          // Notifications
          SwitchListTile(
            title: const Text("Notifications"),
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
          
          // Navigasyon pou lòt paj yo
          ListTile(
            title: const Text("Confidentialité"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailScreen("Confidentialité"))),
          ),
          ListTile(
            title: const Text("Sécurité"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailScreen("Sécurité"))),
          ),
          ListTile(
            title: const Text("A Propos"),
            trailing: const Text("1.0.0"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailScreen("A Propos"))),
          ),
        ],
      ),
    );
  }

  // Fonksyon pou montre opsyon lang yo
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Chwazi yon lang"),
        children: [
          SimpleDialogOption(child: const Text("Français"), onPressed: () => Navigator.pop(context)),
          SimpleDialogOption(child: const Text("Kreyòl"), onPressed: () => Navigator.pop(context)),
          SimpleDialogOption(child: const Text("English"), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// Yon ti paj jenerik pou montre detay yo (Confidentialité, Sécurité, etc.)
class DetailScreen extends StatelessWidget {
  final String title;
  const DetailScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Isit la se detay pou $title")),
    );
  }
}