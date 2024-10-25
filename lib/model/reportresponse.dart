class ReportResponse {
  int? totalcount;
  double totalAmount;
  double totalVAT;
  double netAmount;
  String? value;

  ReportResponse(
      {this.totalcount,
      required this.totalAmount,
      required this.totalVAT,
      required this.netAmount,
      this.value});

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      totalcount: json["totalcount"] != null ? json["totalcount"] : 0,
      totalAmount: json["totalAmount"] is int
          ? (json["totalAmount"] as int).toDouble()
          : json["totalAmount"],
      totalVAT: json["totalVAT"] is int
          ? (json["totalVAT"] as int).toDouble()
          : json["totalVAT"],
      netAmount: json["netAmount"] is int
          ? (json["netAmount"] as int).toDouble()
          : json["netAmount"],
      value: json["value"],
    );
  }

  factory ReportResponse.fromJsonDaily(Map<String, dynamic> json) {
    return ReportResponse(
      totalAmount: json["totalAmount"] is int
          ? (json["totalAmount"] as int).toDouble()
          : json["totalAmount"],
      totalVAT: json["totalVAT"] is int
          ? (json["totalVAT"] as int).toDouble()
          : json["totalVAT"],
      netAmount: json["netAmount"] is int
          ? (json["netAmount"] as int).toDouble()
          : json["netAmount"],
    );
  }
}

class TotalReportResponse {
  String invoiceId;
  String salesDate;
  String salesTpe;
  double totalAmount;
  double vatAmount;
  double netAmount;

  TotalReportResponse(
      {required this.invoiceId,
      required this.salesDate,
      required this.salesTpe,
      required this.totalAmount,
      required this.vatAmount,
      required this.netAmount});

  factory TotalReportResponse.fromJson(Map<String, dynamic> json) {
    return TotalReportResponse(
      invoiceId: json["invoiceId"],
      salesDate: json["salesDate"],
      salesTpe: json["salesTpe"],
      totalAmount: json["totalAmount"] is int
          ? (json["totalAmount"] as int).toDouble()
          : json["totalAmount"],
      vatAmount: json["vatAmount"] is int
          ? (json["vatAmount"] as int).toDouble()
          : json["vatAmount"],
      netAmount: json["netAmount"] is int
          ? (json["netAmount"] as int).toDouble()
          : json["netAmount"],
    );
  }
}

class ReportRequest {
  final String CompanyCode;
  String FromDate;
  String Todate;
  bool IsMonthlySummary;
  bool IsWeeklySummary;
  bool IsDaySummary;

  ReportRequest(
      {required this.CompanyCode,
      required this.FromDate,
      required this.Todate,
      required this.IsMonthlySummary,
      required this.IsWeeklySummary,
      required this.IsDaySummary});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'CompanyCode': CompanyCode,
      'FromDate': FromDate,
      'Todate': Todate,
      'IsMonthlySummary': IsMonthlySummary,
      'IsWeeklySummary': IsWeeklySummary,
      'IsDaySummary': IsDaySummary,
    };

    return map;
  }
}

class DailyReportRequest {
  final String CompanyCode;
  int days;

  DailyReportRequest({required this.CompanyCode, required this.days});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'CompanyCode': CompanyCode,
      'days': days,
    };

    return map;
  }
}

class TotalReportRequest {
  final String CompanyCode;
  String type;
  String FromDate;
  String Todate;
  String? custId;
  String? InvoiceNo;
  bool DayWiseSummary;
  bool TotalSummary;
  bool CustomerWiseSummary;

  TotalReportRequest(
      {required this.CompanyCode,
      required this.type,
      required this.FromDate,
      required this.Todate,
      required this.DayWiseSummary,
      required this.TotalSummary,
      required this.CustomerWiseSummary,
      this.custId,
      this.InvoiceNo});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'CompanyCode': CompanyCode,
      'Type': type,
      'FromDate': FromDate,
      'Todate': Todate,
      'DayWiseSummary': DayWiseSummary,
      'TotalSummary': TotalSummary,
      'CustomerWiseSummary': CustomerWiseSummary,
    };
    return map;
  }

  Map<String, dynamic> salesToJson() {
    Map<String, dynamic> map = {
      'CompanyCode': CompanyCode,
      'Type': type,
      'FromDate': FromDate,
      'Todate': Todate,
      'DayWiseSummary': DayWiseSummary,
      'TotalSummary': TotalSummary,
      'CustomerWiseSummary': CustomerWiseSummary,
      'CustomerID': custId,
      'InvoiceNo': InvoiceNo,
    };
    return map;
  }
}
