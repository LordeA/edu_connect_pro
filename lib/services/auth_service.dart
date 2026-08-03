// ============================================================
// EduConnect Pro — Service d'authentification
// Membre A — lib/services/auth_service.dart
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream qui écoute les changements de session (connecté/déconnecté)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  // ----------------------------------------------------------
  // INSCRIPTION
  // ----------------------------------------------------------
  Future<User?> register({
    required String email,
    required String password,
    required String nom,
    required String role, // 'teacher' ou 'student'
    required String institution,
  }) async {
    try {
      // 1. Créer le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      // 2. Créer le document Firestore correspondant (collection users)
      await _firestore.collection('users').doc(user.uid).set({
        'role': role,
        'nom': nom,
        'avatarURL': '',
        'institution': institution,
        'createdAt': Timestamp.now(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ----------------------------------------------------------
  // CONNEXION
  // ----------------------------------------------------------
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await _createUserIfMissing(user);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('La connexion Google a échoué : $e');
    }
  }

  Future<User?> loginWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (result.status != LoginStatus.success || result.accessToken == null) {
        return null;
      }
      final credential = FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await _createUserIfMissing(user);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('La connexion Facebook a échoué : $e');
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> _createUserIfMissing(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();
    if (!snapshot.exists) {
      await userDoc.set({
        'role': 'student',
        'nom': user.displayName ?? user.email?.split('@').first ?? 'Utilisateur',
        'avatarURL': user.photoURL ?? '',
        'institution': '',
        'createdAt': Timestamp.now(),
      });
    }
  }

  // ----------------------------------------------------------
  // DÉCONNEXION
  // ----------------------------------------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ----------------------------------------------------------
  // RÉCUPÉRER LE RÔLE ET LE NOM D'UN UTILISATEUR DEPUIS FIRESTORE
  // ----------------------------------------------------------
  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['role'] as String?;
  }

  Future<String?> getUserName(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['nom'] as String?;
  }

  // ----------------------------------------------------------
  // GESTION DES ERREURS FIREBASE EN FRANÇAIS
  // ----------------------------------------------------------
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé par un autre compte.';
      case 'invalid-email':
        return 'L\'adresse email n\'est pas valide.';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      case 'user-not-found':
        return 'Aucun compte ne correspond à cet email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      default:
        return 'Une erreur est survenue : ${e.message}';
    }
  }
}
