import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
//import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class SearchSuggestions {
  String id;
  String name;
  String address;
  String director;
  String stir;
  String ktut;
  String email;
  String phone1;
  String phone2;

  SearchSuggestions({
    this.id,
    this.name,
    this.address,
    this.director,
    this.stir,
    this.ktut,
    this.email,
    this.phone1,
    this.phone2,
  });

  factory SearchSuggestions.fromJson(Map<String, dynamic> parsedJson) {
    return SearchSuggestions(
      id: parsedJson['id'] as String,
      name: parsedJson['g1'] as String,
      address: parsedJson['g2'] as String,
      director: parsedJson['g3'] as String,
      stir: parsedJson['g4'] as String,
      ktut: parsedJson['g5'] as String,
      email: parsedJson['g6'] as String,
      phone1: parsedJson['g7'] as String,
      phone2: parsedJson['g8'] as String,
    );
  }
}

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
  @override
  void initState() {
    getData();
    tc = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ScrollController controller = new ScrollController();

  bool loading = false;

  List list = new List();
  List meta = new List();
  static List<SearchSuggestions> searchSuggestionsMap;

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

        //////////////////////////
        /// fetching Meta data
        //////////////////////////

        Response responseMeta = await dio.get(
          'https://data.gov.uz/uz/api/v1/json/dataset/' +
              widget.a.toString() +
              '?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
        );

        final jsonDataMeta = json.decode(responseMeta.data);

        List listMeta = new List();
        listMeta.add(jsonDataMeta);

        //////////////////////////
        /// fetching Version
        //////////////////////////

        Response responseV = await dio.get(
          'https://data.gov.uz/ru/api/v1/json/dataset/' +
              widget.a.toString() +
              '/version?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
        );

        final jsonDataV = json.decode(responseV.data);

        //////////////////////////
        /// fetching List
        //////////////////////////

        Response response = await dio.get(
          'https://data.gov.uz/uz/api/v1/json/dataset/' +
              widget.a.toString() +
              '/version/' +
              jsonDataV[jsonDataV.length - 1]['id'].toString() +
              '?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
        );

        final jsonData = json.decode(response.data);

        List subList = new List();
        searchSuggestionsMap = new List<SearchSuggestions>();

        for (int i = 0; i < jsonData.length; i++) {
          if (jsonData[i].length < 9) {
            if (jsonData[i].length == 1) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g1\":\" \",\"g2\":\" \",\"g3\":\" \",\"g4\":\" \",\"g5\":\" \",\"g6\":\" \",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 2) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g2\":\" \",\"g3\":\" \",\"g4\":\" \",\"g5\":\" \",\"g6\":\" \",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 3) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g3\":\" \",\"g4\":\" \",\"g5\":\" \",\"g6\":\" \",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 4) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g4\":\" \",\"g5\":\" \",\"g6\":\" \",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 5) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g5\":\" \",\"g6\":\" \",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 6) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g6\":\" \",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 7) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g7\":\" \",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            } else if (jsonData[i].length == 8) {
              String enc = json.encode(jsonData[i]);
              String rep = enc.replaceAll(
                "}",
                ",\"g8\":\" \"}",
              );
              final dec = json.decode(rep);

              subList.add(dec);
              searchSuggestionsMap.add(new SearchSuggestions.fromJson(dec));
            }
          } else {
            subList.add(jsonData[i]);
            searchSuggestionsMap
                .add(new SearchSuggestions.fromJson(jsonData[i]));
          }
        }

        setState(() {
          loading = false;
          meta.addAll(listMeta);
          list.addAll(subList);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  ////////////////////////////
  ///  Search
  ////////////////////////////

  TextEditingController tc;
  List searchSuggestions = [];

  String query = '';
  String queryAbstract = '';
  bool typing = true;

  void setSearchSuggestions(String query) {
    searchSuggestions = searchSuggestionsMap
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

  FocusNode mainFocus;

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

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 60,
              child: Focus(
                onFocusChange: (hasNotFocus) {
                  if (!hasNotFocus) {
                    FocusManager.instance.primaryFocus?.unfocus();
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(color: Colors.black26, width: 1.2),
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
          controller: controller,
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
          itemCount: queryAbstract.isEmpty
              ? list.length + 1 > 50
                  ? 50
                  : list.length + 1
              : (searchSuggestions.length > 5)
                  ? 5
                  : searchSuggestions.length,
          itemBuilder: (context, index) {
            if (index == list.length) {
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
                              ? list[index]['id'] + ".  " + list[index]['g1']
                              : "  " + searchSuggestions[index].name,
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
                                  meta[0]['structure']['meta'][1]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g2'] + "\n"
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
                                  meta[0]['structure']['meta'][2]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g3'] + "\n"
                                      : searchSuggestions[index].director +
                                          "\n",
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
                                  meta[0]['structure']['meta'][6]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g7'] + "\n"
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
                                  meta[0]['structure']['meta'][7]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g8'] + "\n"
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
                                  meta[0]['structure']['meta'][5]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g6'] + "\n"
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
                                  meta[0]['structure']['meta'][3]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g4'] + "\n"
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
                                  meta[0]['structure']['meta'][4]['title_ru'] +
                                      ":  ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  queryAbstract.isEmpty
                                      ? list[index]['g5'] + "\n"
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
