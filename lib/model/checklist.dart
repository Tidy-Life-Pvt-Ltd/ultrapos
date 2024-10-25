class CheckListResponse {
  String slipNo;
  double amount;
  String chequeNo;
  String ledgerName;
  String? age;
  int? ages;
  String bankName;
  String cheqDate;
  String status;
  String transDate;
  String transType;

  CheckListResponse(
      {required this.slipNo,
      required this.amount,
      required this.chequeNo,
      required this.ledgerName,
      this.age,
      required this.bankName,
      required this.cheqDate,
      required this.status,
      required this.transDate,
      required this.transType,
      this.ages});

  factory CheckListResponse.fromJson(Map<String, dynamic> json) {
    return CheckListResponse(
        slipNo: json["slipNo"],
        amount: json["amount"],
        chequeNo: json["cheque_No"],
        ledgerName: json["ledgerName"],
        age: json["age"],
        bankName: json["bankName"],
        cheqDate: json["cheq_date"],
        status: json["status"],
        transDate: json["transDate"],
        transType: json["transType"]);
  }
  factory CheckListResponse.pdcFromJson(Map<String, dynamic> json) {
    return CheckListResponse(
        slipNo: json["slipNo"],
        amount: json["amount"],
        chequeNo: json["cheque_No"],
        ledgerName: json["ledgerName"],
        ages: json["age"],
        bankName: json["bankName"],
        cheqDate: json["cheq_date"],
        status: json["status"],
        transDate: json["transDate"],
        transType: json["transType"]);
  }
}

class PDCReportRequest {
  final String CompanyCode;
  String Status;
  String FromDate;
  String Todate;
  bool isLoad;
  String CustomerName;

  PDCReportRequest(
      {required this.CompanyCode,
      required this.Status,
      required this.FromDate,
      required this.Todate,
      required this.isLoad,
      required this.CustomerName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'CompanyCode': CompanyCode,
      'Status': Status,
      'FromDate': FromDate,
      'Todate': Todate,
      'isLoad': isLoad,
      'CustomerName': CustomerName,
    };
    return map;
  }
}
