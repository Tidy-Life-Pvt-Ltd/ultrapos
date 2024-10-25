import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ultra/model/checklist.dart';
import 'package:project_ultra/model/customer.dart';
import 'package:project_ultra/model/status.dart';
import 'package:project_ultra/services/api.dart';
import 'package:project_ultra/utils/appbar.dart';
import 'package:project_ultra/utils/customcolor.dart';
import 'package:project_ultra/utils/shared_prefs.dart';
import 'package:project_ultra/utils/text_home.dart';
import 'package:project_ultra/widgets/buttonsection.dart';
import 'package:project_ultra/widgets/progressdialoge.dart';
import 'package:project_ultra/widgets/sizedbox.dart';

class PdcScreen extends StatefulWidget {
  const PdcScreen({super.key});

  @override
  State<PdcScreen> createState() => _PdcScreenState();
}

class _PdcScreenState extends State<PdcScreen> {
  final dateControllerFrom = TextEditingController();
  final dateControllerTo = TextEditingController();
  GlobalKey<FormState> _dialogeKey = GlobalKey<FormState>();
  List<Customer> customerList = <Customer>[];
  bool isLoading = false;
  Status statusResponse = Status(id: "NOT CLEARED", name: "Pending");
  List<Status> statusList = [];
  List<CheckListResponse> reportPdcData = [];
  String stats = "NOT CLEARED";
  String custid = "";
  double ttlamnt = 0.0;
  List<CheckListResponse> pdcFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusList = [
      Status(id: "NOT CLEARED", name: "Pending"),
      Status(id: "CLEARED", name: "Cleared"),
      Status(id: "", name: "All"),
    ];
    statusResponse = statusList.first;
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    dateControllerFrom.text = formattedDate;
    dateControllerTo.text = formattedDate;
    Future.delayed(Duration.zero, () {
      this.getPdcReport(true);
    });
  }

  void getPdcReport(bool islad) async {
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
          Status: stats,
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PDC', // Pass the title as a parameter
      ),
      body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: [
                  searchSection(),
                  report(),
                  SizedBoxSection(height: height/138.4, width: 0),
                ],
              ),
            ),
          )),
    );
  }

  Widget report() {
    double height = MediaQuery.of(context).size.height;
    return Flexible(
        child: Container(
            width: double.infinity,
            height: height / 1.71,
            //height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: height/138.4),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: CustomColors.white,
                elevation: 10,
                child: Column(
                  children: [
                    Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                            controller: controller,
                            decoration: new InputDecoration(
                                hintText: 'Search', border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                _searchResult = value;
                                pdcFiltered = reportPdcData
                                    .where((user) => user.ledgerName
                                        .toUpperCase()
                                        .contains(_searchResult)!!)
                                    .toList();
                              });
                            }),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              _searchResult = '';
                              pdcFiltered = reportPdcData;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.black),
                                  child: DataTable(
                                    columnSpacing: 0,
                                    horizontalMargin: 0,
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => CustomColors.blue1),
                                    columns: const [
                                      DataColumn(
                                          label: Expanded(
                                              child: Text(
                                        'Sl No',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                        textAlign: TextAlign.center,
                                      ))),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Ledger Name',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Amount',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Slip No',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Bank Name',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Cheque No',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Cheque Date',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Age(Days)',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Status',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Trans Date',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Expanded(
                                              child: Text(
                                        'Trans Type',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      ))),
                                    ],
                                    rows: List.generate(
                                        pdcFiltered.length,
                                        (index) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .1, //SET width
                                                    child: Text((index + 1)
                                                        .toString()))),
                                                //add name of your columns here
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(pdcFiltered[index]
                                                    .ledgerName)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(pdcFiltered[index]
                                                    .amount
                                                    .toString())),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(
                                                    pdcFiltered[index].slipNo)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(pdcFiltered[index]
                                                    .bankName)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(pdcFiltered[index]
                                                    .chequeNo)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(pdcFiltered[index]
                                                    .cheqDate)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        pdcFiltered[index]
                                                            .ages
                                                            .toString()))),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(
                                                    pdcFiltered[index].status)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Text(pdcFiltered[index]
                                                    .transDate)),
                                                const DataCell(
                                                    VerticalDivider()),

                                                DataCell(Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .5, //SET width
                                                    child: Text(
                                                        pdcFiltered[index]
                                                            .transType))),
                                              ],
                                            )),
                                  )),
                            ))),
                    pdcFiltered.length > 0
                        ? const SizedBox.shrink()
                        : Flexible(
                            child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: CustomTextField(
                                    size: 12,
                                    txt: "No data",
                                    colr: CustomColors.hintColor,
                                    fontWeight: FontWeight.w400,
                                    font: "stsregular"))),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: height/17.3,
                      color: CustomColors.blue1,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: height/69.2),
                      child: CustomTextField(
                          size: 15,
                          txt: "Total Amount: " + ttlamnt.toString(),
                          colr: CustomColors.white,
                          fontWeight: FontWeight.bold,
                          font: "stsbold"),
                    )
                  ],
                ))));
  }

  Widget searchSection() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: height/4.613,
      padding:  EdgeInsets.symmetric(horizontal: height/138.4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: CustomColors.white,
        elevation: 10,
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    CustomTextField(
                        size: 15,
                        txt: "Search",
                        colr: CustomColors.blue1,
                        fontWeight: FontWeight.w500,
                        font: "stsregular"),
                    const Spacer(),
                    ButtonSection(
                        height: height/23.7,
                        width: MediaQuery.of(context).size.width / 3.2,
                        brdRadius: BorderRadius.circular(20),
                        thick: 2,
                        txt: "Search",
                        txtColr: CustomColors.white,
                        fontFamily: "stslight",
                        btAction: () {
                          getPdcReport(false);
                        }),
                  ],
                ),
                SizedBoxSection(height: height/69.2, width: 0),
                Row(
                  children: [
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
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 300)),
                                  );
                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                    String formattedDate =
                                        DateFormat('dd MMM yyyy').format(
                                            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2022-07-04
                                    //You can format date as per your need

                                    setState(() {
                                      dateControllerFrom.text =
                                          formattedDate; //set foratted date to TextField value.
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                }))),
                    SizedBoxSection(height: 0, width: width/36),
                    new Flexible(
                        flex: 3,
                        child: SizedBox(
                            height: height/19.77,
                            child: TextField(
                                controller: dateControllerTo,
                                //editing controller of this TextField
                                decoration: const InputDecoration(
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
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 300)));
                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                    String formattedDate =
                                        DateFormat('dd MMM yyyy').format(
                                            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2022-07-04
                                    //You can format date as per your need

                                    setState(() {
                                      dateControllerTo.text =
                                          formattedDate; //set foratted date to TextField value.
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                }))),
                  ],
                ),
                SizedBoxSection(height: height/69.2, width: 0),
                Row(
                  children: [
                    new Flexible(
                        flex: 3,
                        child: SizedBox(
                          height: height/19.77,
                          child: statusWidget(),
                        )),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget statusWidget() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: CustomColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: CustomColors.hintColor),
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<Status>(
              isExpanded: true,
              value: statusResponse ?? statusList.first,
              items: statusList.map((Status status) {
                print("---------- SELECTED VALUE");
                return DropdownMenuItem(
                  value: status,
                  child:
                      Text(status.name, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (Status? value) {
                setState(() {
                  statusResponse = value!;
                  stats = value.id;
                  pdcFiltered = reportPdcData
                      .where((user) => user.status == stats)
                      .toList();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  /* Widget autoCompleteWidget() {
    return Autocomplete<Customer>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        print(textEditingValue.text);
        if (isLoading == false)
          return getCustomer(textEditingValue.text);
        else
          return customerList;
      },
      displayStringForOption: (Customer option) => option.custName,
   */ /*   fieldViewBuilder: (BuildContext context,
          //TextEditingController fieldTextEditingController,
          //FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            labelText: "Search Customer",
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          style: const TextStyle(),
        );
      },*/ /*
      onSelected: (Customer selection) {
        custid = selection.custID;
        print('Selected: ${selection.custName}');
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Customer> onSelected,
          Iterable<Customer> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: CustomColors.white,
              elevation: 10,
              child: ListView.builder(
                padding: const EdgeInsets.all(2.0),
                itemCount: options.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final Customer option = options.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(option.custName,
                          style: const TextStyle(
                              color: CustomColors.blue1, fontSize: 13)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<Customer>> getCustomer(String customerName) async {
    customerList.clear();
    custid="";
    if (customerName != null && customerName != "") {
      isLoading = true;
      ProgressDialog.showLoadingDialog(context, _dialogeKey);
      try {
        APIService apiService = new APIService();
        String companyCode = Preference.getString("comapnyCode")!;
        final result = await apiService.getCustomer(customerName, companyCode,"");
        if (result != null && result.status == true) {
          if (result.customerList != null && result.customerList!.length > 0) {
            Navigator.of(context, rootNavigator: true).pop();
            customerList = result.customerList!;
            isLoading = false;
            return customerList;
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
            return customerList;
          }
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          isLoading = false;
          return customerList;
        }
      } catch (error) {
        Navigator.of(context, rootNavigator: true).pop();
        isLoading = false;
        print(error);
        return customerList;
      }
    } else {
      isLoading = false;
      return customerList;
    }
  }*/
}
