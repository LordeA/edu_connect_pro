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
  String? _nom;
  String? _avatarURL;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _initialized = false;
  String? _errorMessage;

  // Getters publics
  User? get user => _user;
  String? get nom => _nom;
  String? get avatarURL => _avatarURL;
  String? get role => _role;
  String? get email => _user?.email; // <-- Getter anplis pou evite erè 'missing email getter'
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isTeacher => _role == 'teacher';
  bool get isStudent => _role == 'student';
  bool get rememberMe => _rememberMe;
  bool get isInitialized => _initialized;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  AuthProvider() {
    // Écoute les changements de session en continu
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _role = await _authService.getUserRole(user.uid);
        _nom = await _authService.getUserName(user.uid);
        _avatarURL = await _authService.getUserAvatar(user.uid);
      } else {
        _role = null;
        _nom = null;
        _avatarURL = null;
      }
      _initialized = true;
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
      _nom = nom;
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
        _nom = await _authService.getUserName(user.uid);
        _avatarURL = await _authService.getUserAvatar(user.uid);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.loginWithGoogle();
      if (user == null) {
        _errorMessage = 'Connexion Google annulée.';
        _setLoading(false);
        return false;
      }
      _user = user;
      _role = await _authService.getUserRole(user.uid);
      _nom = await _authService.getUserName(user.uid);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithFacebook() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.loginWithFacebook();
      if (user == null) {
        _errorMessage = 'Connexion Facebook annulée.';
        _setLoading(false);
        return false;
      }
      _user = user;
      _role = await _authService.getUserRole(user.uid);
      _nom = await _authService.getUserName(user.uid);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({
    required String email,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateProfile({
    required String nom,
    String? email,
    String? institution,
    String? avatarURL,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.updateUserProfile(
        nom: nom,
        email: email,
        institution: institution,
        avatarURL: avatarURL,
      );
      _nom = nom;
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
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
    _nom = null;
    _avatarURL = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    if (_user != null) {
      _role = await _authService.getUserRole(_user!.uid);
      _nom = await _authService.getUserName(_user!.uid);
      _avatarURL = await _authService.getUserAvatar(_user!.uid);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}