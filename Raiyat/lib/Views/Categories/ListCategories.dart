import 'package:Raiyat/Views/Categories/SearchSuggestions.dart';
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
    SearchSuggestionsClass.loadSearchSuggestions(widget.a);
    tc = TextEditingController();
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

  ////////////////////////////////////////////////////////////////////////////////////////////////

  String preIs = "";
  String query = '';
  String querySaved = '';
  String queryAbstract = '';
  bool search = false;
  bool typing = true;
  TextEditingController tc;
  List searchSuggestions = [];

  void setSearchSuggestions(String query) {
    searchSuggestions = SearchSuggestionsClass.searchSuggestions
        .where(
          (element) =>
              element.id.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.name.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.director.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.phone1.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.phone2.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.email.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.stir.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              element.ktut.toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
        )
        .toList();
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 60,
            child: Focus(
              onFocusChange: (hasNotFocus) {
                if (!hasNotFocus) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    search = false;
                  });
                }
              },
              child: TextField(
                autocorrect: true,
                onSubmitted: (query) {},
                onTap: () {},
                onChanged: (v) {
                  setState(
                    () {
                      query = v;
                      querySaved = v;
                      if (typing) {
                        queryAbstract = 'Not empty';
                        if (query.isEmpty) {
                          queryAbstract = '';
                        }
                        setSearchSuggestions(query);
                      }
                    },
                  );
                },
                controller: tc,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(
                    top: 0.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 14.0,
                  ),
                  filled: true,
                  isDense: true,
                  hintText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  focusedBorder: search
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.2),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1.2),
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(color: Colors.black26, width: 1.2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(width: 1.2, color: Colors.orange),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(width: 1.2, color: Colors.black26),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide:
                        BorderSide(width: 1.2, color: Colors.yellowAccent),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        controller: npC,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
        //itemCount: npL.length + 1,
        itemCount: queryAbstract.isEmpty
            ? npL.length + 1 > 50
                ? 50
                : npL.length + 1
            : (searchSuggestions.length > 5)
                ? 5
                : searchSuggestions.length,
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
                        queryAbstract.isEmpty
                            ? npL[index]['id'] + ".  " + npL[index]['g1']
                            : searchSuggestions[index].id +
                                ".  " +
                                searchSuggestions[index].name,
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g2'] + "\n"
                                    : searchSuggestions[index].address,
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g3'] + "\n"
                                    : searchSuggestions[index].director + "\n",
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g7'] + "\n"
                                    : searchSuggestions[index].phone1 + "\n",
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g8'] + "\n"
                                    : searchSuggestions[index].phone2 + "\n",
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g6'] + "\n"
                                    : searchSuggestions[index].email + "\n",
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g4'] + "\n"
                                    : searchSuggestions[index].stir + "\n",
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
                                queryAbstract.isEmpty
                                    ? npL[index]['g5'] + "\n"
                                    : searchSuggestions[index].ktut + "\n",
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
