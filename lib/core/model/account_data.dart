class AccountData {
  List<Account>? data;
  bool? succeeded;
  String? message;

  AccountData({this.data, this.succeeded, this.message});

  AccountData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Account>[];
      json['data'].forEach((v) {
        data!.add(new Account.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['message'] = this.message;
    return data;
  }
}

class Account {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  int? id;
  String? created;

  String get fullName => "$firstName $lastName";

  Account(
      {this.firstName, this.lastName, this.phoneNumber, this.id, this.created});

  Account.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    id = json['id'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['id'] = this.id;
    data['created'] = this.created;
    return data;
  }
}
