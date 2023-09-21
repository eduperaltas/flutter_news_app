import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastMsg(String msg, {dynamic duration=Toast.LENGTH_SHORT}){
  return Fluttertoast.showToast(
    
    msg: msg,
    toastLength: duration,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0
    
  );
}