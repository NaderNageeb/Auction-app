
// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:new_auction_app/models/main_model.dart';
import 'package:new_auction_app/screens/order_details.dart';
import 'package:screenshot/screenshot.dart';
import 'package:new_auction_app/services/api_service.dart';
import 'package:intl/intl.dart';
import '../components/ui_assets.dart';



class OrderListState extends StatefulWidget {
  OrderListState();
  @override
  State<StatefulWidget> createState() {
    return OrderList();
  }
}

class OrderList extends State<OrderListState> {

  ScreenshotController screenshotController = ScreenshotController();
  ScreenshotController printScreenshotController = ScreenshotController();

  int hasDataz = 0;
  String _user_id_sp = ''  ;
  String _user_name_sp ='';
  Timer? timer;
  APIService apiServices = APIService();
  final GlobalKey genKey = GlobalKey();
  GlobalKey previewContainer = new GlobalKey();
  var urlz = APIService.url ;
  var format = NumberFormat.currency(locale: 'ar',symbol: "");
  String order_status_text = '';

  @override
  void initState() {
    super.initState();
    apiServices.getIDPreference().then(updateUserID) ;

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => apiServices.getOrdersData(_user_id_sp.toString()));

  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateUserID(String userIdSp){
    setState(() {
      this._user_id_sp = userIdSp ;
      print('User ID From SP : '+ _user_id_sp.toString());
    // apiServices.getOrdersData(_user_id_sp.toString());
    });
  }

  void updateUserName(String userNameSp){
    setState(() {
      this._user_name_sp = userNameSp ;
      print('User NAME From SP : '+ _user_name_sp.toString());
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
  backgroundColor: Colors.grey.shade400,
          appBar: AppBar(
              title: const Text('Your Order List',style: TextStyle(fontSize: 18)),
              backgroundColor:  Colors.green,
              automaticallyImplyLeading: true,

          ),
          body: Screenshot(controller:  screenshotController,
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<List<OrdersData>>(
                      future: apiServices.getOrdersData(_user_id_sp.toString()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          hasDataz = 0 ;
                          print('snapshot : NoDATA');
                          print('hasDataz : ' + hasDataz.toString());
                          return  Center(
                              child: Center(
                                  child:  Container (
                                    child: Text('No Orders yet !',style: TextStyle(fontSize: 20,color: Colors.redAccent)),
                                  )
                              ));
                        }else{

                          hasDataz = 1 ;
                          print('snapshot : hasData');
                          print('hasDataz : ' + hasDataz.toString());
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color:  Colors.white,
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index)
                                {
                                  OrdersData Get_order_Lists = snapshot.data![index];
                                  String status = Get_order_Lists.order_status ;

                                    if(status.toString() =="0"){
                                      order_status_text ="Pendding";
                                    }
                                  if(status.toString() =="1"){
                                    order_status_text ="Confirmed";
                                  }
                                  if(status.toString() =="2"){
                                    order_status_text ="Rejected";
                                  }
                                  return Slidable(
                                    //child:  Screenshot(
                                    //controller: screenshotController,
                                    child: Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          child: Icon(Icons.add_shopping_cart),
                                        ),
                                        title: Text('Auction name : ${Get_order_Lists.auc_name}' ,
                                            style: const TextStyle( color:Colors.black87,fontSize: 20)),
                                        subtitle: Text('Auction Price : ${Get_order_Lists.auc_price} .SDG '
                                            '\nYour Price : ${Get_order_Lists.order_price}.SDG \n'
                                            'Status : $order_status_text ' ,
                                            style: const TextStyle( color:Colors.black87,fontSize: 20)
                                        ),
                                        onTap: () {

                                          navigateTo(context,Get_order_Lists.order_id);

                                        },
                                      ),
                                    ),
                                  );
                                }
                            ) ,
                          );
                        }
                      },
                    ),
                  ),

                ],
              )
          ),)
    );
  }

  navigateTo(BuildContext context, String order_id) {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderDetailsState(order_id.toString()) ,
        )
    );
  }
}

