import 'package:todo/constants/auth_constants.dart';
import 'package:todo/features/authentication/data/repositories/auth_repository.dart';
import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/features/authentication/domain/models/user_model.dart';

/// A implementation class of [AuthRepository] for firebase auth.

class FirebaseAuthImpl implements AuthRepository {
  /// Creates an instance of [FirebaseAuthImpl].
  FirebaseAuthImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: webClientId,
  );

  @override
  Future<bool> isLoggedIn() async {
    final User? currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    CredentialsModel credentialsModel,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: credentialsModel.email,
        password: credentialsModel.password,
      );

      UserModel user = UserModel(
        uuid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        displayName: userCredential.user!.displayName ?? 'Anon Name',
        photoURL: userCredential.user!.photoURL ??
            'https://www.unigreet.com/wp-content/uploads/2023/03/Cute-Cat-Whatsapp-Dp-HD.jpg',
      );

      return user;
    } on FirebaseAuthException {
      // Handle google sign-in error
      rethrow;
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    CredentialsModel credentialsModel,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: credentialsModel.email,
        password: credentialsModel.password,
      );
      UserModel user = UserModel(
        uuid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        displayName: userCredential.user!.displayName ?? 'Anon Name',
        photoURL: userCredential.user!.photoURL ??
            'https://www.unigreet.com/wp-content/uploads/2023/03/Cute-Cat-Whatsapp-Dp-HD.jpg',
      );

      return user;
    } on FirebaseAuthException {
      // Handle google sign-in error
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      UserModel user = UserModel(
        uuid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        displayName: userCredential.user!.displayName ?? 'Anon Name',
        photoURL: userCredential.user!.photoURL ??
            'https://picsum.photos/seed/picsum/200/300',
      );

      return user;
    } on FirebaseAuthException {
      // Handle google sign-in error
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
