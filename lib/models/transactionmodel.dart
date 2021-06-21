class TransactionModel {
  String sId;
  String username;
  String sharecapital;
  String thriftsavings;
  String specialdeposit;
  String commoditytrading;
  String fine;
  String loan;
  String projectfinancing;
  List<Transactions> transactions;
  int iV;

  TransactionModel(
      {this.sId,
      this.username,
      this.sharecapital,
      this.thriftsavings,
      this.specialdeposit,
      this.commoditytrading,
      this.fine,
      this.loan,
      this.projectfinancing,
      this.transactions,
      this.iV});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    sharecapital = json['sharecapital'];
    thriftsavings = json['thriftsavings'];
    specialdeposit = json['specialdeposit'];
    commoditytrading = json['commoditytrading'];
    fine = json['fine'];
    loan = json['loan'];
    projectfinancing = json['projectfinancing'];
    if (json['transactions'] != null) {
      transactions = new List<Transactions>();
      json['transactions'].forEach((v) {
        transactions.add(new Transactions.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['sharecapital'] = this.sharecapital;
    data['thriftsavings'] = this.thriftsavings;
    data['specialdeposit'] = this.specialdeposit;
    data['commoditytrading'] = this.commoditytrading;
    data['fine'] = this.fine;
    data['loan'] = this.loan;
    data['projectfinancing'] = this.projectfinancing;
    if (this.transactions != null) {
      data['transactions'] = this.transactions.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Transactions {
  String sId;
  String transactiontype;
  String account;
  String amount;
  String narration;
  String date;

  Transactions(
      {this.sId,
      this.transactiontype,
      this.account,
      this.amount,
      this.narration,
      this.date});

  Transactions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    transactiontype = json['transactiontype'];
    account = json['account'];
    amount = json['amount'];
    narration = json['narration'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['transactiontype'] = this.transactiontype;
    data['account'] = this.account;
    data['amount'] = this.amount;
    data['narration'] = this.narration;
    data['date'] = this.date;
    return data;
  }
}
