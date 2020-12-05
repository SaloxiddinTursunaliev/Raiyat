import 'package:Raiyat/Views/HealthCategories/TreatmentPrevention/SpecificRegionList.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
//import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Regions {
  int id;
  String title;
  String description;
  String userName;
  String userPhone;
  String userEmail;
  String userSite;
  String authorityTitle;
  String sphereTitle;

  Regions({
    this.id,
    this.title,
    this.description,
    this.userName,
    this.userPhone,
    this.userEmail,
    this.userSite,
    this.authorityTitle,
    this.sphereTitle,
  });

  factory Regions.fromJson(Map<String, dynamic> parsedJson) {
    return Regions(
      id: parsedJson['id'] as int,
      title: parsedJson['title'] as String,
      description: parsedJson['description'] as String,
      userName: parsedJson['user_name'] as String,
      userPhone: parsedJson['user_phone'] as String,
      userEmail: parsedJson['user_mail'] as String,
      userSite: parsedJson['user_site'] as String,
      authorityTitle: parsedJson['authority_title'] as String,
      sphereTitle: parsedJson['sphere_title'] as String,
    );
  }
}

class Categories extends StatefulWidget {
  final int a;
  Categories({
    Key key,
    this.a,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ScrollController controller = new ScrollController();

  bool loading = false;

  static List<Regions> regionsMap;

  void getData() async {
    if (!loading) {
      try {
        setState(() {
          loading = true;
        });

        Dio dio = new Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        regionsMap = new List<Regions>();

        String jsonString = await rootBundle.loadString('assets/Regions.json');

        final jsonData = json.decode(jsonString);

        regionsMap = new List<Regions>();

        for (int i = 0; i < jsonData.length; i++) {
          regionsMap.add(new Regions.fromJson(jsonData[i]));
        }

        setState(() {
          loading = false;
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
            opacity: loading ? 1.0 : 00,
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black26),
        title: Text(
          "Raiyat",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            color: Color.fromARGB(255, 50, 50, 50),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
        itemCount: regionsMap.length + 1,
        itemBuilder: (context, index) {
          if (index == regionsMap.length) {
            return _buildProgressIndicator();
          } else {
            return Container(
              margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ListCategories(a: regionsMap[index].id);
                    }),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(7.5),
                  ),
                  semanticContainer: true,
                  elevation: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                        child: Text(
                          "   " + regionsMap[index].title,
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 50, 100),
                            fontSize: 21.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Divider(thickness: 1.3),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        child: Text(
                          regionsMap[index].authorityTitle,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 7.5, 15, 15),
                        child: Text(
                          "Тел:  " + regionsMap[index].userPhone,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
