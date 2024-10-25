class PosResponse {
  int totalcount;
  String pos;
  String transDate;
  double totalAmount;
  double totalVAT;
  double netAmount;

  PosResponse(
      {required this.totalcount,
      required this.pos,
      required this.transDate,
      required this.totalAmount,
      required this.totalVAT,
      required this.netAmount});

  factory PosResponse.fromJson(Map<String, dynamic> json) {
    return PosResponse(
        totalcount: json["totalcount"],
        pos: json["pos"],
        transDate: json["transDate"],
        totalAmount: json["totalAmount"],
        totalVAT: json["totalVAT"],
        netAmount: json["netAmount"]);
  }
}
