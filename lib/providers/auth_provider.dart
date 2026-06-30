// ============================================================
// EduConnect Pro — AuthProvider (ChangeNotifier)
// Membre A — lib/providers/auth_provider.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _role; // 'teacher' | 'student'
  bool _isLoading = false;
  String? _errorMessage;

  // Getters publics
  User? get user => _user;
  String? get role => _role;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isTeacher => _role == 'teacher';
  bool get isStudent => _role == 'student';

  AuthProvider() {
    // Écoute les changements de session en continu
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _role = await _authService.getUserRole(user.uid);
      } else {
        _role = null;
      }
      notifyListeners();
    });
  }

  // ----------------------------------------------------------
  // INSCRIPTION
  // ----------------------------------------------------------
  Future<bool> register({
    required String email,
    required String password,
    required String nom,
    required String role,
    required String institution,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        nom: nom,
        role: role,
        institution: institution,
      );
      _user = user;
      _role = role;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ----------------------------------------------------------
  // CONNEXION
  // ----------------------------------------------------------
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.login(email: email, password: password);
      _user = user;
      if (user != null) {
        _role = await _authService.getUserRole(user.uid);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ----------------------------------------------------------
  // DÉCONNEXION
  // ----------------------------------------------------------
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _role = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
