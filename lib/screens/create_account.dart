// ignore_for_file: unnecessary_new, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, library_private_types_in_public_api, use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:new_auction_app/services/progressHUD.dart';
import 'package:new_auction_app/services/api_service.dart';

import '../components/ui_assets.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreen createState() => _AccountScreen();

}

class _AccountScreen extends State<AccountScreen> {

  late TextEditingController user_name,user_pass;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _addFormKey = GlobalKey<FormState>();
  APIService apiServices = new APIService();

  bool processing = false;

  final CustomerFullName = TextEditingController();
  final CustomerLoginName = TextEditingController();
  final CustomerPassword = TextEditingController();
  final CustomerPhone = TextEditingController();
  final CustomerIDNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    user_name = TextEditingController();
    user_pass = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf03224)),
    );
  }

  Widget _uiSetup(BuildContext context) {

    return Container(
      constraints: const BoxConstraints.expand(),
      child : Scaffold(
        appBar: AppBar(

            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          title: Text("Create Account",style: TextStyle(color: Colors.white, )),
          centerTitle: false,
        ),
        key: scaffoldKey,
          backgroundColor: Colors.green,
        body: Form(
            key: _addFormKey,
            child: SingleChildScrollView(
            child: Container(

              padding: EdgeInsets.all(30.0),
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
                              controller: CustomerFullName,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Full Name !';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
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
                              controller: CustomerLoginName,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Login Name  !';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
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
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(

                              obscureText: hidePassword,
                              controller: CustomerPassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Password !';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  color: Colors.blue
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
                              controller: CustomerPhone,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter Phone Number !';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
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
                              controller: CustomerIDNumber,
                              keyboardType: TextInputType.numberWithOptions(),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Enter ID Number !';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
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
                                      child: Text("Create Account" , style: TextStyle(color: Colors.white, )),
                                      onPressed: () async {
                                        if (_addFormKey.currentState!.validate()) {
                                          _addFormKey.currentState!.save();

                                          apiServices.checkInternetConnnection().then((intenet) async {
                                            if (intenet != null && intenet) {

 apiServices.addNewCustomer_API(context,CustomerFullName.text.toString(),CustomerLoginName.text.toString()
,CustomerPassword.text.toString(),CustomerPhone.text.toString(),CustomerIDNumber.text.toString());

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

