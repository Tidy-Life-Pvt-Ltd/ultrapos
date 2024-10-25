
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/apiresponse.dart';
import '../model/checklist.dart';
import '../model/loginresponse.dart';
import '../model/reportresponse.dart';
import 'config.dart';

class APIService {
  Future<ApiResponse> login(LoginRequest loginRequest) async {
    try {
      String url = ApiUrl.url + ApiUrl.login;
      final data = jsonEncode(
          {'UserName':loginRequest.username,
            'Password':loginRequest.password,
            'CompanyCode':loginRequest.comanyCode
          });
      final response = await http.post(Uri.parse(url),
          body: data,
          headers: ApiUrl.headers);

      print('---- uRL ----- $url');

      print("==== LOGIN REQUEST ==== $data");
      print('==================================');
      print("==== LOGIN RESPONSE  ==== ${response.body}");


      if (response.statusCode < 200 || response.statusCode > 400) {
        return ApiResponse.loginJson(json.decode(response.body),
        );
      } else {
        return ApiResponse.loginJson(
          json.decode(response.body),
        );
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse(
          status: false);
    }
  }

  Future<ApiResponse> getBranches(String groupCode) async {
    String url = ApiUrl.url + ApiUrl.getBranches;

    final data = jsonEncode({"groupCode":groupCode});
    final response = await http.post(Uri.parse(url),
        body: data,
        headers: ApiUrl.headers);
    print('---- uRL ----- ${url}');

    print("==== GET REQUEST ==== ${data.toString()}");
    print('=*****************************g********=');
    print("==== GET RESPONSE  ==== ${response.body}");

    if (response.statusCode < 200 || response.statusCode > 400) {
      return ApiResponse.branchesFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.branchesFromJson(
        json.decode(response.body),
      );
    }
  }

  Future<ApiResponse> getChartReprort(ReportRequest reportRequest) async {
    String url = ApiUrl.url + ApiUrl.getChartReport;
    final data = jsonEncode({'CompanyCode': reportRequest.CompanyCode,
      'FromDate': reportRequest.FromDate,
      'Todate': reportRequest.Todate,
      'IsMonthlySummary': reportRequest.IsMonthlySummary,
      'IsWeeklySummary': reportRequest.IsWeeklySummary,
      'IsDaySummary': reportRequest.IsDaySummary,});
    final response = await http.post(Uri.parse(url),
        body: data,
        headers: ApiUrl.headers);

    print('---- uRL ----- ${url}');

    print("==== CHART REQUEST ==== ${data}");
    print('==================================');
    print("==== CHART RESPONSE  ==== ${response.body.toString()}");

    if (response.statusCode < 200 || response.statusCode > 400) {
      return ApiResponse.reportFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.reportFromJson(
        json.decode(response.body),
      );
    }
  }

  Future<ApiResponse> getCustomer(String customerName,String companyCode,String typ) async {
    String url = ApiUrl.url + ApiUrl.getCustomer;
    final data = jsonEncode({"CustomerName":customerName,"CompanyCode":companyCode,"type":typ});

    final response = await http.post(Uri.parse(url),
        body: data,
        headers: ApiUrl.headers);
    print('---- uRL ----- ${url}');

    print("==== GET CUSTOMER REQUEST ==== ${data}");
    print('==================================');
    print("==== GET CUSTOMER REQUEST RESPONSE  ==== ${response.body.toString()}");
    if (response.statusCode < 200 || response.statusCode > 400) {
      return ApiResponse.customerFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.customerFromJson(
        json.decode(response.body),
      );
    }
  }

  Future<ApiResponse> getPdcReprort(PDCReportRequest reportRequest) async {
    String url = ApiUrl.url + ApiUrl.getPdcReport;
    final data = jsonEncode({'CompanyCode': reportRequest.CompanyCode,
      'FromDate': reportRequest.FromDate,
      'Todate': reportRequest.Todate,
      'Status': reportRequest.Status,
      'isLoad': reportRequest.isLoad,
      'CustomerName': reportRequest.CustomerName,});
    final response = await http.post(Uri.parse(url),
        body: data,
        headers: ApiUrl.headers);
    print('---- uRL ----- ${url}');

    print("==== PDC REQUEST ==== ${data}");
    print('==================================');
    print("==== PDC RESPONSE  ==== ${response.body.toString()}");
    if (response.statusCode < 200 || response.statusCode > 400) {
      return ApiResponse.pdcFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.pdcFromJson(
        json.decode(response.body),
      );
    }
  }

  Future<ApiResponse> getPosReprort(String companyCode,String fromDate, String toDate) async {
    String url = ApiUrl.url + ApiUrl.getPosReport;
    final data = jsonEncode({'CompanyCode': companyCode,
      'FromDate': fromDate,
      'Todate': toDate});
    final response = await http.post(Uri.parse(url),
        body: data,
        headers: ApiUrl.headers);

    print('---- uRL ----- ${url}');

    print("==== POS REQUEST ==== ${data}");
    print('==================================');
    print("==== POS RESPONSE  ==== ${response.body.toString()}");

    if (response.statusCode < 200 || response.statusCode > 400) {
      return ApiResponse.posFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.posFromJson(
        json.decode(response.body),
      );
    }
  }
  Future<ApiResponse> getSalesReprort(TotalReportRequest reportRequest) async {
    String url = ApiUrl.url + ApiUrl.getSales;
    final data = jsonEncode({'CompanyCode': reportRequest.CompanyCode,
      'FromDate': reportRequest.FromDate,
      'Todate': reportRequest.Todate,
      'Type': reportRequest.type,
      'InvoiceNo': reportRequest.InvoiceNo,
      'CustomerID': reportRequest.custId,
      'DayWiseSummary': reportRequest.DayWiseSummary,
      'TotalSummary': reportRequest.TotalSummary,
      'CustomerWiseSummary': reportRequest.CustomerWiseSummary,});
    final response = await http.post(Uri.parse(url),
        body: data,
        headers: ApiUrl.headers);
    print('***** DEBUGGING INFORMATION *****');
    print('HEADERS: ${ApiUrl.headers}');
    print('URL: $url');
    print('BODY: $data');
    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');
    print('*****************');

    if (response.statusCode < 200 || response.statusCode > 400) {
      print('---- RESPONSE ------  ${response.statusCode}');
      return ApiResponse.salesFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.salesFromJson(
        json.decode(response.body),
      );
    }
  }
 /* Future<ApiResponse> getSalesReprorter(TotalReportRequest reportRequest) async {
    String url = Config.url + Config.getSales;
    final data = jsonEncode({'CompanyCode': reportRequest.CompanyCode,
      'FromDate': reportRequest.FromDate,
      'Todate': reportRequest.Todate,
      'Type': reportRequest.type,
      'InvoiceNo': reportRequest.InvoiceNo,
      'CustomerID': reportRequest.custId,
      'DayWiseSummary': reportRequest.DayWiseSummary,
      'TotalSummary': reportRequest.TotalSummary,
      'CustomerWiseSummary': reportRequest.CustomerWiseSummary,});
    final response = await http.post(Uri.parse(url),
        body: data,
        headers: Config.headers);
    print("-------------Sales Data-------------->   " +
        response.body.toString()+"              "+data);
    // Debugging

    if (response.statusCode < 200 || response.statusCode > 400 ||
        json == null) {
      return ApiResponse.salesFromJson(
        json.decode(response.body),
      );
    } else {
      return ApiResponse.salesFromJson(
        json.decode(response.body),
      );
    }
  }*/



}


