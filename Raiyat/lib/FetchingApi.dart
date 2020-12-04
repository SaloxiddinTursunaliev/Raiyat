import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class FetchingApi extends StatefulWidget {
  FetchingApi({
    Key key,
  }) : super(key: key);

  @override
  _FetchingApiState createState() => _FetchingApiState();
}

class _FetchingApiState extends State<FetchingApi> {
  bool npLoad = false;
  int npP = 0;
  List npL = new List();
  final npdio = new Dio();
  ScrollController npC = new ScrollController();

  @override
  void initState() {
    npMore();
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
        Response response = await dio.get(
            'https://data.gov.uz/ru/api/v1/json/dataset/11/version/4809?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a');
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

    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      height: 520.5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //iconTheme: new IconThemeData(color: Colors.black26),
          title: Text(
            "Fetching Api",
            //'New Products',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              color: Color.fromARGB(255, 50, 50, 50),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: ListView.builder(
          controller: npC,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          //itemCount: 50,
          itemCount: npL.length + 1,
          itemBuilder: (context, index) {
            if (index == npL.length) {
              return _buildProgressIndicator();
            } else {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: 249,
                  minWidth: 249,
                ),
                width: 249,
                margin: EdgeInsets.only(left: 7.5, right: 7.5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                  semanticContainer: true,
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        //height: 39,
                        //width: 249,
                        child: Text(
                          npL[index]['a4'].toString(),
                          //npL[index]['publication_date'].toString(),
                          //npL[index]['title'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 240, 180, 45),
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 7.5),
                        height: 80,
                        //width: 249,
                        child: Text(
                          npL[index]['a1'].toString(),
                          //npL[index]['publication_date'].toString(),
                          //npL[index]['title'].toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 50, 50, 50),
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
