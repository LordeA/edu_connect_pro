import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/main.dart'; // Asire w chemen sa a bon

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode Sombre'),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(value),
          ),
          ListTile(
            title: const Text('Langue'),
            trailing: const Icon(Icons.language),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(title: const Text("Français"), onTap: () => Navigator.pop(context)),
                    ListTile(title: const Text("Kreyòl"), onTap: () => Navigator.pop(context)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}