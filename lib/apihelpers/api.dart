import 'dart:convert';
import 'dart:io';
import 'package:chadventmpcs/models/accountmodel.dart';
import 'package:chadventmpcs/models/membermodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var apiKey = "api_key=5fd2ac39-15d3-4935-a36a-509597984923";
var totalContribution;
var lasttransaction;

SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}

Future saveUserAccountInPrefs(user) async {
  List<String> totalContributionList = [];
  List<String> commodityTradingList = [];
  List<String> fineList = [];
  List<String> loanList = [];
  List<String> projectFinancingList = [];
  await http
      .get("https://chadventmpcs.herokuapp.com/json/accounts?$apiKey")
      .then((value) {
    var jsonBody = jsonDecode(value.body);
    for (var key in jsonBody) {
      if (key['username'] == user) {
        AccountModel accountModel = AccountModel.fromJson(key);
        if (accountModel.transactions.isEmpty) {
          totalContribution = 0;
          lasttransaction = {"transactiontype": null};
          prefs.setStringList("totalContributionList", totalContributionList);
          prefs.setStringList("commodityTradingList", commodityTradingList);
          prefs.setStringList("fineList", fineList);
          prefs.setStringList("loanList", loanList);
          prefs.setStringList("projectFinancingList", projectFinancingList);

          prefs.setString("username", user);
          prefs.setString(
              "totalcontribution", totalContribution.toStringAsFixed(2));
          prefs.setString("sharecapital", accountModel.sharecapital);
          prefs.setString("thriftsavings", accountModel.thriftsavings);
          prefs.setString("specialdeposit", accountModel.specialdeposit);
          prefs.setString("commoditytrading", accountModel.commoditytrading);
          prefs.setString("fine", accountModel.fine);
          prefs.setString("loan", accountModel.loan);
          prefs.setString("projectfinancing", accountModel.projectfinancing);
          prefs.setString("lasttransaction", json.encode(lasttransaction));
        } else {
          totalContribution = double.parse(accountModel.sharecapital) +
              double.parse(accountModel.thriftsavings) +
              double.parse(accountModel.specialdeposit);
          final lastTransactionIndex = accountModel.transactions.length - 1;
          totalContribution = totalContribution.toStringAsFixed(2);

          final transactionJson = accountModel.transactions;
          final jsonLength = transactionJson.length - 1;

          for (var i = jsonLength; i != -1; i--) {
            if (transactionJson[i].account == "sharecapital" ||
                transactionJson[i].account == "thriftsavings" ||
                transactionJson[i].account == "specialdeposit") {
              totalContributionList.add(jsonEncode(transactionJson[i]));
            } else if (transactionJson[i].account == "commoditytrading") {
              commodityTradingList.add(jsonEncode(transactionJson[i]));
            } else if (transactionJson[i].account == "fine") {
              fineList.add(jsonEncode(transactionJson[i]));
            } else if (transactionJson[i].account == "loan") {
              loanList.add(jsonEncode(transactionJson[i]));
            } else if (transactionJson[i].account == "projectfinancing") {
              projectFinancingList.add(jsonEncode(transactionJson[i]));
            }
          }

          totalContribution = totalContribution;
          lasttransaction = accountModel.transactions[lastTransactionIndex];

          prefs.setStringList("totalContributionList", totalContributionList);
          prefs.setStringList("commodityTradingList", commodityTradingList);
          prefs.setStringList("fineList", fineList);
          prefs.setStringList("loanList", loanList);
          prefs.setStringList("projectFinancingList", projectFinancingList);

          prefs.setString("username", user);
          prefs.setString("totalcontribution", totalContribution);
          prefs.setString("sharecapital", accountModel.sharecapital);
          prefs.setString("thriftsavings", accountModel.thriftsavings);
          prefs.setString("specialdeposit", accountModel.specialdeposit);
          prefs.setString("commoditytrading", accountModel.commoditytrading);
          prefs.setString("fine", accountModel.fine);
          prefs.setString("loan", accountModel.loan);
          prefs.setString("projectfinancing", accountModel.projectfinancing);
          prefs.setString("lasttransaction", json.encode(lasttransaction));
        }
      }
    }
  });
}

Future saveMembersInPrefs(user) async {
  List<String> membersList = [];
  await http
      .get("https://chadventmpcs.herokuapp.com/json/members?$apiKey")
      .then((value) async {
    membersList = [];
    var jsonBody = jsonDecode(value.body);
    for (var key in jsonBody) {
      MemberModel memberModel = MemberModel.fromJson(key);
      membersList.add(jsonEncode(key));
      if (key['username'] == user) {
        prefs.setString("title", memberModel.title);
        prefs.setString("firstname", memberModel.firstname);
        prefs.setString("lastname", memberModel.lastname);
        prefs.setString("middlename", memberModel.middlename);
        prefs.setString("position", memberModel.position);
        prefs.setString("membershipstatus", memberModel.membershipstatus);
        prefs.setString(
            "loanapplicationstatus", memberModel.loanapplicationstatus);
        prefs.setString("phonenumber", memberModel.phonenumber);
        prefs.setString("email", memberModel.email);
        prefs.setString("address", memberModel.address);
        prefs.setString("gender", memberModel.address);
        prefs.setString("occupation", memberModel.occupation);
        prefs.setString("nextofkin", memberModel.nextofkin);
        prefs.setString("nextofkinaddress", memberModel.nextofkinaddress);
      }
    }
    prefs.setStringList("membersList", membersList);
  });
}

Future saveNewsInPrefs() async {
  List<String> newsList = [];
  await http
      .get("https://chadventmpcs.herokuapp.com/json/news?$apiKey")
      .then((value) {
    newsList = [];
    var jsonFromApi = jsonDecode(value.body);
    var jsonLength = jsonFromApi.length - 1;
    for (var i = jsonLength; i != -1; i--) {
      var encoded = json.encode(jsonFromApi[i]);
      newsList.add(encoded);
    }
    prefs.setStringList("newsList", newsList);
  });
}

Future savePrefs() async {
  prefs = await SharedPreferences.getInstance();
  var username = prefs.getString("username");
  try {
    await saveUserAccountInPrefs(username).then((value) async {
      await saveMembersInPrefs(username).then((value) async {
        await saveNewsInPrefs();
      });
    });
  } catch (e) {
    print(e);
  }
}

Future<bool> logUserIn(username, password) async {
  var finalBool = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      await http.post("https://chadventmpcs.herokuapp.com/json/login?$apiKey",
          body: {
            "username": username,
            "password": password
          }).then((value) async {
        var body = jsonDecode(value.body);
        if (body['message'] == "success") {
          try {
            await saveUserAccountInPrefs(username).then((value) async {
              await saveMembersInPrefs(username).then((value) async {
                await saveNewsInPrefs().then((value) {
                  finalBool = true;
                });
              });
            });
          } catch (e) {
            print(e);
          }
        } else if (body['message'] == "Error") {
          finalBool = false;
        }
      });
    } else {
      finalBool = false;
    }
    return finalBool;
  } catch (e) {
    return finalBool;
  }
}
