// ignore_for_file: unused_import, prefer_interpolation_to_compose_strings, non_constant_identifier_names, unnecessary_new, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_this, avoid_print, unused_local_variable, avoid_single_cascade_in_expression_statements, sort_child_properties_last, prefer_const_constructors, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_auction_app/screens/home_screen.dart';
import 'package:new_auction_app/services/progressHUD.dart';
import 'package:new_auction_app/services/api_service.dart';
import '../components/ui_assets.dart';

class ProfileScreen extends StatefulWidget {
  @override

  _ProfileScreen createState() => _ProfileScreen();

}

class _ProfileScreen extends State<ProfileScreen> {

  late TextEditingController user_name,user_pass;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _addFormKey = GlobalKey<FormState>();
  APIService apiServices = new APIService();
  String _user_id_sp = "" ;
  bool processing = false;
  Timer? timer;

  final CusFullName = TextEditingController();
  final CusLoginName = TextEditingController();
  final CusPassword = TextEditingController();
  final CusPhone = TextEditingController();
  final CusIDNumber = TextEditingController();
  final DriverStatus = TextEditingController();

  @override
  void initState() {
    super.initState();
    user_name = TextEditingController();
    user_pass = TextEditingController();

    apiServices.getIDPreference().then(updateUserID);

  }

  void updateUserID(String userIdSp){
    setState(() {
      this._user_id_sp = userIdSp ;
      print('User ID From SP : '+ _user_id_sp.toString());
     get_Customer_Info(_user_id_sp.toString());
    });
  }

  Future<bool> get_Customer_Info(String user_id) async {

    bool listValue = false ;

    String cus_id ,cus_login_name,cus_pass , cus_full_name , cus_phone , cus_id_number;



    final list = await apiServices.get_Profile_Info(user_id.toString());


    cus_id = list[0].cus_id;
    cus_login_name = list[0].cus_login_name;
    cus_pass = list[0].cus_pass;
    cus_full_name = list[0].cus_full_name;
    cus_phone = list[0].cus_phone;
    cus_id_number = list[0].cus_id_number;


    setState(() {
      CusLoginName..text = cus_login_name.toString();
      CusFullName..text = cus_full_name.toString();
      CusPhone..text = cus_phone.toString();
      CusIDNumber..text = cus_id_number.toString();

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
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back,
          //     color: Colors.white,
          //   ),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          title: Text("Your Profile",style: TextStyle(color: Colors.white, )),
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
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: CusFullName,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Full Name !';
                                }
                                return null;
                              },
                              decoration:  InputDecoration(
                                hintText: "Your Full Name",
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
                              controller: CusLoginName,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Login Name  !';
                                }
                                return null;
                              },
                              decoration:  InputDecoration(
                                hintText: "Login Name",
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
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              obscureText: hidePassword,
                              controller: CusPassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Password !';
                                }
                                return null;
                              },
                              decoration:  InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  color: Color(0xFF4F4F4F)
                                      .withOpacity(0.4),
                                  icon: Icon(hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                hintText: "Password",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.secondary
                                            .withOpacity(0.2))
                                ),
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
                              controller: CusPhone,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Phone Number !';
                                }
                                return null;
                              },
                              decoration:  InputDecoration(
                                hintText: "Phone Number",
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
                              controller: CusIDNumber,
                              keyboardType: TextInputType.numberWithOptions(),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter ID Number !';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "ID Number",
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
                                    child: const Text("Update Profile" , style: TextStyle(color: Colors.white, )),
                                    onPressed: () async {
                                      if (_addFormKey.currentState!.validate()) {
                                        _addFormKey.currentState!.save();
                                        apiServices.checkInternetConnnection().then((intenet) async {
                                          if (intenet != null && intenet) {
        apiServices.EditProfileInfo(context,_user_id_sp.toString(),CusFullName.text.toString(),CusLoginName.text.toString() ,CusPassword.text.toString(),CusPhone.text.toString(),CusIDNumber.text.toString());
                                          }else{
                                            setState(() {
                                              Alert_Dialog(context, "No Connection", "Make sure you have internet connection and try again !");
                                            });
                                          }
                                        });
                                      }
                                    }
                                ),
                                SizedBox(width: 5),
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
}

