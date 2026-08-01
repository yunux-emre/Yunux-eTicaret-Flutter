import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_projesi/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel {
    return userModel;
  }

  Future<void> ensureUserDocumentExists() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      return;
    }

    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);
    final userDoc = await userRef.get();

    if (userDoc.exists) {
      return;
    }

    await userRef.set({
      "userId": user.uid,
      "userName": user.displayName ?? "",
      "userImage": user.photoURL ?? "",
      "userEmail": user.email ?? "",
      "createdAt": Timestamp.now(),
      "userWish": [],
      "userCart": [],
    });
  }

  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    String uid = user.uid;
    try {
      await ensureUserDocumentExists();
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final userDocDict = userDoc.data();
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userEmail: userDoc.get('userEmail'),
        userCart: userDocDict!.containsKey("userCart")
            ? userDoc.get("userCart")
            : [],
        userWish: userDocDict.containsKey("userWish")
            ? userDoc.get("userWish")
            : [],
        createdAt: userDoc.get('createdAt'),
      );
      return userModel;
      // ignore: unused_catch_clause
    } on FirebaseException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
