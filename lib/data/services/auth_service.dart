import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Added for Google Sign-In

  // Your existing stream and getter
  Stream<User?> get user => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// --- Your Original Email/Password Methods (Unchanged) --- ///

  Future<String> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // This is your excellent Firestore logic
      if (userCredential.user != null) {
        await _db.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'uid': userCredential.user!.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'defaultBaseCurrency': 'USD', // Your app-specific field
        });
      }
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unknown error occurred.";
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unknown error occurred.";
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  /// --- New & Updated Methods for Google Sign-In --- ///

  Future<String> signInWithGoogle() async {
    try {
      // 1. Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return "Sign-in cancelled.";
      }

      // 2. Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // 3. Create a Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return "Failed to sign in with Firebase.";
      }

      // 5. *** IMPORTANT ***
      // Check if the user is new and create a Firestore doc
      // We check if the document *already exists*
      final DocumentSnapshot userDoc =
      await _db.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // User document doesn't exist, so create it
        await _db.collection('users').doc(user.uid).set({
          'fullName': user.displayName ?? googleUser.displayName ?? '',
          'email': user.email ?? googleUser.email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'defaultBaseCurrency': 'USD', // Your app-specific field
        });
      }

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Google sign-in failed";
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  /// --- Updated SignOut Method --- ///

  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Sign out from Google
    await _auth.signOut(); // Sign out from Firebase
  }
}