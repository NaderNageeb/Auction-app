// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:new_auction_app/components/ui_assets.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/main_model.dart';

class APIService {
  //10.0.2.2
  //http://10.0.3.2
  //Geny IP 10.0.3.2

  //Connection MSG//
  String conn_title = " Connection Time Out ";
  String conn_string =
      " Can't connect to server make sure you have a good connection and try again ! ";
// http://10.0.2.2:8000

  static var url = "http://10.0.2.2/auction_admin/include/API/index.php";
  String Items_Img_url =
      "http://10.0.2.2/auction_admin/assets/images/items/";

  // static var url = "http://192.168.43.63/auction_admin/include/API/index.php";
  // String Items_Img_url =
  //     "http://192.168.43.63/auction_admin/assets/images/items/";

//Check Connections//
  Future<bool> checkInternetConnnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

////////////////Login////Login////////////////
//Login////Login//
  Future<String> userLoginIn(
      context, String username, String password, scaffoldKey) async {
    var loginUrl = url + "?login";

    String loginStatus;
    var dump_res;
    var jsonValue;
    var res;
    var user_id;
    var user_name;

    var data = {
      "username": username.toString(),
      "pass": password.toString(),
    };

    res = await http.post(Uri.parse(loginUrl), body: data).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        Alert_Dialog(context, conn_title, conn_string);
        loginStatus = "conn_fail";
        return Future.value(res);
      },
    );

    print(res.toString());
    print('Login Res :' + res.body.toString());

    dump_res = jsonDecode(res.body)['result'];

    if (dump_res.toString() != 'NULL') {
      jsonValue = dump_res[0];
      user_id = jsonValue['cus_id'].toString();
      user_name = jsonValue['cus_login_name'].toString();

      if (await savedNamePreference(user_id.toString(), username.toString())) {
        print('User ID  : ${user_id} User Pass : $user_name');
      }

      loginStatus = 'exist';
    } else {
      loginStatus = 'wrong';
      print('RESULT IS NULL !');
    }

    print('User email ' + username.toString());
    print('User Pass ' + password.toString());

    print('loginStatus ' + loginStatus.toString());
    return loginStatus;
  }

  //addNewCustomer_API//
  Future<String> addNewCustomer_API(
      context,
      String cus_full_name,
      String cus_login_name,
      String cus_pass,
      String cus_phone,
      String cus_id_number) async {
    var AdDCusUrl = url + "?addNewCus";
    String finalStatus = '';
    var dump_res;
    var res;

    var data = {
      "cus_full_name": cus_full_name.toString(),
      "cus_login_name": cus_login_name.toString(),
      "cus_pass": cus_pass.toString(),
      "cus_phone": cus_phone.toString(),
      "cus_id_number": cus_id_number.toString(),
    };

    res = await http.post(Uri.parse(AdDCusUrl), body: data).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        Alert_Dialog(context, conn_title, conn_string);
        finalStatus = 'conn_fail';
        return Future.value(res);
      },
    );

    print(data.toString());

    dump_res = jsonDecode(res.body)['cus_result'];

    print('Response ' + dump_res.toString());

    if (dump_res.toString() == 'Exist') {
      finalStatus = 'Exist';
      print('User IS Exist !');
      Alert_Dialog(context, "Exist",
          "User " + cus_login_name.toString() + " Already Exist !");
    }

    if (dump_res.toString() == 'Inserted') {
      finalStatus = 'Inserted';
      print('User IS Inserted !');
      Info_Dialog(context, "Registered",
          "User " + cus_login_name.toString() + " Successfully Registered !");
    }

    if (dump_res.toString() == 'Error') {
      finalStatus = 'Error';
      print('User IS NOT Registered !');
      Alert_Dialog(context, "Oops",
          "User " + cus_login_name.toString() + " NOT Registered !");
    }

    print('Status ' + finalStatus.toString());
    return finalStatus;
  }

  Future<List<CategoryData>> getCategoryData() async {
    final response = await get(Uri.parse("$url?GetCat"));

    print(response.toString());

    if (response.statusCode == 200) {
      List cat_data = json.decode(response.body);
      return cat_data
          .map((cat_data) => CategoryData.fromJson(cat_data))
          .toList();
    } else {
      throw Exception(
          'Error while getting category , Check connections and try again !');
    }
  }

  Future<List<ItemsData>> getItemsData(String cat_id) async {
    String finalUrl = url + '?GetItems&cat_id=' + cat_id.toString();
    final response = await get(Uri.parse(finalUrl));
    print(finalUrl.toString());
    if (response.statusCode == 200) {
      List items_data = json.decode(utf8.decode(response.bodyBytes));
      return items_data
          .map((items_data) => ItemsData.fromJson(items_data))
          .toList();
    } else {
      throw Exception(
          'Error while getting the Items , Check connections and try again !');
    }
  }

  Future<List<ItemsData>> getAuctionItemsData(String auc_id) async {
    String finalUrl = url + '?GetAuctionItems&auc_id=' + auc_id.toString();
    final response = await get(Uri.parse(finalUrl));
    print(finalUrl.toString());
    if (response.statusCode == 200) {
      List items_data = json.decode(utf8.decode(response.bodyBytes));
      return items_data
          .map((items_data) => ItemsData.fromJson(items_data))
          .toList();
    } else {
      throw Exception(
          'Error while getting the Items , Check connections and try again !');
    }
  }

  Future<List<OrdersData>> getOrdersData(String cus_id) async {
    String finalUrl = url + '?myOrders&cus_id=' + cus_id.toString();
    final response = await get(Uri.parse(finalUrl));
    print(finalUrl.toString());
    if (response.statusCode == 200) {
      List order_data = json.decode(utf8.decode(response.bodyBytes));
      return order_data
          .map((order_data) => OrdersData.fromJson(order_data))
          .toList();
    } else {
      throw Exception(
          'Error while getting the Trip , Check connections and try again !');
    }
  }

  Future<List<OrdersData>> getOrdersByID(String order_id) async {
    String finalUrl = url + '?OrderByID&order_id=' + order_id.toString();
    final response = await get(Uri.parse(finalUrl));
    print(finalUrl.toString());
    if (response.statusCode == 200) {
      List order_data = json.decode(utf8.decode(response.bodyBytes));
      return order_data
          .map((order_data) => OrdersData.fromJson(order_data))
          .toList();
    } else {
      throw Exception(
          'Error while getting the Items , Check connections and try again !');
    }
  }

  //Order//
  Future<String> OrderAuctionApi(
      context, String auc_id, String cus_id, String order_price) async {
    var AddOrderUrl = url + "?addNewOrder";
    String finalStatus = '';
    var dump_res;
    var res;

    var data = {
      "auc_id": auc_id.toString(),
      "cus_id": cus_id.toString(),
      "order_price": order_price.toString(),
    };

    res = await http.post(Uri.parse(AddOrderUrl), body: data).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        Alert_Dialog(context, conn_title, conn_string);
        finalStatus = 'conn_fail';
        return Future.value(res);
      },
    );

    print(data.toString());

    dump_res = jsonDecode(res.body)['order_result'];

    print('Response ' + dump_res.toString());

    if (dump_res.toString() == 'Exist') {
      finalStatus = 'Exist';
      print('Order IS Exist !');
      Alert_Dialog(context, "Order Exist", "Order Already Exist !");
    }

    if (dump_res.toString() == 'Inserted') {
      finalStatus = 'Inserted';
      print('Order IS Inserted !');
      Info_Dialog(context, "Ordered",
          "Item Successfully Ordered , Wait for admin confirmation !");
    }

    if (dump_res.toString() == 'Error') {
      finalStatus = 'Error';
      print('Order IS NOT Ordered !');
      Alert_Dialog(context, "Oops", "Item NOT Ordered !");
    }

    print('Status ' + finalStatus.toString());
    return finalStatus;
  }

  Future<String> DeleteOrderApi(
      context, String order_id, String cus_id, String item_id) async {
    var AddOrderUrl = url + "?deleteOrder";
    String finalStatus = '';
    var dump_res;
    var res;

    var data = {
      "order_id": order_id.toString(),
      "cus_id": cus_id.toString(),
      "item_id": item_id.toString(),
    };

    res = await http.post(Uri.parse(AddOrderUrl), body: data).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        Alert_Dialog(context, conn_title, conn_string);
        finalStatus = 'conn_fail';
        return Future.value(res);
      },
    );

    print(data.toString());

    dump_res = jsonDecode(res.body)['order_result'];

    print('Response ' + dump_res.toString());

    if (dump_res.toString() == 'Updated') {
      finalStatus = 'Updated';
      print('Order IS Updated !');
    }

    if (dump_res.toString() == 'Error') {
      finalStatus = 'Error';
      print('Order IS NOT Deleted !');
    }
    print('Status ' + finalStatus.toString());
    return finalStatus;
  }

  //EditMyProfileInfo//
  Future<String> EditProfileInfo(
      context,
      String cus_id,
      String cus_full_name,
      String cus_login_name,
      String cus_pass,
      String cus_phone,
      String cus_id_number) async {
    var Url = url + "?EditInfo";
    String finalStatus = '';
    var dump_res;
    var res;

    var data = {
      "cus_id": cus_id.toString(),
      "cus_full_name": cus_full_name.toString(),
      "cus_login_name": cus_login_name.toString(),
      "cus_pass": cus_pass.toString(),
      "cus_phone": cus_phone.toString(),
      "cus_id_number": cus_id_number.toString(),
    };

    res = await http.post(Uri.parse(Url), body: data).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        Alert_Dialog(context, conn_title, conn_string);
        finalStatus = 'conn_fail';
        return Future.value(res);
      },
    );

    print(data.toString());

    dump_res = jsonDecode(res.body)['cus_result'];

    print('Response ' + dump_res.toString());

    if (dump_res.toString() == 'Updated') {
      finalStatus = 'Updated';
      print('Customer IS Updated !');
      Info_Dialog(context, "Updated", "Your profile Info Successfully Updated");
    }

    if (dump_res.toString() == 'Error') {
      finalStatus = 'Error';
      print('Customer IS NOT Updated !');
      Alert_Dialog(context, "Oops", "Profile  NOT Updated !");
    }

    print('Status ' + finalStatus.toString());
    return finalStatus;
  }

  Future<List<CustomerData>> get_Profile_Info(String cus_id) async {
    String urlz = url + '?MyProfile&cus_id=' + cus_id.toString();
    print(urlz.toString());
    final response = await get(Uri.parse(urlz));
    if (response.statusCode == 200) {
      List customer_data = json.decode(response.body);
      return customer_data
          .map((customer_data) => CustomerData.fromJson(customer_data))
          .toList();
    } else {
      throw Exception(
          'Error while getting Customer Data , Check connections and try again !');
    }
  }

  Future<bool> CleatPreference(
    String user_id,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return prefs.commit();
  }

  Future<bool> savedUserPreference(
      String user_id, String user_name, String user_type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.setString("user_id_sp", user_id);
    prefs.setString("user_name_sp", user_name);
    prefs.setString("user_type_sp", user_type);
    return prefs.commit();
  }

  Future<String> getUserTypePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_type_sp = prefs.getString("user_type_sp").toString();
    return user_type_sp;
  }

  Future<String> getUserIDPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id_sp = prefs.getString("user_id_sp").toString();
    return user_id_sp;
  }

  Future<String> getIDPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id_sp = prefs.getString("user_id_sp").toString();
    return user_id_sp;
  }

  Future<String> getNamePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_name_sp = prefs.getString("user_name_sp").toString();
    return user_name_sp;
  }

  Future<bool> savedNamePreference(
    String user_id,
    String user_name,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    prefs.setString("user_id_sp", user_id);
    prefs.setString("user_name_sp", user_name);
    return prefs.commit();
  }
}

class Crud {
  getRequests(String url) async {
    try {
      var responce = await http.get(Uri.parse(url));
      if (responce.statusCode == 200) {
        var responcebody = jsonDecode(responce.body);
        return responcebody;
      } else {
        print("Error  ${responce.statusCode}");
      }
    } catch (e) {
      print("error catch $e");
    }
  }

  postRequests(String url, Map data) async {
    try {
      var responce = await http.post(Uri.parse(url), body: data);
      if (responce.statusCode == 200) {
        var responcebody = jsonDecode(responce.body);
        return responcebody;
      } else {
        print("Error  ${responce.statusCode}");
      }
    } catch (e) {
      print("error catch $e");
    }
  }
}
