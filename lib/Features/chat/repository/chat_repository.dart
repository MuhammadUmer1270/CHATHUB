import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ChatHUb/features/chat/widget/chat_contact_info.dart';
import 'package:ChatHUb/features/chat/widget/message.dart';
import 'package:ChatHUb/features/common/enums/msg_enum.dart';
import 'package:ChatHUb/features/common/repository/common_repositry_storefile.dart';
import 'package:ChatHUb/features/common/widget/utilis/error.dart';
import 'package:ChatHUb/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatrepostoryprovider = Provider((ref) => Chatrepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class Chatrepository {
  Chatrepository({
    required this.firestore,
    required this.auth,
  });

  FirebaseFirestore firestore;

  FirebaseAuth auth;
//for text messsages
  void sendtextmsg(
      {required BuildContext context,
      required String reciverid,
      required Usermodel sender,
      required String text,
      Messagetype type = Messagetype.text}) async {
    try {
      var time = DateTime.now();
      Usermodel receiver;

      var userdata = await firestore.collection('users').doc(reciverid).get();
      String messageid = const Uuid().v1();
      receiver = Usermodel.fromJson(userdata.data()!);
      _savechatscreendatatosubcollection(
          receiver, reciverid, sender, time, text);
      _savemsgtosubcollection(
          type: type,
          text: text,
          messageid: messageid as String,
          senderid: sender.userid,
          receiverid: reciverid,
          timesent: DateTime.now());
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }

// for contactlist on ChatHUb start screen
  _savemsgtosubcollection({
    required Messagetype type,
    required String text,
    required String messageid,
    required String senderid,
    required String receiverid,
    required DateTime timesent,
  }) async {
    try {
      final msg = Message(
          type: type,
          text: text,
          messageid: messageid,
          senderid: auth.currentUser!.uid,
          receiverid: receiverid,
          timesent: timesent,
          isseen: false);
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverid)
          .collection('messages')
          .doc(messageid)
          .set(msg.toJson());

      await firestore
          .collection('users')
          .doc(receiverid)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageid)
          .set(msg.toJson());
    } catch (e) {
      throw e;
    }
  }

//  overall chatdata
  _savechatscreendatatosubcollection(Usermodel receiver, String reciverid,
      Usermodel sender, DateTime time, msg) async {
    try {
      var reciverchatcontact = Chatcontactinfo(
          name: sender.name,
          profilepic: sender.profileurl,
          contactid: sender.userid,
          lastmsg: msg,
          time: time);
      await firestore
          .collection('users')
          .doc(reciverid)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(reciverchatcontact.toJson());
      var senderchattcontact = Chatcontactinfo(
          name: receiver.name,
          profilepic: receiver.profileurl,
          contactid: receiver.userid,
          lastmsg: msg,
          time: time);
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverid)
          .set(senderchattcontact.toJson());
    } catch (e) {
      SnackBar(content: Text("${e}"));
    }
  }

// find new contact on appp
  Stream<List<Chatcontactinfo>> getconctedcontacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<Chatcontactinfo> contactlist = [];
      for (var doc in event.docs) {
        var contact = Chatcontactinfo.fromJson(doc.data());

        var userdata =
            await firestore.collection('users').doc(contact.contactid).get();

        var user = Usermodel.fromJson(userdata.data()!);
        print(user);
        contactlist.add(Chatcontactinfo(
            name: user.name,
            profilepic: user.profileurl,
            contactid: contact.contactid,
            lastmsg: contact.lastmsg,
            time: contact.time));
      }
      return contactlist;
    });
  }

// getmesages from firebase
  Stream<List<Message>> getmessages(String receiverid) {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverid)
        .collection("messages")
        .orderBy("timesent")
        .snapshots()
        .map((event) {
      List<Message> Messages = [];
      for (var msg in event.docs) {
        Messages.add(Message.fromJson(msg.data()));
      }
      return Messages.reversed.toList();
    });
  }

// sendfile
  void sendfilemessage(
      {required Ref ref,
      required BuildContext context,
      required File file,
      required Messagetype messagetype,
      required String recevierId,
      required Usermodel senderdata}) async {
    String messageid = Uuid().v1();

    String fileurl = await ref
        .read(Commonstorefiletofirebaseprovider)
        .storetofirebase(file,
            'chats/${messagetype.type}/${senderdata.userid}/$recevierId/$messageid');
    var type;
    switch (messagetype) {
      case Messagetype.audio:
        type = "🔉audio";
        break;
      case Messagetype.vedio:
        type = "📽 video";
        break;

      case Messagetype.gif:
        type = "gif";
        break;

      case Messagetype.image:
        type = "📸 Image";
        break;

      case Messagetype.text:
        break;
    }
    var time = DateTime.now();
    _savemsgtosubcollection(
        type: messagetype,
        text: fileurl,
        messageid: messageid,
        senderid: senderdata.userid,
        receiverid: recevierId,
        timesent: time);
    var recevierdata =
        await firestore.collection("users").doc(recevierId).get();
    Usermodel recevier = Usermodel.fromJson(recevierdata.data()!);
    _savechatscreendatatosubcollection(
        recevier, recevierId, senderdata, time, type);
  }
}
