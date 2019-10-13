import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoted_images/pages/favorites.dart';
import 'package:quoted_images/pages/random.dart';
import 'package:quoted_images/providers/images_random.dart';
import 'package:quoted_images/providers/quotes_favorite.dart';
import 'package:quoted_images/providers/quotes_random.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
