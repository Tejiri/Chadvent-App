import 'dart:io';

import 'package:intl/intl.dart';

var formatter = NumberFormat("#,###,000");

Future<bool> checkForInternet() async {
  var boolean = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      boolean = true;
    }
    return boolean;
  } on SocketException catch (_) {
    return boolean;
  } catch (e) {
    return boolean;
  }
}

performFormating(accountbalance) {
  try {
    var balanceSplit = accountbalance.split(".");
    final finalFormatedBalance = "₦" +
        formatter.format(double.parse(balanceSplit[0])) +
        ".${balanceSplit[1]}";
    return finalFormatedBalance;
  } catch (e) {
    final finalFormatedBalance =
        "₦" + formatter.format(double.parse(accountbalance));
    return finalFormatedBalance;
  }
}
