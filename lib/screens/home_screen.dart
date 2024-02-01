// ignore_for_file: unused_import, non_constant_identifier_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, unnecessary_this, avoid_print, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/main_model.dart';
import '../services/api_service.dart';
import 'auction_details.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String Cat_ID = "";
  String _user_id_sp = "";
  String _user_name_sp = "";
  APIService apiServices = APIService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    apiServices.getIDPreference().then(updateID);
    apiServices.getNamePreference().then(updateName);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Welcome : ' + _user_name_sp.toString()),
        actions: [
          InkWell(
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Icon(Icons.exit_to_app),
          ),
          // Icon(Icons.exit_to_app),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 280,
              child: FutureBuilder<List<CategoryData>>(
                future: apiServices.getCategoryData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: 300,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          spreadRadius: 2,
                                          color: Colors.black12,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ListTile(
                                          title: Text(
                                            textAlign: TextAlign.center,
                                            snapshot.data![index].cat_name
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            textAlign: TextAlign.center,
                                            "\n" +
                                                snapshot.data![index].cat_desc
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          onTap: () {
                                            print("Cat Id : " +
                                                snapshot.data![index].cat_id
                                                    .toString());
                                            setState(() {
                                              Cat_ID = snapshot
                                                  .data![index].cat_id
                                                  .toString();
                                            });
                                          },
                                        ),
                                        Text(""),
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tap Here",
                                              textAlign: TextAlign.center,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Icon(
                                                Icons.ads_click,
                                                size: 20,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    snapshot.data![index].imageUrl.toString(),
                                    height: 153,
                                    width: 150,
                                    //fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (Cat_ID.toString() != "") ...[
              // ItemsListWidget(context)
              Expanded(
                child: FutureBuilder<List<ItemsData>>(
                  future: apiServices.getItemsData(Cat_ID.toString()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      print('snapshot : NoDATA');
                      return Center(
                          child: Center(
                              child: Container(
                        child: Text('No Auction Items !',
                            style: TextStyle(
                                fontSize: 20, color: Colors.redAccent)),
                      )));
                    } else {
                      print('snapshot : hasData');
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade400,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              ItemsData Get_Items_Lists = snapshot.data![index];

                              return Slidable(
                                child: Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      child: Icon(Icons.add_shopping_cart),
                                    ),
                                    title: Text(
                                        'Auction Name : ${Get_Items_Lists.auc_name}'),
                                    subtitle: Text(
                                        'Price : ${Get_Items_Lists.auc_price}.SDG \nEnd Date : ${Get_Items_Lists.auc_end_date}',
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16)),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            AuctionDetailsState(Get_Items_Lists
                                                .auc_id
                                                .toString()),
                                      ));
                                    },
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  },
                ),
              )
            ] else ...[
              SizedBox(
                height: 20,
              ),
              const Center(
                child: Text("Please Select Category !",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 20)),
              ),
            ] //endOfIf
          ],
        ),
      ),
    );
  }
}
