class MemberModel {
  String sId;
  String username;
  String title;
  String firstname;
  String lastname;
  String middlename;
  String position;
  String membershipstatus;
  String loanapplicationstatus;
  String phonenumber;
  String email;
  String address;
  String gender;
  String occupation;
  String nextofkin;
  String nextofkinaddress;
  String bank;
  String accountnumber;
  int iV;

  MemberModel(
      {this.sId,
      this.username,
      this.title,
      this.firstname,
      this.lastname,
      this.middlename,
      this.position,
      this.membershipstatus,
      this.loanapplicationstatus,
      this.phonenumber,
      this.email,
      this.address,
      this.gender,
      this.occupation,
      this.nextofkin,
      this.nextofkinaddress,
      this.bank,
      this.accountnumber,
      this.iV});

  MemberModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    title = json['title'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    middlename = json['middlename'];
    position = json['position'];
    membershipstatus = json['membershipstatus'];
    loanapplicationstatus = json['loanapplicationstatus'];
    phonenumber = json['phonenumber'];
    email = json['email'];
    address = json['address'];
    gender = json['gender'];
    occupation = json['occupation'];
    nextofkin = json['nextofkin'];
    nextofkinaddress = json['nextofkinaddress'];
    bank = json['bank'];
    accountnumber = json['accountnumber'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['title'] = this.title;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['middlename'] = this.middlename;
    data['position'] = this.position;
    data['membershipstatus'] = this.membershipstatus;
    data['loanapplicationstatus'] = this.loanapplicationstatus;
    data['phonenumber'] = this.phonenumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['occupation'] = this.occupation;
    data['nextofkin'] = this.nextofkin;
    data['nextofkinaddress'] = this.nextofkinaddress;
    data['bank'] = this.bank;
    data['accountnumber'] = this.accountnumber;
    data['__v'] = this.iV;
    return data;
  }
}