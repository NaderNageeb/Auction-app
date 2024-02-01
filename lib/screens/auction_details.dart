// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_single_cascade_in_expression_statements, non_constant_identifier_names, prefer_interpolation_to_compose_strings, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, unnecessary_this, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_adjacent_string_concatenation

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_auction_app/services/progressHUD.dart';
import 'package:new_auction_app/services/api_service.dart';
import '../components/ui_assets.dart';

class AuctionDetailsState extends StatefulWidget {
  String AUC_ID;
  AuctionDetailsState(this.AUC_ID);

  @override
  State<StatefulWidget> createState() {
    return AuctionDetails(AUC_ID: AUC_ID.toString());
  }
}

class AuctionDetails extends State<AuctionDetailsState> {
  var AUC_ID;
  Crud crud = Crud();
  AuctionDetails({required this.AUC_ID});

  bool isApiCallProcess = false;
  String _user_id_sp = "";
  String _user_name_sp = "";
  APIService apiServices = APIService();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _addFormKey = GlobalKey<FormState>();
  bool processing = false;

  String item_id = "";
  String auctionImg = "";
  String lastAuctionPrice = "";

  final aucIdCON = TextEditingController();
  final aucNameCON = TextEditingController();
  final aucItemNameCON = TextEditingController();
  final aucDescCON = TextEditingController();
  final aucPriceCON = TextEditingController();
  final aucEndDateCON = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiServices.getIDPreference().then(updateID);
    apiServices.getNamePreference().then(updateName);
    get_Auction_Details_Info(AUC_ID.toString());
    getLastaucPrice(AUC_ID.toString());
  }

  void updateID(String user_id_sp) {
    setState(() {
      this._user_id_sp = user_id_sp;
      print('User ID From SP : ' + _user_id_sp.toString());
    });
  }

  void updateName(String user_id_sp) {
    setState(() {
      this._user_name_sp = user_id_sp;
      print('User Name From SP : ' + _user_name_sp.toString());
    });
  }

  getLastaucPrice(String auc_id) async {
    // var url = "http://192.168.43.63/auction_admin/include/API/index.php";

    var lastaucpriceresponce =
        await crud.postRequests(APIService.url + '?GetLastAuctionPrice', {
      "auc_id": auc_id.toString(),
    });
    lastAuctionPrice = lastaucpriceresponce['data'][0]['c'];
    return lastaucpriceresponce;
  }

  Future<bool> get_Auction_Details_Info(String auc_id) async {
    bool listValue = false;

    String auctionName,
        auctionItemName,
        auctionPrice,
        auctionDesc,
        auctionEndDate;
    String auctionStatus;
    // new 1/17/2024
    String lastAuctionprice;

    final list = await apiServices.getAuctionItemsData(auc_id.toString());

    print('My Auction LIST : ' +
        '${list[0].auc_name} \n ${list[0].auc_desc} \n${list[0].auc_price} \n ');

    item_id = list[0].item_id;
    auctionName = list[0].auc_name;
    auctionItemName = list[0].item_name;
    auctionPrice = list[0].auc_price;
    auctionDesc = list[0].auc_desc;
    auctionEndDate = list[0].auc_end_date;
    auctionImg = list[0].item_img;
    auctionStatus = list[0].auc_status;

    setState(() {
      aucNameCON..text = auctionName.toString();
      aucItemNameCON..text = auctionItemName.toString();
      aucDescCON..text = auctionDesc.toString();
      aucPriceCON..text = auctionPrice.toString();
      aucEndDateCON..text = auctionEndDate.toString();
    });

    return listValue;
  }
  // nader

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Auction Details"),
          centerTitle: false,
        ),
        key: scaffoldKey,
        backgroundColor: Colors.green,
        body: Form(
          key: _addFormKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(0.0),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: 500,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.0),
                            child: Text('Acution item Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.green)),
                          ),
                          Icon(Icons.wb_sunny, color: Colors.transparent),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: false,
                              controller: aucNameCON,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Auction Name',
                                hintText: "Auction Name",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: false,
                              controller: aucItemNameCON,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Item Name',
                                hintText: "Item Name",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: false,
                              controller: aucDescCON,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: "Description",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: false,
                              controller: aucPriceCON,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                hintText: "Price",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: false,
                              controller: aucEndDateCON,
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                hintText: "End Date",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Text('Item Image : ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        child: Image.network(
                            apiServices.Items_Img_url + auctionImg.toString(),
                            fit: BoxFit.cover),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Last Auction Price is  ' + lastAuctionPrice.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10.0,
                        child: Center(
                          child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: 1.0, end: 1.0),
                            height: 1.0,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      fixedSize: Size.fromWidth(140),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                    ),
                                    child: const Text("Make Auction",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () async {
                                      if (_addFormKey.currentState!
                                          .validate()) {
                                        _addFormKey.currentState!.save();
                                        apiServices
                                            .checkInternetConnnection()
                                            .then((intenet) async {
                                          if (intenet != null && intenet) {
                                            _auctionConfirmDialog(
                                                context,
                                                AUC_ID.toString(),
                                                aucPriceCON.text.toString());
                                          } else {
                                            setState(() {
                                              Alert_Dialog(
                                                  context,
                                                  "No Connection",
                                                  "Make sure you have internet connection and try again !");
                                            });
                                          }
                                        });
                                      }
                                    }),
                                SizedBox(width: 5),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      fixedSize: Size.fromWidth(140),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                    ),
                                    child: const Text("Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController yourPriceCON = TextEditingController();

  Future<void> _auctionConfirmDialog(
      BuildContext context, String auc_id, String item_price) async {
    var item_price_double = double.parse(item_price);
    var my_price_double;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Item Price : ' + item_price.toString() + ".SDG"),
          content: TextFormField(
            controller: yourPriceCON,
            decoration: InputDecoration(
              labelText: 'Your Price : ',
              hintText: "Your Price : ",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2))),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: Size.fromWidth(140),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: const Text("Confirm",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () async {
                  my_price_double = double.parse(yourPriceCON.text.toString());

                  apiServices.checkInternetConnnection().then((intenet) async {
                    if (intenet != null && intenet) {
                      if (my_price_double < item_price_double) {
                        print("Item Price" + item_price_double.toString());
                        print("My Price" + my_price_double.toString());

                        Alert_Dialog(context, "Low Price",
                            "Your Price is less than auction item price !");
                      } else {
                        apiServices.OrderAuctionApi(
                            context,
                            auc_id.toString(),
                            _user_id_sp.toString(),
                            yourPriceCON.text.toString());
                        Navigator.popAndPushNamed(context, '/home');
                      }
                    } else {
                      setState(() {
                        Alert_Dialog(context, "No Connection",
                            "Make sure you have internet connection and try again !");
                      });
                    }
                  });
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size.fromWidth(140),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: const Text("Cancel",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () async {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
