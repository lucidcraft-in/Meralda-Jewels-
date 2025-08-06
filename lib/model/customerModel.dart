class UserModel {
  final String id;
  final String name;
  final String custId;
  final String phoneNo;
  final String address;
  final String place;
  final double balance;
  final String staffId;
  final String token;
  final String schemeType;
  final double totalGram;
  final String branch;
  final String? branchName;
  final DateTime dateofBirth;
  final String nominee;
  final String nomineePhone;
  final String? nomineeRelation;
  final String adharCard;
  final String? panCard;
  final String? pinCode;
  final String? staffName;
  final String? mailId;
  final double? tax;
  final double? amc;
  final String? country;

  UserModel(
      {required this.id,
      required this.name,
      required this.custId,
      required this.phoneNo,
      required this.address,
      required this.place,
      required this.balance,
      required this.staffId,
      required this.token,
      required this.schemeType,
      required this.totalGram,
      required this.branch,
      this.branchName,
      required this.dateofBirth,
      required this.nominee,
      required this.nomineePhone,
      this.nomineeRelation,
      required this.adharCard,
      this.panCard,
      this.pinCode,
      this.staffName,
      required this.mailId,
      required this.tax,
      required this.amc,
      required this.country});

  // Add this copyWith method
  UserModel copyWith(
      {String? id,
      String? name,
      String? custId,
      String? phoneNo,
      String? address,
      String? place,
      double? balance,
      String? staffId,
      String? token,
      String? schemeType,
      double? totalGram,
      String? branch,
      String? branchName,
      DateTime? dateofBirth,
      String? nominee,
      String? nomineePhone,
      String? nomineeRelation,
      String? adharCard,
      String? panCard,
      String? pinCode,
      String? staffName,
      String? mailId,
      double? tax,
      double? amc,
      String? country}) {
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        custId: custId ?? this.custId,
        phoneNo: phoneNo ?? this.phoneNo,
        address: address ?? this.address,
        place: place ?? this.place,
        balance: balance ?? this.balance,
        staffId: staffId ?? this.staffId,
        token: token ?? this.token,
        schemeType: schemeType ?? this.schemeType,
        totalGram: totalGram ?? this.totalGram,
        branch: branch ?? this.branch,
        branchName: branchName ?? this.branchName,
        dateofBirth: dateofBirth ?? this.dateofBirth,
        nominee: nominee ?? this.nominee,
        nomineePhone: nomineePhone ?? this.nomineePhone,
        nomineeRelation: nomineeRelation ?? this.nomineeRelation,
        adharCard: adharCard ?? this.adharCard,
        panCard: panCard ?? this.panCard,
        pinCode: pinCode ?? this.pinCode,
        staffName: staffName ?? this.staffName,
        mailId: mailId ?? this.mailId,
        tax: tax ?? this.tax,
        amc: amc ?? this.amc,
        country: country ?? this.country);
  }

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        custId = data['custId'],
        phoneNo = data['phonne_no'],
        address = data['address'],
        place = data['place'],
        balance = data['balance'],
        staffId = data['staffId'],
        token = data['token'],
        schemeType = data['schemeType'],
        totalGram = data['total_gram'],
        branch = data['branch'],
        branchName = data["branchName"],
        dateofBirth = data['dateofBirth'],
        nominee = data['nominee'],
        nomineePhone = data['nomineePhone'],
        nomineeRelation = data['nomineeRelation'],
        adharCard = data['adharCard'],
        panCard = data['panCard'],
        pinCode = data['pinCode'],
        staffName = data['staffName'],
        mailId = data['mailId'],
        amc = data["amc"],
        tax = data["tax"],
        country = data["country"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'custId': custId,
      'phone_no': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
      'staffId': staffId,
      'token': token,
      'schemeType': schemeType,
      'total_gram': totalGram,
      'branch': branch,
      "branchName": branchName,
      'dateofBirth': dateofBirth,
      'nominee': nominee,
      'nomineePhone': nomineePhone,
      'nomineeRelation': nomineeRelation,
      'adharCard': adharCard,
      'panCard': panCard,
      'pinCode': pinCode,
      'staffName': staffName,
      "amc": amc,
      "tax": tax,
      "mailId": mailId,
      "country": country
    };
  }
}
