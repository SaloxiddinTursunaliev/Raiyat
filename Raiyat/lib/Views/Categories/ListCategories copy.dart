import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ListCategories extends StatefulWidget {
  final int a;
  ListCategories({
    Key key,
    this.a,
  }) : super(key: key);

  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  bool npLoad = false;
  int npP = 0;
  List npL = new List();
  List meta = new List();
  final npdio = new Dio();
  ScrollController npC = new ScrollController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    npC.dispose();
    super.dispose();
  }

  void getData() async {
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

        Response responseMeta = await dio.get(
          'https://data.gov.uz/uz/api/v1/json/dataset/' +
              widget.a.toString() +
              '?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
        );

        final jsonDataMeta = json.decode(responseMeta.data);

        List listMeta = new List();
        listMeta.add(jsonDataMeta);

        Response responseV = await dio.get(
          'https://data.gov.uz/ru/api/v1/json/dataset/' +
              widget.a.toString() +
              '/version?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
        );

        final jsonDataV = json.decode(responseV.data);

        Response response = await dio.get(
          'https://data.gov.uz/uz/api/v1/json/dataset/' +
              widget.a.toString() +
              '/version/' +
              jsonDataV[jsonDataV.length - 1]['id'].toString() +
              '?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
        );

        final jsonData = json.decode(response.data);

        List npList = new List();
        for (int i = 0; i < jsonData.length; i++) {
          npList.add(jsonData[i]);
        }

        setState(() {
          npLoad = false;
          meta.addAll(listMeta);
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
      //backgroundColor: Colors.black12,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black26),
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
        actions: [
          GestureDetector(
            child: const Icon(Icons.search, size: 30),
            onTap: () {},
          ),
          SizedBox(width: 15),
        ],
      ),
      body: ListView.builder(
        controller: npC,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
        itemCount: npL.length + 1,
        itemBuilder: (context, index) {
          if (index == npL.length) {
            return _buildProgressIndicator();
          } else {
            return Container(
              margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
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
                      //Name
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                      child: Text(
                        npL[index]['id'].toString() +
                            ".  " +
                            npL[index]['g1'].toString(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 50, 100),
                          fontSize: 21.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Divider(thickness: 1.3),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                      child: Table(
                        // textDirection: TextDirection.rtl,
                        // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                        // border:TableBorder.all(width: 2.0,color: Colors.red),
                        columnWidths: {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(6),
                        },
                        children: [
                          TableRow(
                            //Address
                            children: [
                              Text(
                                meta[0]['structure']['meta'][1]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g2'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            //Director
                            children: [
                              Text(
                                meta[0]['structure']['meta'][2]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g3'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            //Tel 1
                            children: [
                              Text(
                                meta[0]['structure']['meta'][6]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g7'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            //Tel 2
                            children: [
                              Text(
                                meta[0]['structure']['meta'][7]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g8'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            //Email
                            children: [
                              Text(
                                meta[0]['structure']['meta'][5]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g6'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            //Stir
                            children: [
                              Text(
                                meta[0]['structure']['meta'][3]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g4'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            //Ktut
                            children: [
                              Text(
                                meta[0]['structure']['meta'][4]['title_uz'] +
                                    ":  ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                npL[index]['g5'].toString() + "\n",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 7, 50, 100),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          child: Text(
                            "See Details",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 50, 50, 50),
                              //fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/Home");
                          },
                        ),
                        InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          child: Text(
                            "Add to Card",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 50, 50, 50),
                              //fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/Home");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
