class BranchResponse {
  final String companyCode;
  final String companyName;

  BranchResponse({required this.companyCode, required this.companyName});

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    return BranchResponse(
        companyCode: json["companyCode"], companyName: json["companyName"]);
  }
}

class BranchRequest {
  final String groupCode;

  BranchRequest({required this.groupCode});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'groupCode': groupCode};
    return map;
  }
}
