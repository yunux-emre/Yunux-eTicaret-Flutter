import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobil_projesi/root_screen.dart';
import 'package:mobil_projesi/services/my_app_functions.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
              "userId": userCredential.user!.uid,
              "userName": userCredential.user!.displayName,
              "userImage": googleUser.photoUrl ?? userCredential.user!.photoURL,
              "userEmail": userCredential.user!.email,
              "createdAt": Timestamp.now(),
              "userWish": [],
              "userCart": [],
            });
      }

      if (!context.mounted) return;

      Navigator.pushReplacementNamed(context, RootScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.message ?? e.code,
        fct: () {},
      );
    } catch (e) {
      if (!context.mounted) return;

      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Ionicons.logo_google, color: Colors.red),
      label: const Text(
        "Google ile giriş",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () => _googleSignIn(context),
    );
  }
}
