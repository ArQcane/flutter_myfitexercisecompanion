import 'package:firebase_auth/firebase_auth.dart';


class AuthRepository {
  AuthRepository._internal();
  static final AuthRepository _authRepository = AuthRepository._internal();
  factory AuthRepository() => _authRepository;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  logOut() {
    _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> register(email, password) {
    return  _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login(email, password) {
    return  _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> forgotPassword(email) {
    return  _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Stream<User?> getAuthUser() {
    return  _firebaseAuth.authStateChanges();
  }


}
