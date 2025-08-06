class Branch {
  String? id;
  String branchName;
  String address;
  String place;
  String phone;
  String staffId;
  String staffName;
  DateTime createdAt;
  String branchLocation;

  Branch(
      {this.id,
      required this.branchName,
      required this.address,
      required this.place,
      required this.phone,
      required this.staffId,
      required this.staffName,
      required this.createdAt,
      required this.branchLocation});

  factory Branch.fromMap(Map<String, dynamic> map, String id) {
    return Branch(
      id: id,
      branchName: map['branchName'] ?? '',
      address: map['address'] ?? '',
      place: map['place'] ?? '',
      phone: map["phone"],
      staffId: map['staffId'] ?? '',
      staffName: map['staffName'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      branchLocation: map['branchLocation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'branchName': branchName,
      'address': address,
      'place': place,
      'phone': phone,
      'staffId': staffId,
      'staffName': staffName,
      'createdAt': createdAt,
      "branchLocation": branchLocation
    };
  }
}
