import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search/src/features/core/user_model.dart';


class Userrepository extends GetxController{
  static Userrepository get instance =>Get.find();
  final _db =FirebaseFirestore.instance;
  createUser(UserModel user)async{
   await  _db.collection("Patients").add(user.toJson()).whenComplete(() => GetSnackBar(
      snackPosition:SnackPosition.BOTTOM ,backgroundColor: Colors.green.withOpacity(0.1),)
    );
  }
}