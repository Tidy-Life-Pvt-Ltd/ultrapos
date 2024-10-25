import 'package:project_ultra/model/pos.dart';
import 'package:project_ultra/model/reportresponse.dart';
import 'branchresponse.dart';
import 'checklist.dart';
import 'customer.dart';

class ApiResponse {
  final bool? status;
  final String? message;
  final List<BranchResponse>? branchList;
  final List<ReportResponse>? reportList;
  final List<Customer>? customerList;
  final List<CheckListResponse>? pdcList;
  final List<PosResponse>? posList;
  final List<TotalReportResponse>? salesList;

  ApiResponse({
    this.status,
    this.message,
    this.branchList,
    this.reportList,
    this.customerList,
    this.pdcList,
    this.posList,
    this.salesList,
  });

  factory ApiResponse.branchesFromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      branchList: List<BranchResponse>.from(
          json["branches"].map((x) => BranchResponse.fromJson(x))),
    );
  }

  factory ApiResponse.loginJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
    );
  }

  factory ApiResponse.reportFromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      reportList: List<ReportResponse>.from(
          json["transSummaryLists"].map((x) => ReportResponse.fromJson(x))),
    );
  }

  factory ApiResponse.customerFromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      customerList: List<Customer>.from(
          json["customerLists"].map((x) => Customer.fromJson(x))),
    );
  }

  factory ApiResponse.pdcFromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      pdcList: List<CheckListResponse>.from(
          json["chequeLists"].map((x) => CheckListResponse.pdcFromJson(x))),
    );
  }

  factory ApiResponse.posFromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      posList: List<PosResponse>.from(
          json["posSummaryLists"].map((x) => PosResponse.fromJson(x))),
    );
  }

  factory ApiResponse.salesFromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      salesList: List<TotalReportResponse>.from(json["transactionDetails"]
          .map((x) => TotalReportResponse.fromJson(x))),
    );
  }
}
