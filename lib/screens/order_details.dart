// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, no_logic_in_create_state, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, unnecessary_this, unused_local_variable, avoid_print, prefer_adjacent_string_concatenation, avoid_single_cascade_in_expression_statements, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_auction_app/services/progressHUD.dart';
import 'package:new_auction_app/services/api_service.dart';
import '../components/ui_assets.dart';

class OrderDetailsState extends StatefulWidget {

  String ORDERD_ID;
  OrderDetailsState(this.ORDERD_ID);

  @override
  State<StatefulWidget> createState() {
    return OrderDetails(ORDERD_ID: ORDERD_ID.toString());
  }
}

class OrderDetails extends State<OrderDetailsState> {

  var ORDERD_ID;

  OrderDetails({  required this.ORDERD_ID}) ;

  bool isApiCallProcess = false;
  String _user_id_sp = "" ;
  String _user_name_sp = "" ;
  APIService apiServices = APIService();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _addFormKey = GlobalKey<FormState>();
  bool processing = false;

  String item_id = "";
  String auctionImg = "";
  String order_Status_text = "";

  final aucIdCON = TextEditingController();
  final aucNameCON = TextEditingController();
  final aucItemNameCON = TextEditingController();
  final aucDescCON = TextEditingController();
  final aucPriceCON = TextEditingController();
  final aucEndDateCON = TextEditingController();

  final orderPriceCON = TextEditingController();
  final orderStatusCON = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiServices.getIDPreference().then(updateID);
    apiServices.getNamePreference().then(updateName);
    get_Order_Details_Info();
  }

  void updateID(String user_id_sp){
    setState(() {
      this._user_id_sp = user_id_sp ;
      print('User ID From SP : '+ _user_id_sp.toString());
    });
  }
  void updateName(String user_id_sp){
    setState(() {
      this._user_name_sp = user_id_sp ;
      print('User Name From SP : '+ _user_name_sp.toString());
    });
  }

  Future<bool> get_Order_Details_Info() async {

    bool listValue = false ;

    String  auctionName ,auctionItemName,auctionPrice ,auctionDesc  ,auctionEndDate ;
    String  auctionStatus ;
    String orderStatus , orderPrice ;

    final list = await apiServices.getOrdersByID(ORDERD_ID.toString());


    print('My Auction LIST : '+'${list[0].auc_name} \n ${list[0].auc_desc} \n${list[0].auc_price} \n');

    item_id = list[0].item_id  ;
    auctionName = list[0].auc_name  ;
    auctionItemName = list[0].item_name  ;
    auctionPrice = list[0].auc_price  ;
    auctionDesc = list[0].auc_desc  ;
    auctionEndDate = list[0].auc_end_date  ;
    auctionImg = list[0].item_img  ;
    auctionStatus = list[0].auc_status  ;

    orderStatus = list[0].order_status  ;
    orderPrice = list[0].order_price  ;

      if(orderStatus.toString()=="0"){
        order_Status_text = "Pending" ;
      }
    if(orderStatus.toString()=="1"){
      order_Status_text = "Confirmed" ;
    }
    if(orderStatus.toString()=="2"){
      order_Status_text = "Rejected" ;
    }

    setState(() {

      aucNameCON..text = auctionName.toString() ;
      aucItemNameCON..text = auctionItemName.toString() ;
      aucDescCON..text = auctionDesc.toString() ;
      aucPriceCON..text = auctionPrice.toString() ;
      aucEndDateCON..text = auctionEndDate.toString() ;
      orderStatusCON..text = order_Status_text.toString();
      orderPriceCON..text = orderPrice.toString();

    });
    return  listValue ;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3, valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }
  Widget _uiSetup(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child : Scaffold(
        appBar: AppBar(
backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Order Details"),
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
                            child: Text('Order item Details',
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
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled:  false,
                              controller: aucDescCON,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              decoration:  InputDecoration(
                                labelText: 'Description',
                                hintText: "Description",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled:  false,
                              controller: aucPriceCON,
                              decoration:  InputDecoration(
                                labelText: 'Auction Price',
                                hintText: "Price",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled:  false,
                              controller: orderPriceCON,
                              decoration:  InputDecoration(
                                labelText: 'Your Price',
                                hintText: "Your Price",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled:  false,
                              controller: aucEndDateCON,
                              decoration:  InputDecoration(
                                labelText: 'End Date',
                                hintText: "End Date",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled:  false,
                              controller: orderStatusCON,
                              decoration:  InputDecoration(
                                labelText: 'Auction Status',
                                hintText: "Auction Status",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,) ,
                      SizedBox(
                        height: 10.0,
                        child: Center(
                          child: Container(
                            margin: EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
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

                                SizedBox(width: 5),
                                if(order_Status_text == "Pending")...[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      fixedSize: Size.fromWidth(140),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                    ),
                                    child: const Text("Delete Order" , style: TextStyle(color: Colors.white, )),
                                    onPressed: () async {
                                      DelAlertDialog(context , ORDERD_ID.toString() , _user_id_sp.toString() , item_id.toString());
                                    }
                                )
            ]//EndOfif
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

  DelAlertDialog(BuildContext context,String order_id ,String cus_id , String item_id) {
    // set up the buttons
  print('Item ID : '+item_id.toString());

  //

    Widget continueButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          fixedSize: Size.fromWidth(140),
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 20),
        ),
        child: const Text("Continue" , style: TextStyle(color: Colors.white, )),
        onPressed: () async {
            if (await apiServices.DeleteOrderApi(context , order_id.toString() , cus_id.toString() ,item_id.toString()) == "Updated"){
              setState(() {
                Info_Dialog(context, "Deleted", "Order Successfully Deleted !");

              });
            }else if(await apiServices.DeleteOrderApi(context , order_id.toString() , cus_id.toString() ,item_id.toString()) == "Updated"){
              Alert_Dialog(context , "Error" , "Order NOT Deleted !");

            }
          //  Navigator.of(context, rootNavigator: true).pop('dialog') ;
        }
    );
  Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        fixedSize: Size.fromWidth(140),
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 20),
      ),
      child: const Text("Cancel" , style: TextStyle(color: Colors.white, )),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop('dialog') ;
      }
  );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm"),
      content: const Text("You want to delete this order ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


