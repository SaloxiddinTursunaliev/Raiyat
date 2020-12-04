import 'package:Raiyat/Views/Categories/ListCategories.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Categories extends StatefulWidget {
  Categories({
    Key key,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool npLoad = false;
  int npP = 0;
  List npL = new List();
  final npdio = new Dio();
  ScrollController npC = new ScrollController();

  @override
  void initState() {
    //npMore();
    super.initState();
  }

  @override
  void dispose() {
    npC.dispose();
    super.dispose();
  }

  void npMore() async {
    if (!npLoad) {
      try {
        setState(() {
          npLoad = true;
        });

        Dio dio = new Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        for (int i = 551; i <= 563; i++) {
          var url = "https://data.gov.uz/ru/api/v1/json/dataset" +
              i.toString() +
              "?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a";
          Response response = await dio.get(
            url,
          );
          final jsonData = json.decode(response.data);
          for (int i = 0; i < jsonData.length; i++) {
            npL.add(jsonData[i]);
          }
        }

        setState(() {
          npLoad = false;

          npP++;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildProgressIndicator() {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
          child: new Opacity(
            opacity: npLoad ? 1.0 : 00,
            child: new CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      height: 520.5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //iconTheme: new IconThemeData(color: Colors.black26),
          title: Text(
            "Raiyat Categories",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              color: Color.fromARGB(255, 50, 50, 50),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 3,
        ),
        body: ListView(
          controller: npC,
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
          children: [
            Container(
              margin: EdgeInsets.only(top: 7.5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(0),
                ),
                semanticContainer: true,
                elevation: 3,
                child: ListTile(
                  // leading: Icon(
                  //   Icons.more_vert,
                  // ),
                  title: Text(
                    "Andijon viloyatida joylashgan davolash-profilaktika muassasalari reestri",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 50, 50, 50),
                      //color: Color.fromARGB(255, 240, 180, 45),
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 7.5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(0),
                ),
                semanticContainer: true,
                elevation: 3,
                child: ListTile(
                  onTap: () {
                    String a = "assets/photos/Raiyat-commerce/banner/3.1.jpg";

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ListCategories(a: 551);
                      }),
                    );
                  },
                  // leading: Icon(
                  //   Icons.more_vert,
                  // ),
                  title: Text(
                    "Buxoro viloyatida joylashgan davolash-profilaktika muassasalari reestri",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 50, 50, 50),
                      //color: Color.fromARGB(255, 240, 180, 45),
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 7.5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(0),
                ),
                semanticContainer: true,
                elevation: 3,
                child: ListTile(
                  leading: Icon(
                    Icons.more_vert,
                  ),
                  title: Text(
                    "Jizzax viloyatida joylashgan davolash-profilaktika muassasalari reestri",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 50, 50, 50),
                      //color: Color.fromARGB(255, 240, 180, 45),
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
