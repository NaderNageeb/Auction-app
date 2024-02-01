// ignore_for_file: non_constant_identifier_names, unnecessary_new, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, unnecessary_null_comparison, unused_import

import 'package:new_auction_app/screens/home_screen.dart';
import 'package:new_auction_app/screens/page_view.dart';
import 'package:flutter/material.dart';

import '../components/ui_assets.dart';
import '../services/api_service.dart';
import 'create_account.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}


class _LoginScreen extends State<LoginScreen> {

  late TextEditingController user_name,user_pass;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  APIService apiServices = new APIService();
  bool processing = false;

  @override
  void initState() {
    super.initState();
    user_name = TextEditingController();
    user_pass = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome To Auction App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo image path
              height: 150,
              width: 150,
            ),
            SizedBox(height: 10),
            Text(
              'Auction App',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: globalFormKey,
              child: Column(
                children: <Widget>[

                  SizedBox(height: 0),
                  TextFormField(
                    controller: user_name,
                    keyboardType: TextInputType.text,
                    //onSaved: (input) => loginRequestModel.email = input,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Username !';
                      }
                      return null;
                    },
                    decoration:  InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      hintText: "Username",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme.secondary
                                  .withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      prefixIcon: Icon(
                        Icons.supervised_user_circle,
                        color:  Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: user_pass,
                    style:
                    TextStyle(color: Colors.black ),
                    keyboardType: TextInputType.text,
                    //loginRequestModel.password = input,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'Please enter your Password !';
                      }
                      return null;
                    },
                    obscureText: hidePassword,
                    decoration:  InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      hintText: "Password",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme.secondary
                                  .withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color:  Colors.green,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        color: Colors.green,
                        icon: Icon(hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Colors.green,
                                fixedSize: Size.fromWidth(80),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 20),
                              ),
                              onPressed: () async {
                                if (globalFormKey.currentState!.validate()) {
                                  setState(() {
                                    isApiCallProcess = true;
                                  }
                                  );
                                  apiServices.checkInternetConnnection().then((intenet) async {
                                    if (intenet != null && intenet){
                                      if(await apiServices.userLoginIn(context,user_name.text.toString(),user_pass.text.toString(),scaffoldKey)=="exist")
                                      {
                                        setState(() {
                                          isApiCallProcess = false;
                                          _navigateToHomeScreen(context);
                                        });
                                      }else{
                                        setState(() {
                                          isApiCallProcess = false;
                                          Alert_Dialog(context, "Oops", "Wrong Username / Password !");
                                        });
                                      }
                                    }else{
                                      // No-Internet Case
                                      setState(() {
                                        isApiCallProcess = false;
                                        Alert_Dialog(context, "No Connection", "Make sure you have internet connection and try again !");
                                      });
                                    }
                                  });
                                }
                              },
                              child: Text("Login"   , style: TextStyle(
                                color: Colors.white, )),
                            ),
                            SizedBox(width: 5),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:  Colors.green,
                                  fixedSize: Size.fromWidth(150),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 20),
                                ),
                                child: Text("Create Account",textAlign: TextAlign.center, style: TextStyle(
                                  color: Colors.white, )),
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=>AccountScreen() ,
                                  ));
                                }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
  _navigateToHomeScreen (BuildContext context)  {
    Navigator.pushAndRemoveUntil( context,  MaterialPageRoute(builder: (context) => PageViewDemo()), (route) => false,);

  }
}