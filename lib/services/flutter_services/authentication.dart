import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';

class AuthObject {
  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
            msg: 'Email is invalid',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: 'Wrong password',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      } else if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'User not found',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      } else {
        Fluttertoast.showToast(
            msg: e.code.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "Password too weak",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Account already exists for this email",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
            msg: e.code.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        FirestoreObject firestoreObject = FirestoreObject();
        firestoreObject
            .addGoogleUser('${FirebaseAuth.instance.currentUser!.displayName}');
      } else {
        return false;
      }
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> isUserSignedIn() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }
}
