import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class UiAssets {

  late DateTime currentBackPressTime;

  void showToast(String Msg) {
    Fluttertoast.showToast(
        msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white
    );
  }

  void ExitApp(String Msg) {
    Fluttertoast.showToast(
        msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
  }

}

class Dialogs {
  static Future<void> LoadingDialog(
      //GlobalKey key
      BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return WillPopScope(

              onWillPop: () async => false,
              child: SimpleDialog(
                  title : Text("Loading",style: TextStyle( color: Colors.white)),
                  //key: key,//black54
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        Text("Please Wait,Getting Data...",style: TextStyle(color: Colors.white),)
                      ]),
                    )
                  ]));
        });
  }
}

Future<void> Alert_Dialog(BuildContext context,String Yor_title,String Msg) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    //this means the user must tap a button to exit the Alert Dialog
    builder: ( context) {
      return AlertDialog(
        title: Text(Yor_title,style: TextStyle(
            color: Colors.red)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(Msg
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
      style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: Text("OK"),
              onPressed: () {
                _navigateToHomeScreen(context);
              }

          )

        ],
      );
    },
  );
}

Future<void> Info_Dialog(BuildContext context,String Yor_title,String Msg) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    //this means the user must tap a button to exit the Alert Dialog
    builder: ( context) {
      return AlertDialog(
        title: Text(Yor_title,style: TextStyle(
            color: Colors.green)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(Msg
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop() ;
              }
          )
        ],
      );
    },
  );
}

Future<void> Confirm_Dialog(BuildContext context,String Yor_title,String Msg) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: ( context) {
      return AlertDialog(
        title: Text(Yor_title,style: TextStyle(
            color: Colors.green)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(Msg
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              child: Text("Yes"),
              onPressed: () {}
          ),ElevatedButton(
              child: Text("No"),
              onPressed: () {}
          )
        ],
      );
    },
  );
}

_navigateToHomeScreen (BuildContext context)  {
  //Navigator.push( context,MaterialPageRoute(builder: (context) => CategoryScreen()));
  Navigator.pop(context);
}

