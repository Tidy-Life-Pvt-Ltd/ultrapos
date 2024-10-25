import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ultra/utils/appbar.dart';
import 'package:project_ultra/utils/customcolor.dart';

import '../model/pos.dart';
import '../services/api.dart';
import '../utils/shared_prefs.dart';
import '../utils/text_home.dart';
import '../widgets/buttonsection.dart';
import '../widgets/progressdialoge.dart';
import '../widgets/sizedbox.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final dateControllerFrom = TextEditingController();
  final dateControllerTo = TextEditingController();
  GlobalKey<FormState> _dialogeKey = GlobalKey<FormState>();
  List<PosResponse> reportPosData = [];
  double ttlamnt = 0.0;
  int ttlCount = 0;
  List<PosResponse> posFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    dateControllerFrom.text = formattedDate;
    dateControllerTo.text = formattedDate;
    Future.delayed(Duration.zero, () {
      this.getPosReport();
    });
  }

  void getPosReport() async {
    reportPosData.clear();
    posFiltered.clear();
    ProgressDialog.showLoadingDialog(context, _dialogeKey);
    try {
      String companyCode = Preference.getString("comapnyCode")!;
      DateFormat inputFormat = DateFormat('dd MMM yyyy');
      DateTime parsedDateFrom = inputFormat.parse(dateControllerFrom.text);
      DateTime parsedDateTo = inputFormat.parse(dateControllerTo.text);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFrom = formatter.format(parsedDateFrom);
      final String formattedTo = formatter.format(parsedDateTo);

      APIService apiService = new APIService();
      final result = await apiService.getPosReprort(
          companyCode, formattedFrom, formattedTo);
      if (result != null && result.status == true) {
        Navigator.of(context, rootNavigator: true).pop();
        if (result.posList!.isNotEmpty) {
          reportPosData = result.posList!;
          posFiltered = reportPosData;
          ttlamnt = reportPosData
              .map((reportPdcData) => reportPdcData.netAmount)
              .fold(0, (prev, amount) => prev + amount);
          ttlCount = reportPosData
              .map((reportPdcData) => reportPdcData.totalcount)
              .fold(0, (prev, amount) => prev + amount);
          ;

          setState(() {});
        } else {
          ttlamnt = 0.0;
          ttlCount = 0;
        }
      } else {
        ttlamnt = 0.0;
        ttlCount = 0;

        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (error) {
      print(error);
      ttlamnt = 0.0;
      ttlCount = 0;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'POS', // Pass the title as a parameter
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
              SizedBoxSection(height: height/138.4, width: 0),
              report()
            ],
          ),
        ),
      )),
    );
  }

  Widget searchSection() {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: height/6.29,
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
                        width: MediaQuery.of(context).size.width / 3.0,
                        brdRadius: BorderRadius.circular(20),
                        thick: 2,
                        txt: "Search",
                        txtColr: CustomColors.white,
                        fontFamily: "stslight",
                        btAction: () {
                          getPosReport();
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
                                      dateControllerFrom.text = formattedDate;
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
            height: height/1.60,
          //  height: MediaQuery.of(context).size.height,
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
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: TextField(
                            // controller: controller,
                            decoration: const InputDecoration(
                                hintText: 'Search', border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                _searchResult = value;
                                posFiltered = reportPosData
                                    .where((user) =>
                                user.pos.contains(_searchResult)!!)
                                    .toList();
                              });
                            }),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              _searchResult = '';
                              posFiltered = reportPosData;
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
                                        'POS',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Date',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Count',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Total',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'VAT',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                      DataColumn(
                                          label: VerticalDivider(
                                        color: CustomColors.hintColor,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Net Amount',
                                        style: TextStyle(
                                            color: CustomColors.white),
                                      )),
                                    ],
                                    rows: List.generate(
                                        posFiltered.length,
                                        // posFiltered.length,
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
                                                DataCell(VerticalDivider()),

                                                DataCell(Text(
                                                    posFiltered[index].pos)),
                                                DataCell(VerticalDivider()),

                                                DataCell(Text(posFiltered[index]
                                                    .transDate
                                                    .toString())),
                                                DataCell(VerticalDivider()),

                                                DataCell(Text(posFiltered[index]
                                                    .totalcount
                                                    .toString())),
                                                DataCell(VerticalDivider()),

                                                DataCell(Text(posFiltered[index]
                                                    .totalAmount
                                                    .toString())),
                                                DataCell(VerticalDivider()),

                                                DataCell(Text(posFiltered[index]
                                                    .totalVAT
                                                    .toString())),
                                                DataCell(VerticalDivider()),

                                                DataCell(Text(posFiltered[index]
                                                    .netAmount
                                                    .toString())),
                                              ],
                                            )),
                                  )),
                            ))),
                    posFiltered.length > 0
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
                      padding:  EdgeInsets.symmetric(horizontal: height/69.2),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              size: 15,
                              txt: "Total Count: $ttlCount",
                              colr: CustomColors.white,
                              fontWeight: FontWeight.bold,
                              font: "stsbold",
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: CustomTextField(
                              size: 15,
                              txt: "Total Amount: $ttlamnt",
                              colr: CustomColors.white,
                              fontWeight: FontWeight.bold,
                              font: "stsbold",
                            ),
                          ),
                        ],
                      ),
                    )
                    /* Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: CustomColors.blue1,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child:Row(
                          children: [
                            CustomTextField(
                                size: 15,
                                txt: "Total Count: $ttlCount" ,
                                colr: CustomColors.white,
                                fontWeight: FontWeight.bold,
                                font: "stsbold"),
                            Spacer(),

                            CustomTextField(
                                size: 15,
                                txt: "Total Amount: $ttlamnt " ,
                                colr: CustomColors.white,
                                fontWeight: FontWeight.bold,
                                font: "stsbold"),
                          ],
                        )
                    )*/
                  ],
                ))));
  }
}
