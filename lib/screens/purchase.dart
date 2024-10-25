import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ultra/model/customer.dart';
import 'package:project_ultra/model/reportresponse.dart';
import 'package:project_ultra/services/api.dart';
import 'package:project_ultra/utils/appbar.dart';
import 'package:project_ultra/utils/customcolor.dart';
import 'package:project_ultra/utils/shared_prefs.dart';
import 'package:project_ultra/widgets/progressdialoge.dart';

import '../utils/text_home.dart';
import '../widgets/buttonsection.dart';
import '../widgets/sizedbox.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final dateControllerFrom = TextEditingController();
  final dateControllerTo = TextEditingController();
  GlobalKey<FormState> _dialogeKey = GlobalKey<FormState>();
  List<Customer> customerList = <Customer>[];
  bool isLoading = false;
  List<TotalReportResponse> salesData = [];
  String stats = "NOT CLEARED";
  String custid = "";
  double ttlamnt = 0.0;
  List<TotalReportResponse> salesFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  String appTitle = 'Purchase';
  String numberFormat = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    dateControllerFrom.text = formattedDate;
    dateControllerTo.text = formattedDate;
    Future.delayed(Duration.zero, () {
      this.getSalesReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: appTitle,
      ),
      body: SizedBox(
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
      ),
    );
  }

  Widget searchSection() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: height/4.32,
      padding: EdgeInsets.symmetric(horizontal: height/138.4),
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
                    Spacer(),
                    ButtonSection(
                        height: height/23.06,
                        width: MediaQuery.of(context).size.width / 2.5,
                        brdRadius: BorderRadius.circular(20),
                        thick: 2,
                        txt: "Search",
                        txtColr: CustomColors.white,
                        fontFamily: "stslight",
                        btAction: () {
                          getSalesReport();
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
                                decoration: InputDecoration(
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
                                    lastDate:
                                        DateTime.now().add(Duration(days: 300)),
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
                    SizedBoxSection(height: 0, width: 10),
                    new Flexible(
                        flex: 3,
                        child: SizedBox(
                            height: height/19.77,
                            child: TextField(
                                controller: dateControllerTo,
                                //editing controller of this TextField
                                decoration: InputDecoration(
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
                                          .add(Duration(days: 300)));
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
                new Flexible(
                    flex: 3,
                    child: SizedBox(
                      height: height/19.77,
                      child: autoCompleteWidget(),
                    )),
                SizedBoxSection(height: 0, width: width/36),
              ],
            )),
      ),
    );
  }

  Widget report() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Flexible(
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding:  EdgeInsets.symmetric(horizontal: height/138.4),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: CustomColors.white,
                elevation: 10,
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                hintText: 'Search', border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                _searchResult = value;
                                salesFiltered = salesData
                                    .where((user) =>
                                        user.invoiceId.contains(_searchResult))
                                    .toList();
                              });
                            }),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              _searchResult = '';
                              salesFiltered = salesData;
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
                              columnSpacing: 10, // Add spacing between columns
                              horizontalMargin: 10, // Add margin to cells
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => CustomColors.blue1),
                              columns: [
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Sl No',
                                      style:
                                          TextStyle(color: CustomColors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                    label: VerticalDivider(
                                  color: CustomColors.hintColor,
                                )),
                                DataColumn(
                                  label: Text(
                                    'Inv No',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                ),
                                DataColumn(
                                    label: VerticalDivider(
                                  color: CustomColors.hintColor,
                                )),
                                DataColumn(
                                  label: Text(
                                    'Date',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                ),
                                DataColumn(
                                    label: VerticalDivider(
                                  color: CustomColors.hintColor,
                                )),
                                DataColumn(
                                  label: Text(
                                    'Type',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                ),
                                DataColumn(
                                    label: VerticalDivider(
                                  color: CustomColors.hintColor,
                                )),
                                DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                ),
                                DataColumn(
                                    label: VerticalDivider(
                                  color: CustomColors.hintColor,
                                )),
                                DataColumn(
                                  label: Text(
                                    'VAT',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                ),
                                DataColumn(
                                    label: VerticalDivider(
                                  color: CustomColors.hintColor,
                                )),
                                DataColumn(
                                  label: Text(
                                    'Net Amount',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                salesFiltered.length,
                                (index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1, // Set width
                                        child: Text((index + 1).toString()))),
                                    DataCell(VerticalDivider()),
                                    DataCell(
                                        Text(salesFiltered[index].invoiceId)),
                                    DataCell(VerticalDivider()),
                                    DataCell(Text(salesFiltered[index]
                                        .salesDate
                                        .toString())),
                                    DataCell(VerticalDivider()),
                                    DataCell(
                                        Text(salesFiltered[index].salesTpe)),
                                    DataCell(VerticalDivider()),
                                    DataCell(Text(salesFiltered[index]
                                        .totalAmount
                                        .toStringAsFixed(2))),
                                    DataCell(VerticalDivider()),
                                    DataCell(Text(salesFiltered[index]
                                        .vatAmount
                                        .toString())),
                                    DataCell(VerticalDivider()),
                                    DataCell(Text(salesFiltered[index]
                                        .netAmount
                                        .toString())),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    salesFiltered.length > 0
                        ? SizedBox.shrink()
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
                      height: 40,
                      color: CustomColors.blue1,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextField(
                          size: 15,
                          txt: "Total Amount: " + ttlamnt.toStringAsFixed(2),
                          colr: CustomColors.white,
                          fontWeight: FontWeight.bold,
                          font: "stsbold"),
                    )
                  ],
                ))));
  }

  Widget autoCompleteWidget() {
    return Autocomplete<Customer>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        print(textEditingValue.text);
        if (isLoading == false)
          return getCustomer(textEditingValue.text);
        else
          return customerList;
      },
      displayStringForOption: (Customer option) => option.custName,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            labelText: (Preference.getString("type") == "s" ||
                    Preference.getString("type") == "sr")
                ? "Search Customer"
                : "Search Supplier",
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          style: const TextStyle(),
        );
      },
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
                padding: EdgeInsets.all(2.0),
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
                      visualDensity: VisualDensity(vertical: -4),
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
    custid = "";
    if (customerName != null && customerName != "") {
      isLoading = true;
      ProgressDialog.showLoadingDialog(context, _dialogeKey);
      try {
        APIService apiService = new APIService();
        String companyCode = Preference.getString("comapnyCode")!;
        String tpe = Preference.getString("searchParam")!;

        final result =
            await apiService.getCustomer(customerName, companyCode, tpe);
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
  }

  void getSalesReport() async {
    salesData.clear();
    salesFiltered.clear();
    ProgressDialog.showLoadingDialog(context, _dialogeKey);
    try {
      String companyCode = Preference.getString("comapnyCode").toString();
      String tpe = Preference.getString("type").toString();

      setState(() {
        if (tpe == "p") {
          appTitle = "Purchase";
        } else if (tpe == "pr") {
          appTitle = "Purchase Return";
        }
      });
      DateFormat inputFormat = DateFormat('dd MMM yyyy');
      DateTime parsedDateFrom = inputFormat.parse(dateControllerFrom.text);
      DateTime parsedDateTo = inputFormat.parse(dateControllerTo.text);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFrom = formatter.format(parsedDateFrom);
      final String formattedTo = formatter.format(parsedDateTo);

      TotalReportRequest reportRequest = new TotalReportRequest(
          CompanyCode: companyCode,
          type: tpe,
          FromDate: formattedFrom,
          Todate: formattedTo,
          DayWiseSummary: false,
          TotalSummary: false,
          CustomerWiseSummary: false,
          custId: custid,
          InvoiceNo: "");
      APIService apiService = APIService();
      final result = await apiService.getSalesReprort(reportRequest);
      if (result != null && result.status == true) {
        Navigator.of(context, rootNavigator: true).pop();
        if (result.salesList!.length > 0) {
          salesData = result.salesList!;
          salesFiltered = salesData;
          ttlamnt = salesData
              .map((reportPdcData) => reportPdcData.netAmount)
              .fold(0, (prev, amount) => prev + amount);

          ttlamnt = double.parse(ttlamnt.toStringAsFixed(2));
          String formattedAmount = NumberFormat('#,##0.00').format(ttlamnt);

          numberFormat = formattedAmount;
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
}
