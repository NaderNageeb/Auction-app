// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_import

import 'dart:ffi';

class CategoryData {
  final String cat_id;
  final String cat_name, cat_desc, cat_img, imageUrl;

  CategoryData({
    required this.cat_id,
    required this.cat_name,
    required this.cat_desc,
    required this.cat_img,
    required this.imageUrl,
  });

  factory CategoryData.fromJson(Map<String, dynamic> jsonData) {
    return CategoryData(
      cat_id: jsonData['cat_id'],
      cat_name: jsonData['cat_name'],
      cat_desc: jsonData['cat_desc'],
      cat_img: jsonData['cat_img'],
      imageUrl: "http://10.0.2.2/auction_admin/assets/images/category/" +
          jsonData['cat_img'],
    );
  }
}

class ItemsData {
  final String item_id, auc_id;
  final String item_name, cat_id, item_desc, item_img, imageUrl, item_status;
  final String auc_name, auc_desc, auc_price, auc_status, auc_end_date;
  // new

// new
  ItemsData({
    required this.auc_id,
    required this.item_id,
    required this.item_name,
    required this.cat_id,
    required this.item_desc,
    required this.item_img,
    required this.imageUrl,
    required this.item_status,
    required this.auc_name,
    required this.auc_desc,
    required this.auc_price,
    required this.auc_status,
    required this.auc_end_date,
    // new
  });

  factory ItemsData.fromJson(Map<String, dynamic> jsonData) {
    return ItemsData(
      auc_id: jsonData['auc_id'],
      item_id: jsonData['item_id'],
      item_name: jsonData['item_name'],
      cat_id: jsonData['cat_id'],
      item_desc: jsonData['item_desc'],
      item_img: jsonData['item_img'],
      imageUrl: "http://10.0.2.2/auction_admin/assets/images/items/" +
          jsonData['item_img'],
      item_status: jsonData['item_status'],
      auc_name: jsonData['auc_name'],
      auc_desc: jsonData['auc_desc'],
      auc_price: jsonData['auc_price'],
      auc_status: jsonData['auc_status'],
      auc_end_date: jsonData['auc_end_date'],
      // new
    );
  }
}

class OrdersData {
  final String item_id, auc_id, order_id;
  final String item_name, cat_id, item_desc, item_img, imageUrl, item_status;
  final String auc_name, auc_desc, auc_price, auc_status, auc_end_date;
  final String order_price, order_status;

  OrdersData({
    required this.order_id,
    required this.auc_id,
    required this.item_id,
    required this.item_name,
    required this.cat_id,
    required this.item_desc,
    required this.item_img,
    required this.imageUrl,
    required this.item_status,
    required this.auc_name,
    required this.auc_desc,
    required this.auc_price,
    required this.auc_status,
    required this.auc_end_date,
    required this.order_price,
    required this.order_status,
  });

  factory OrdersData.fromJson(Map<String, dynamic> jsonData) {
    return OrdersData(
      order_id: jsonData['order_id'],
      auc_id: jsonData['auc_id'],
      item_id: jsonData['item_id'],
      item_name: jsonData['item_name'],
      cat_id: jsonData['cat_id'],
      item_desc: jsonData['item_desc'],
      item_img: jsonData['item_img'],
      imageUrl: "http://10.0.2.2/auction_admin/assets/images/items/" +
          jsonData['item_img'],
      item_status: jsonData['item_status'],
      auc_name: jsonData['auc_name'],
      auc_desc: jsonData['auc_desc'],
      auc_price: jsonData['auc_price'],
      auc_status: jsonData['auc_status'],
      auc_end_date: jsonData['auc_end_date'],
      order_price: jsonData['order_price'],
      order_status: jsonData['order_status'],
    );
  }
}

class CustomerData {
  final String cus_id;
  final String cus_login_name,
      cus_pass,
      cus_full_name,
      cus_phone,
      cus_id_number;

  CustomerData({
    required this.cus_id,
    required this.cus_login_name,
    required this.cus_pass,
    required this.cus_full_name,
    required this.cus_phone,
    required this.cus_id_number,
  });

  factory CustomerData.fromJson(Map<String, dynamic> jsonData) {
    return CustomerData(
      cus_id: jsonData['cus_id'],
      cus_login_name: jsonData['cus_login_name'],
      cus_pass: jsonData['cus_pass'],
      cus_full_name: jsonData['cus_full_name'],
      cus_phone: jsonData['cus_phone'],
      cus_id_number: jsonData['cus_id_number'],
    );
  }
}
