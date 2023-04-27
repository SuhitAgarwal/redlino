import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../app/app.locator.dart';
import '../models/failure.dart';
import '../models/user.dart';
import 'user_data_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _dataService = sl<UserDataService>();
  final _fbAuthService = sl<FirebaseAuthenticationService>();

  User? get firebaseUser => _auth.currentUser;

  Future<Map<String, dynamic>?> get claims async {
    if (firebaseUser == null) return null;
    final result = await firebaseUser!.getIdTokenResult();
    return result.claims;
  }

  Future<bool> get isCelebrity async {
    final userClaims = await claims ?? {};
    return userClaims['isCelebrity'] ?? false;
  }

  Future<bool> get isAppleSignInAvailable =>
      _fbAuthService.isAppleSignInAvailable();

  Future<void> loginUserEP({
    required String email,
    required String password,
  }) async {
    final r = await _fbAuthService.loginWithEmail(
      email: email,
      password: password,
    );

    if (r.hasError) {
      throw Failure(r.errorMessage!);
    }

    if (r.user == null) return;

    await uploadUserData(user: r.user!);
  }

  Future<void> registerUserEP({
    required String name,
    required String email,
    required String password,
  }) async {
    final r = await _fbAuthService.createAccountWithEmail(
      email: email,
      password: password,
    );

    if (r.hasError) {
      throw Failure(r.errorMessage!);
    }

    final user = r.user;

    if (user == null) return;

    final trimmedName = name.trim();

    await user.updateDisplayName(trimmedName);
    await user.sendEmailVerification();
    await uploadUserData(
      user: user,
      name: trimmedName,
      skipExistingCheck: true,
    );
  }

  Future<void> loginUserApple() async {
    // Sign in to Firebase with OAuth credential
    final r = await _fbAuthService.signInWithApple(
      appleRedirectUri: '',
      appleClientId: '',
    );

    if (r.hasError) {
      throw Failure(r.errorMessage!);
    }

    // Get user from credential
    final user = r.user;

    // Return if [user] is undefined
    if (user == null) return;

    // Upload user data if they don't already exist in DB
    await uploadUserData(user: user);
  }

  Future<void> loginUserGoogle() async {
    final r = await _fbAuthService.signInWithGoogle();

    if (r.hasError) {
      throw Failure(r.errorMessage!);
    }

    final user = r.user;
    if (user == null) return;

    String? photoURL;
    if (user.photoURL != null) {
      photoURL = user.photoURL!.replaceAll("=s96-c", "=s600");
      await user.updatePhotoURL(photoURL);
    }

    await uploadUserData(user: user, photoURL: photoURL);
  }

  Future<void> uploadUserData({
    required User user,
    String? name,
    String? photoURL,
    bool skipExistingCheck = false,
  }) async {
    // Get device token
    final token = await _dataService.getMessagingToken();

    if (!skipExistingCheck) {
      final userInDb = await _dataService.getUserFromFirestore(user.uid);
      if (userInDb != null) {
        final newUser = userInDb.copyWith(token: token);

        // Update user data in Firestore
        await _dataService.updateUserData(newUser);
        return;
      }
    }

    final appUser = AppUser(
      email: user.email!,
      uid: user.uid,
      token: token!,
      name: name ?? user.displayName!,
      photoURL: photoURL,
    );
    // Update user data in Firestore
    await _dataService.updateUserData(appUser);
  }

  Future<void> signOut() => _fbAuthService.logout();
}
