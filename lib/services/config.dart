import 'dart:convert';


class ApiUrl {
  static String url = "http://reportingapp-001-site5.btempurl.com/api/";
  static String API_USER_NAME = "Admin";
  static String API_PASSWORD = "Admin@1\$";

  static String basicAuth = 'Basic ' + base64.encode(utf8.encode('$API_USER_NAME:$API_PASSWORD'));

  static Map<String, String> headers = {"Content-type": "application/json",'authorization': basicAuth};


  static String login = "User/UserLogin";
  static String getBranches = "User/BranchList";
  static String getChartReport = "Transaction/GetTranactionSummary";
  static String getCustomer = "Customer/CustomerDetails";
  static String getPdcReport = "Transaction/ChequeDetails";
  static String getPosReport = "Transaction/GetPosSummary";
  static String getSales = "Transaction/GetTransaction";


}

