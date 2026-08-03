import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // Chemen egzak la pou l jwenn login_screen.dart

// Fonksyon global pou mande konfimasyon epi dekonekte
void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Dekoneksyon',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Èske w sèten ou vle dekonekte w nan aplikasyon an?'),
        actions: [
          // Bouton Anile
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anile', style: TextStyle(color: Colors.grey)),
          ),
          // Bouton Konfime Dekoneksyon an
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Wi, dekonekte', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}