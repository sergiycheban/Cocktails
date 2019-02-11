import 'package:flutter/material.dart';
import './home.dart';

import 'dart:async';

class IngrPage extends StatefulWidget {
  @override
  Ingr createState() => new Ingr();
}

class Ingr extends State<IngrPage> {
  List<String> items = strDrinkIngr;

  @override
  Widget build(BuildContext context) {
    final title = 'All cocktails by ingredient';

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.redAccent),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
              leading: const Icon(Icons.local_bar),
              title: Text('${items[index]}'),
              onTap: () async {
                await fetch(cocktailUrl + items[index]);
                print("middle");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new MyHome()));
              });
        },
      ),
    );
  }
}
