import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import './category.dart';

String strDrink = "Hello, on this page, you can receive a winning coctail";
String strDrinkThumb =
    "http://3.bp.blogspot.com/_6uF1NzP2nac/S9Q1jlrKABI/AAAAAAAAAFw/JbP3EWH32pA/s1600/cocktails.jpg";
String strInstructions = "Press the shuffle button";
String randomUrl = "https://www.thecocktaildb.com/api/json/v1/1/random.php";
String cocktailUrl =
    "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=";

String ingr = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=";

List<String> strDrinkIngr = [""];
List<String> strIngredient = [""];
String urlIngredient = "";
String strDrinkThumbIngr = "";

fetch(String url) async {
  print("start");

  final JsonDecoder _decoder = new JsonDecoder();
  var clientHttp = new Client();
  var response = await clientHttp.get(url);

  final String jsonBody = response.body;
  final statusCode = response.statusCode;

  if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
    throw Exception('Failed to load post');
  }

  final recipesContainer = _decoder.convert(jsonBody);
  final Map<String, dynamic> testMap = recipesContainer['drinks'][0];
  final List recipeItems = recipesContainer['drinks'];

  if (recipeItems == null) {
    strDrink = "NaN";
    strDrinkThumb = "";
  } else {
    strDrink = recipeItems[0]["strDrink"];
    strDrinkThumb = recipeItems[0]["strDrinkThumb"];
    strInstructions = recipeItems[0]["strInstructions"];
    strIngredient.clear();

    for (int i = 0; i < testMap.length; ++i) {
      if (testMap.keys.elementAt(i).toString().startsWith("strIngredient") &&
          !testMap.values.elementAt(i).toString().isEmpty &&
          testMap.values.elementAt(i).toString() != "null")
        strIngredient.add(testMap.values.elementAt(i));
    }
  }

  print("end");
}

fetchIngr(String url) async {
  final JsonDecoder _decoder = new JsonDecoder();
  var clientHttp = new Client();
  var response = await clientHttp.get(url);

  final String jsonBody = response.body;
  final statusCode = response.statusCode;

  if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
    throw Exception('Failed to load post');
  }

  final recipesContainer = _decoder.convert(jsonBody);
  final List recipeItems = recipesContainer['drinks'];

  if (recipeItems == null) {
    strDrinkIngr.add("qqqqqqqqqqqqqqqqqqqqqqqqqqq");
  } else {
    for (int i = 0; i < recipeItems.length; i++)
      strDrinkIngr.add(recipeItems[i]["strDrink"]);
    urlIngredient = recipeItems[0]["strDrinkThumb"];
  }
}

class MyHome extends StatefulWidget {
  @override
  MyHomePage createState() => new MyHomePage();
}

class MyHomePage extends State<MyHome> {
  Widget appBarTitle = new Text("Cocktails");
  Icon actionIcon = new Icon(Icons.search);
  final myController = TextEditingController();

  String _value;
  List<String> _values = new List<String>();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void initState() {
    _values.addAll(["Cocktails", "Ingredient"]);
    _value = _values.elementAt(0);
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      controller: myController,
                      onEditingComplete: () {
                        if (_value == 'Cocktails') {
                          setState(() async {
                            await fetch(cocktailUrl + myController.text);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        } else if (_value == 'Ingredient') {
                          setState(() async {
                            strDrinkIngr.clear();

                            await fetchIngr(ingr + myController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new IngrPage()),
                            );
                          });
                        }
                      },
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Cocktails");
                  }
                });
              },
            )
          ]),
      body: new Container(
        margin: EdgeInsets.all(5.0),
        child: new ListView(
          children: <Widget>[
            new DropdownButton<String>(
              value: _value,
              items: _values.map((String value) {
                return new DropdownMenuItem(
                    value: value,
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.search),
                        new Text('Search by:  ${value}')
                      ],
                    ));
              }).toList(),
              onChanged: (String value) {
                _onChanged(value);
              },
            ),
            new Padding(padding: EdgeInsets.all(10.0)),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  strDrink,
                  style: new TextStyle(fontSize: 35.0),
                ),
                new Image.network(strDrinkThumb),
              ],
            ),
            new Padding(padding: EdgeInsets.all(6.0)),
            new Text("Instructions:",
                style: TextStyle(fontSize: 22.0), textAlign: TextAlign.start),
            new Padding(padding: EdgeInsets.all(5.0)),
            new Text(
              strInstructions,
              textAlign: TextAlign.start,
              style: new TextStyle(fontSize: 16.0),
            ),
            new Padding(padding: EdgeInsets.all(6.0)),
            new Text(
              "Ingredient:",
              textAlign: TextAlign.start,
              style: new TextStyle(fontSize: 22.0),
            ),
            new Padding(padding: EdgeInsets.all(5.0)),
            new Column(
              children: new List.generate(strIngredient.length, (int index) {
                return new ListTile(
                  leading: const Icon(Icons.check),
                  title: new Text("${strIngredient[index]}"),
                );
              }),
            ),
            new SizedBox(
                child: new Align(
                    alignment: FractionalOffset.bottomRight,
                    child: new FloatingActionButton(
                        child: new Icon(Icons.autorenew),
                        onPressed: () {
                          setState(() async {
                            print(strIngredient.length);
                            await fetch(randomUrl);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new MyHome()),
                            );
                          });
                        })))
          ],
        ),
      ),
    );
  }
}
