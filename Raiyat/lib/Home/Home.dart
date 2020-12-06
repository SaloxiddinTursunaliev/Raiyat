import 'package:Raiyat/Views/BankCategories/ATM/ATM.dart';
import 'package:Raiyat/Views/BankCategories/BankCategories.dart';
import 'package:Raiyat/Views/HealthCategories/Health.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
//import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

//import 'package:dio/native_imp.dart';
//import 'package:dio/browser_imp.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        // var headers = {
        //   'content-type': 'application/json',
        //   'Access-Control-Allow-Origin': 'true'
        // };
        // var headers = {
        //   "Access-Control-Allow-Origin":
        //       "*", // Required for CORS support to work
        //   "Access-Control-Allow-Credentials":
        //       true, // Required for cookies, authorization headers with HTTPS
        //   "Access-Control-Allow-Headers":
        //       "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        //   "Access-Control-Allow-Methods": "GET, OPTIONS"
        // };
        Response response = await dio.get(
          'https://data.gov.uz/ru/api/v1/json/dataset/11/version/4809?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
          //options: Options(headers: headers),
        );
        //'https://data.gov.uz/ru/api/v1/json/dataset/11/version?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a');
        //'https://data.gov.uz/ru/api/v1/json/sphere/11/dataset?access_key=b9efad72d2632124a0783c61cac800a9');

        final jsonData = json.decode(response.data);
        // print("\n\n" + jsonData['title']);

        List npList = new List();
        for (int i = 0; i < jsonData.length; i++) {
          npList.add(jsonData[i]);
        }

        setState(() {
          npLoad = false;
          npL.addAll(npList);
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

    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //iconTheme: new IconThemeData(color: Colors.black26),
        title: Text(
          "Raiyat",
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
      body: Column(
        children: [
          Container(
            height: 230,
            child: Image.asset(
              'assets/22.PNG',
              //width: 249,
              height: 230,
              fit: BoxFit.fitWidth,
            ),
          ),
          ListView(
            controller: npC,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
            children: [
              Container(
                margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return Health();
                      }),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(7.5),
                    ),
                    semanticContainer: true,
                    elevation: 8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/Capture.PNG',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                          child: Text(
                            "Tibbiyotga oid",
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
                            "",
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
              ),
              Container(
                margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return Bank();
                      }),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(7.5),
                    ),
                    semanticContainer: true,
                    elevation: 8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/2.PNG',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                          child: Text(
                            "Bankga oid",
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
                            "",
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
              ),
            ],
          ),
          // body: ListView.builder(
          //   controller: npC,
          //   shrinkWrap: true,
          //   padding:
          //       EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
          //   //scrollDirection: Axis.horizontal,
          //   //itemCount: 50,
          //   itemCount: npL.length + 1,
          //   itemBuilder: (context, index) {
          //     if (index == npL.length) {
          //       return _buildProgressIndicator();
          //     } else {
          //       return Container(
          //         // constraints: BoxConstraints(
          //         //   maxWidth: 249,
          //         //   minWidth: 249,
          //         // ),
          //         // width: 249,
          //         margin: EdgeInsets.only(top: 7.5),
          //         child: Card(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: new BorderRadius.circular(0),
          //           ),
          //           semanticContainer: true,
          //           elevation: 3,
          //           child: ListTile(
          //             leading: Icon(
          //               Icons.more_vert,
          //             ),
          //             title: Text(
          //               npL[index]['a4'].toString(),
          //               //npL[index]['publication_date'].toString(),
          //               //npL[index]['title'].toString(),
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //               style: const TextStyle(
          //                 color: Color.fromARGB(255, 50, 50, 50),
          //                 //color: Color.fromARGB(255, 240, 180, 45),
          //                 fontSize: 18.0,
          //                 fontWeight: FontWeight.normal,
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
