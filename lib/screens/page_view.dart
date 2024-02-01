
// ignore_for_file: prefer_final_fields, prefer_const_constructors, unused_import

import 'package:new_auction_app/screens/home_screen.dart';

import 'my_profile.dart';
import 'orders.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'package:flutter/material.dart';

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

    @override
    State<PageViewDemo> createState() => _PageViewDemoState();

}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _pageController = PageController();
  int selectedPage = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [buildPageView(), buildBottomNav()]),
    );
  }
  Widget buildPageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: PageView(
        controller: _pageController,
        children: [HomeScreen(), OrderListState(), ProfileScreen()],
        onPageChanged: (index) {
          onPageChange(index);
        },
      ),
    );
  }
  Widget buildBottomNav() {
    return BottomNavigationBar(
//activeIcon:Icon(Icons.home,color: Colors.green,)
      currentIndex: selectedPage,
      items: [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home),),
        BottomNavigationBarItem(label: "Orders", icon: Icon(Icons.card_travel_outlined)),
        BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.present_to_all)),
      ],
      onTap: (int index) {
        _pageController.animateToPage(index,
            duration: Duration(microseconds: 1000), curve: Curves.easeIn);
      },
    );
  }

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
