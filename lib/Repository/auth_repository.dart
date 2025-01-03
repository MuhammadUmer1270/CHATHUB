import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ChatHUb/features/common/repository/common_repositry_storefile.dart';
import 'package:ChatHUb/features/common/widget/utilis/error.dart';
import 'package:ChatHUb/info.dart';
import 'package:ChatHUb/models/user_model.dart';
import 'package:ChatHUb/screens/OTP_Screen.dart';
import 'package:ChatHUb/screens/moblielayout.dart';
import 'package:ChatHUb/screens/user_info_screen.dart';

// ignore: non_constant_identifier_names
final Authrepositerprovider = Provider((ref) => Authrepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class Authrepository {
  Authrepository({
    required this.auth,
    required this.firestore,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  signinwithphonenumber(BuildContext context, String phonenumber) async {
    // try{

    // }catch(e){}

    await auth.verifyPhoneNumber(
      phoneNumber: phonenumber,
      verificationCompleted: (phoneAuthCredential) async {
        await auth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (error) {
        showsnackbar(context, error);
      },
      codeSent: (verificationId, forceResendingToken) async {
        Navigator.pushNamed(context, OTPScreen.id, arguments: verificationId);
        // print("object&&&&&&&&&&&&&&&&&&&&&&&&7");
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  verfiyOTP(
      {required BuildContext context,
      required String verificationID,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamed(context, Userinfo.id);
    } on FirebaseAuthException catch (e) {
      showsnackbar(context, e.message);
    }
  }

  void storefile({
    required String name,
    required ProviderRef ref,
    required BuildContext context,
    required File? photo,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photourl = info[0]['profilePic'].toString();

      // ignore: unnecessary_null_comparison
      if (photourl != null) {
        photourl = await ref
            .read(Commonstorefiletofirebaseprovider)
            .storetofirebase(photo!, "profilepic/$uid");
      }
      final user = Usermodel(
          name: name,
          userid: uid,
          profileurl: photourl,
          online: true,
          phonenumber: auth.currentUser!.phoneNumber!,
          groupid: []);

      firestore.collection('users').doc(uid).set(user.toJson());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const moblielayout(),
          ),
          (route) => false);
    } catch (e) {
      showsnackbar(context, e);
    }
  }

  Future<Usermodel?> getcurrentuser() async {
    Usermodel? User;

    var user =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    if (user.data() != null) {
      User = Usermodel.fromJson(user.data()!);
    }

    return User;
  }

  Stream<Usermodel> getdataofuserafterauth(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => Usermodel.fromJson(event.data()!));
  }

  void Setuserstate(bool isonline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'online': isonline});
  }
}
