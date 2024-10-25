import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ultra/model/checklist.dart';
import 'package:project_ultra/model/customer.dart';
import 'package:project_ultra/model/reportresponse.dart';
import 'package:project_ultra/services/api.dart';
import 'package:project_ultra/utils/chart_utils.dart';
import 'package:project_ultra/utils/customcolor.dart';
import 'package:project_ultra/utils/divider.dart';
import 'package:project_ultra/utils/shared_prefs.dart';
import 'package:project_ultra/utils/text_home.dart';
import 'package:project_ultra/widgets/SizedBox.dart';
import 'package:project_ultra/widgets/progressdialoge.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dateControllerFrom = TextEditingController();
  final dateControllerTo = TextEditingController();
  final GlobalKey<FormState> _dialogeKey = GlobalKey<FormState>();
  List<ChartData> chartData = [];
  bool isSalesLoad = false;
  bool isPurchaseLoad = false;
  bool isPdcLoad = false;
  List<CheckListResponse> reportPdcData = [];
  String status = "NOT CLEARED";
  String custid = "";
  double ttlamnt = 0.0;
  double totalAmount = 0.0;
  double salesTotalAmount = 0.0;
  List<CheckListResponse> pdcFiltered = [];
  List<Customer> customerList = <Customer>[];
  List<TotalReportResponse> salesData = [];
  List<TotalReportResponse> salesFiltered = [];
  String numberFormat = '';
  String companyCode = "";
  String appBarTitle = "";
  String _todaySalesAmount = "0.00";
  String _last7DaysSalesAmount = "0.00";
  String _last30DaysSalesAmount = "0.00";
  String _todayPurchaseAmount = "0.00";
  String _last7DaysPurchaseAmount = "0.00";
  String _last30DaysPurchaseAmount = "0.00";
  String? selectedDate;
  String? selectedSale;
  bool isChartTapped = false;


  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.lightWhite1,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBoxSection(height: height/9.88, width: 0),
                  graphSection(),
                  SizedBoxSection(height: height/138.4, width: 0),
                  salesSummary(),
                  SizedBoxSection(height: height/138.4, width: 0),
                  purchaseSummary(),
                  SizedBoxSection(height: height/138.4, width: 0),
                  pdcReport(),
                  SizedBoxSection(height: height/138.4, width: 0),
                ],
              ),
            ),
          ),
          Positioned(
            top: height/34.6,
            left: 0,
            right: 0,
            child: HeaderSection(),
          ),
        ],
      ),
    );
  }

  Widget HeaderSection() {
    double height= MediaQuery.of(context).size.height;
  double width= MediaQuery.of(context).size.width;
    return Container(
      color: CustomColors.lightWhite1,
      width: double.infinity,
      //padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dropdown button
              Expanded(
                child: Container(

                  padding: EdgeInsets.symmetric(horizontal: height/69.2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Dropdown text
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true, // Prevents overflow
                            value: companyCode,
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.black,
                            ),
                            dropdownColor: CustomColors.lightWhite1,
                            items: <String>[companyCode]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  overflow: TextOverflow
                                      .ellipsis, // Prevents text overflow
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                companyCode = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spacer to separate the dropdown from the 3-dot menu
              SizedBox(width: width/36),
              // Three-dot menu button
              PopupMenuButton<String> (
                onSelected: (value) async {
                  if (value == 'logout') {
                    await Preference.setBool("isLogin", false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Log Out'),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget graphSection() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
        width: MediaQuery.of(context).size.width / 0.96,
       // height: MediaQuery.of(context).size.height / 2.1,
      height: height/2,
      padding:  EdgeInsets.symmetric(horizontal: height/346,vertical: width/24),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [CustomColors.lightWhite, CustomColors.lightWhite1],
              begin: Alignment(-1.0, 0.0),
              end: Alignment(1.0, 0.0),
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                  color: CustomColors.lightWhite,
                  spreadRadius: 1,
                  blurRadius: 3)
            ]),
        child: Column(children: [
          SizedBoxSection(height: 0, width: 0),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                    flex: 3,
                    child: SizedBox(
                        height: height/19.77,
                        child: TextField(
                            controller: dateControllerFrom,
                            //editing controller of this TextField
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0),
                              labelText: "From Date",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                            // when true user cannot edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  //get today's date
                                  firstDate: DateTime(2000),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime.now());
                              if (pickedDate != null) {
                                print(pickedDate);
                                String formattedDate = DateFormat('dd MMM yyyy')
                                    .format(pickedDate);
                                print(formattedDate);
                                //You can format date as per your need

                                setState(() {
                                  dateControllerFrom.text =
                                      formattedDate; //set foratted date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            }
                            ),
                    ),
                ),
                SizedBoxSection(height: 0, width: 10),
                new Flexible(
                    flex: 3,
                    child: SizedBox(
                        height:height/19.77,
                        child: TextField(
                            controller: dateControllerTo,
                            //editing controller of this TextField
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0),
                              labelText: "To Date",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                            // when true user cannot edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  //get today's date
                                  firstDate: DateTime(2000),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime.now());
                              if (pickedDate != null) {
                                print(
                                    '****** TO DATE  ******* ${pickedDate}'); //get the picked date in the format => 2022-07-04 00:00:00.000
                                String formattedDate = DateFormat('dd MMM yyyy')
                                    .format(
                                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                print(
                                    '----------- TOOOOOO ${formattedDate}'); //formatted date output using intl package =>  2022-07-04
                                //You can format date as per your need

                                setState(() {
                                  dateControllerTo.text =
                                      formattedDate; //set foratted date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            }))),
                SizedBoxSection(height: 0, width: width/36),
                new Flexible(
                    child: RawMaterialButton(
                  onPressed: () {
                    getReport();
                    getSalesReport();
                    getPurchase();
                    getPdcReport(false);
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.search,
                    size: 25.0,
                  ),
                  padding: EdgeInsets.all(5.0),
                  shape: CircleBorder(),
                )),
                SizedBoxSection(height: 0, width: 5),
                new Flexible(
                  child: RawMaterialButton(
                    onPressed: () {
                      String formattedDateTo =
                          DateFormat('dd MMM yyyy').format(DateTime.now());
                      DateTime nowFiveDaysAgo =
                          DateTime.now().add(Duration(days: -31));
                      String formattedDateFrom =
                          DateFormat('dd MMM yyyy').format(nowFiveDaysAgo);
                      dateControllerFrom.text = formattedDateFrom;
                      dateControllerTo.text = formattedDateTo;
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.refresh,
                      size: 25.0,
                    ),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
          SfCartesianChart(
            title: ChartTitle(
              text: 'Sales Performance',
              textStyle: const TextStyle(
                fontSize: 14,
                //fontWeight: FontWeight,
              ),
            ),
            primaryXAxis:

            CategoryAxis(majorGridLines: const MajorGridLines(width: 0),
            autoScrollingMode: AutoScrollingMode.start,
            visibleMinimum: 0,
                desiredIntervals: 31,
                placeLabelsNearAxisLine: true,
                visibleMaximum: 5
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
                zoomMode: ZoomMode.x
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,

                ),
              ),
              numberFormat: NumberFormat('#,##0'),
              axisLine: AxisLine(width: 0),
            ),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true,
            header: "",
              format: 'Date: point.x\nSales: point.y',),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.sale,
                dataLabelSettings: DataLabelSettings(isVisible: false),
                color: Colors.green,
              ),
            ],
          ),


        ],
        ),
          );
  }

  Widget salesSummary() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal:height/69.2 , vertical: width/36),
      width: MediaQuery.of(context).size.width * 0.96,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [CustomColors.red1, CustomColors.red2],
          )),
      child: Column(children: [
        Row(
          children: [
            CustomTextField(
                size: 15,
                txt: "Sales Summary",
                colr: CustomColors.white,
                fontWeight: FontWeight.bold,
                font: "stsbold"),
            Spacer(),
            Row(children: [
              isSalesLoad == true
                  ? Container(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                      width: width/18,
                      height: height/34.6,
                    )
                  : SizedBox.shrink(),
              SizedBoxSection(height: 0, width: width/36),
              CustomTextField(
                  size: 15,
                  txt: "View All",
                  colr: CustomColors.white,
                  fontWeight: FontWeight.normal,
                  font: "stsregular")
            ]),
          ],
        ),
        DividerSec(thick: 0.9, from: 2, colr: Colors.white),
        Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: "  Today's Sales",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomTextField(
                size: 15,
                txt: _todaySalesAmount,
                colr: CustomColors.white,
                fontWeight: FontWeight.w700,
                font: "stsregular"),
          ],
        ),
        DividerSec(thick: 0.9, from: 2, colr: Colors.white),
        Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.calendar_month, color: Colors.white),
                  ),
                  TextSpan(
                      text: "  Last 7 days Sales",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomTextField(
                size: 15,
                txt: _last7DaysSalesAmount,
                colr: CustomColors.white,
                fontWeight: FontWeight.w700,
                font: "stsregular"),
          ],
        ),
        DividerSec(thick: 0.9, from: 2, colr: Colors.white),
        Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.receipt, color: Colors.white),
                  ),
                  TextSpan(
                      text: "  Total Sales",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomTextField(
                size: 15,
                txt: _last30DaysSalesAmount,
                colr: CustomColors.white,
                fontWeight: FontWeight.w700,
                font: "stsregular"),
          ],
        )
      ]),
    );
  }

  Widget purchaseSummary() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(

      padding:  EdgeInsets.symmetric(horizontal: height/69.2, vertical: width/36),
      width: MediaQuery.of(context).size.width * 0.96,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [CustomColors.brown1, CustomColors.brown2],
          )),
      child: Column(children: [
        Row(
          children: [
            CustomTextField(
                size: 15,
                txt: "Purchase Summary",
                colr: CustomColors.white,
                fontWeight: FontWeight.bold,
                font: "stsbold"),
            const Spacer(),
            Row(children: [
              isPurchaseLoad == true
                  ? Container(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                      width: 20,
                      height: 20,
                    )
                  : const SizedBox.shrink(),
              SizedBoxSection(height: 0, width: 10),
              CustomTextField(
                  size: 15,
                  txt: "View All",
                  colr: CustomColors.white,
                  fontWeight: FontWeight.normal,
                  font: "stsregular")
            ]),
          ],
        ),
        DividerSec(thick: 0.9, from: 2, colr: Colors.white),
        Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  TextSpan(
                      text: "  Today's Purchase",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomTextField(
                size: 15,
                txt: _todayPurchaseAmount,
                colr: CustomColors.white,
                fontWeight: FontWeight.w700,
                font: "stsregular"),
          ],
        ),
        DividerSec(thick: 0.9, from: 2, colr: Colors.white),
        Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                      child: Icon(Icons.calendar_month, color: Colors.white),
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(
                    text: "  Last 7 days Purchase",
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomTextField(
                size: 15,
                txt: _last7DaysPurchaseAmount,
                colr: CustomColors.white,
                fontWeight: FontWeight.w700,
                font: "stsregular"),
          ],
        ),
        DividerSec(thick: 0.9, from: 2, colr: Colors.white),
        Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                      child: Icon(Icons.receipt, color: Colors.white),
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(
                    text: "  Total Purchase",
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomTextField(
                size: 15,
                txt: _last30DaysPurchaseAmount,
                colr: CustomColors.white,
                fontWeight: FontWeight.w700,
                font: "stsregular"),
          ],
        )
      ]),
    );
  }

  Widget pdcReport() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: height/138.4, vertical: width/36),
      width: MediaQuery.of(context).size.width * 0.96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CustomColors.bluelight1, CustomColors.bluelight],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Ensure Row takes minimum space
            children: [
              CustomTextField(
                size: 15,
                txt: "Today's PDC report",
                colr: CustomColors.white,
                fontWeight: FontWeight.bold,
                font: " ",
              ),
              if (isPdcLoad)
                const SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              Spacer(),
              CustomTextField(
                size: 15,
                txt: "View All",
                colr: CustomColors.white,
                fontWeight: FontWeight.normal,
                font: " ",
              ),
            ],
          ),
          DividerSec(thick: 0.9, from: 2, colr: Colors.white),
          reportPdcData.isNotEmpty
              ? SizedBox(
                  height: height/3.46, // Fixed height
                  child: ListView.separated(
                    itemCount: reportPdcData.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white.withOpacity(0.5),
                      thickness: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      var pdcItem = reportPdcData[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  size: 14,
                                  txt: pdcItem.ledgerName ?? 'No Ledger Name',
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(fontSize: 16),
                                  colr: CustomColors.white,
                                  fontWeight: FontWeight.normal,
                                  font: "stsregular",
                                ),
                              ),
                              CustomTextField(
                                size: 14,
                                txt: "${pdcItem.amount}",
                                colr: CustomColors.white,
                                fontWeight: FontWeight.bold,
                                font: "stsbold",
                              ),
                            ],
                          ),
                          CustomTextField(
                            size: 14,
                            txt: "Cheque No: ${pdcItem.chequeNo ?? 'N/A'}",
                            colr: CustomColors.white,
                            fontWeight: FontWeight.normal,
                            font: "stsregular",
                            textAlign: TextAlign.start,

                            // style: TextStyle(fontSize: 5),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: CustomTextField(
                    size: 14,
                    txt: "No PDC report available.",
                    colr: CustomColors.white,
                    fontWeight: FontWeight.normal,
                    font: "stsregular",
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> getReport() async {
    chartData.clear();
    ProgressDialog.showLoadingDialog(context, _dialogeKey);
    try {
      String companyCode = Preference.getString("comapnyCode")!;
      DateFormat inputFormat = DateFormat('dd MMM yyyy');
      DateTime parsedDateFrom = inputFormat.parse(dateControllerFrom.text);
      DateTime parsedDateTo = inputFormat.parse(dateControllerTo.text);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFrom = formatter.format(parsedDateFrom);
      final String formattedTo = formatter.format(parsedDateTo);

      ReportRequest reportRequest = ReportRequest(
          CompanyCode: companyCode,
          FromDate: formattedFrom,
          Todate: formattedTo,
          IsMonthlySummary: false,
          IsWeeklySummary: false,
          IsDaySummary: true);
      APIService apiService = APIService();
      final result = await apiService.getChartReprort(reportRequest);

      if (result != null && result.status == true) {
        Navigator.of(context, rootNavigator: true).pop();
        if (result.reportList != null && result.reportList!.isNotEmpty) {
          for (var reportItem in result.reportList!) {
            if (reportItem.value != null && reportItem.netAmount != null) {
              DateFormat inputFormat = DateFormat('yyyy-MM-dd');

              DateTime parsedDateFrom = inputFormat.parse(reportItem.value!);

              String formattedDateFrom =
                  DateFormat('dd MMM').format(parsedDateFrom);
              String formattedDateTo =
                  DateFormat('dd MMM').format(parsedDateFrom);

              ChartData sales = ChartData(
                  dateTo: formattedDateTo,
                  date: formattedDateFrom,
                  sale: reportItem.netAmount!.toInt());
              print(
                  'Adding data: Date - ${formattedDateFrom}, Sale - ${reportItem.netAmount}, To Date - ${formattedDateTo}');
              chartData.add(sales);
              getPdcReport();
            } else {
              print('Error: reportItem.value or reportItem.netAmount is null');
            }
          }
          setState(() {});
        } else {
          noReport();
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        noReport();
      }
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
      noReport();
    }
  }

  void noReport() {
    DateFormat inputFormat = DateFormat('dd MMM yyyy');
    DateTime parsedDateTo = inputFormat.parse(dateControllerTo.text);

    for (int i = 0; i >= -6; i--) {
      DateTime nowFiveDaysAgo = parsedDateTo.add(Duration(days: i));
      String formattedDateFrom = DateFormat('dd MMM').format(nowFiveDaysAgo);
      String formattedDateTo = DateFormat('dd MMM').format(nowFiveDaysAgo);
      ChartData sales = ChartData(
        date: formattedDateFrom,
        dateTo: formattedDateTo,
        sale: 0,
      );
      chartData.add(sales);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    companyCode = Preference.getString("BranchesName")!;

    print('------- COMPANY ----------- ${companyCode}');

    dateControllerFrom.text = formattedDate;
    dateControllerTo.text = formattedDate;

    Future.delayed(Duration.zero, () {
      print('------- INIT SALES-----------');
      this.getSalesReport();
      print("------------>  total <-----------$ttlamnt");
    });

    Future.delayed(Duration.zero, () {
      print('---------- INIT PURCHASE-----------');
      this.getPurchase();
      print("------------>  ttlamnt <-----------$ttlamnt");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String formattedDateTo = DateFormat('dd MMM yyyy').format(DateTime.now());
      DateTime nowFiveDaysAgo = DateTime.now().add(Duration(days: -6));
      String formattedDateFrom =
          DateFormat('dd MMM yyyy').format(nowFiveDaysAgo);
      dateControllerTo.text = formattedDateTo;
      dateControllerFrom.text = formattedDateFrom;
      this.getReport();
      this.getPdcReport();
    });
  }

  void getPdcReport([bool islad = false]) async {
    reportPdcData.clear();
    pdcFiltered.clear();
    ProgressDialog.showLoadingDialog(context, _dialogeKey);
    try {
      String companyCode = Preference.getString("comapnyCode")!;
      DateFormat inputFormat = DateFormat('dd MMM yyyy');
      DateTime parsedDateFrom = inputFormat.parse(dateControllerFrom.text);
      DateTime parsedDateTo = inputFormat.parse(dateControllerTo.text);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFrom = formatter.format(parsedDateFrom);
      final String formattedTo = formatter.format(parsedDateTo);

      PDCReportRequest reportRequest = new PDCReportRequest(
          CompanyCode: companyCode,
          FromDate: formattedFrom,
          Todate: formattedTo,
          Status: status,
          isLoad: islad,
          CustomerName: custid);
      APIService apiService = new APIService();
      final result = await apiService.getPdcReprort(reportRequest);
      if (result != null && result.status == true) {
        Navigator.of(context, rootNavigator: true).pop();
        if (result.pdcList!.length > 0) {
          reportPdcData = result.pdcList!;
          pdcFiltered = reportPdcData;
          ttlamnt = reportPdcData
              .map((reportPdcData) => reportPdcData.amount)
              .fold(0, (prev, amount) => prev + amount);
          setState(() {});
        } else {
          ttlamnt = 0.0;
        }
      } else {
        ttlamnt = 0.0;
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (error) {
      print(error);
      ttlamnt = 0.0;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void getSalesReport() async {
    salesData.clear();
    salesFiltered.clear();
    ProgressDialog.showLoadingDialog(context, _dialogeKey);
    print('*****************Get Sales Report************');
    try {
      String companyCode = Preference.getString("comapnyCode")!;

      await Future.wait([
        getSalesForRange(
            companyCode, 's', DateTime.now(), DateTime.now(), 'Today Sales'),
        getSalesForRange(
            companyCode,
            's',
            DateTime.now().subtract(Duration(days: 6)),
            DateTime.now(),
            'Last 7 Days Sales'),
        getSalesForRange(
            companyCode,
            's',
            DateTime.now().subtract(Duration(days: 30)),
            DateTime.now(),
            'Last 30 Days Sales')
      ]);

      Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> getSalesForRange(String companyCode, String tpe,
      DateTime fromDate, DateTime toDate, String label) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFrom = formatter.format(fromDate);
      final String formattedTo = formatter.format(toDate);

      TotalReportRequest reportRequest = new TotalReportRequest(
          CompanyCode: companyCode,
          type: "s",
          FromDate: formattedFrom,
          Todate: formattedTo,
          DayWiseSummary: false,
          TotalSummary: false,
          CustomerWiseSummary: false,
          custId: custid,
          InvoiceNo: "");

      APIService apiService = new APIService();
      final result = await apiService.getSalesReprort(reportRequest);

      if (result != null && result.status == true) {
        if (result.salesList!.length > 0) {
          double totalAmount = result.salesList!
              .map((reportPdcData) => reportPdcData.netAmount)
              .fold(0, (prev, amount) => prev + amount);

          print("$label: $totalAmount");
          setState(() {
            if (label == 'Today Sales') {
              _todaySalesAmount = totalAmount.toStringAsFixed(2);
            } else if (label == 'Last 7 Days Sales') {
              _last7DaysSalesAmount = totalAmount.toStringAsFixed(2);
            } else if (label == 'Last 30 Days Sales') {
              _last30DaysSalesAmount = totalAmount.toStringAsFixed(2);
            }
          });
        } else {
          print("$label: 0.0 (No sales data)");
        }
      } else {
        print("$label: 0.0 (Failed to fetch data)");
      }
    } catch (error) {
      print("$label: Error occurred - $error");
    }
  }

  void getPurchase() async {
    salesData.clear();
    salesFiltered.clear();
    ProgressDialog.showLoadingDialog(context, _dialogeKey);
    print('*****************Get Purchase Summary************');
    try {
      String companyCode = Preference.getString("comapnyCode")!;

      await Future.wait([
        getPurchaseSummary(
            companyCode, 'p', DateTime.now(), DateTime.now(), 'Today Purchase'),
        getPurchaseSummary(
            companyCode,
            'p',
            DateTime.now().subtract(Duration(days: 6)),
            DateTime.now(),
            'Last 7 Days Purchase'),
        getPurchaseSummary(
            companyCode,
            'p',
            DateTime.now().subtract(Duration(days: 30)),
            DateTime.now(),
            'Last 30 Days Purchase')
      ]);

      Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> getPurchaseSummary(String companyCode, String tpe,
      DateTime fromDate, DateTime toDate, String label) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFrom = formatter.format(fromDate);
      final String formattedTo = formatter.format(toDate);

      TotalReportRequest reportRequest = new TotalReportRequest(
          CompanyCode: companyCode,
          type: "p",
          FromDate: formattedFrom,
          Todate: formattedTo,
          DayWiseSummary: false,
          TotalSummary: false,
          CustomerWiseSummary: false,
          custId: custid,
          InvoiceNo: "");

      APIService apiService = new APIService();
      final result = await apiService.getSalesReprort(reportRequest);

      if (result != null && result.status == true) {
        if (result.salesList!.length > 0) {
          double totalAmount = result.salesList!
              .map((reportPdcData) => reportPdcData.netAmount)
              .fold(0, (prev, amount) => prev + amount);

          print("$label: $totalAmount");
          setState(() {
            if (label == 'Today Purchase') {
              _todayPurchaseAmount = totalAmount.toStringAsFixed(2);
              print(
                  "---------------Today Purchase Amount-----------${_todayPurchaseAmount}");
            } else if (label == 'Last 7 Days Purchase') {
              _last7DaysPurchaseAmount = totalAmount.toStringAsFixed(2);
            } else if (label == 'Last 30 Days Purchase') {
              _last30DaysPurchaseAmount = totalAmount.toStringAsFixed(2);
            }
          });
        } else {
          print("$label: 0.0 (No purchase data)");
        }
      } else {
        print("$label: 0.0 (Failed to fetch data)");
      }
    } catch (error) {
      print("$label: Error occurred - $error");
    }
  }
}
