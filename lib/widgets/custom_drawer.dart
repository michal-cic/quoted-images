import 'package:flutter/material.dart';
import 'package:quoted_images/pages/favorites.dart';
import 'package:quoted_images/pages/random.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Random(),
              ),
            ),
            child: Text('random'),
          ),
          FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Favorites(),
              ),
            ),
            child: Text('favorites'),
          ),
        ],
      ),
    );
  }
}
