class Customer {
  String custID;
  String custName;

  Customer({required this.custID, required this.custName});

  @override
  String toString() {
    return '$custName ($custID)';
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(custID: json["custID"], custName: json["custName"]);
  }
}
