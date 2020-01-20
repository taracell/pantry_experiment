import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pantry/camera.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final widgetOptions = [
    Text('Pantry List'),
    CameraWidget(),
    Text('Expires First'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantry App'),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library), title: Text('Pantry Inventory')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo), title: Text('New Pantry Item')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('Expires First')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.teal,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
