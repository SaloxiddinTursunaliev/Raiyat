import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';

class ATM {
  int id;
  String title;
  String phone;
  double lat;
  double long;

  ATM({
    this.id,
    this.title,
    this.phone,
    this.lat,
    this.long,
  });

  factory ATM.fromJson(Map<String, dynamic> parsedJson) {
    return ATM(
      id: parsedJson['id'] as int,
      title: parsedJson['title'] as String,
      phone: parsedJson['phone'] as String,
      lat: parsedJson['lat'] as double,
      long: parsedJson['long'] as double,
    );
  }
}

class Banklar extends StatefulWidget {
  Banklar({
    Key key,
  }) : super(key: key);

  @override
  _BanklarState createState() => _BanklarState();
}

class _BanklarState extends State<Banklar> {
  @override
  void initState() {
    super.initState();
    getData();
    getKnownLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScrollController _controller = new ScrollController();
  static List<ATM> atmMap;

  List list = new List();
  bool loading = false;

  List<LatLng> _markersAll = [];
  List<LatLng> _markersAlone = [];

  double curLatitude;
  double curLongitude;

  Position currentLocation;

  bool showAll = true;

  getKnownLocation() async {
    try {
      //currentLocation = await Geolocator.getCurrentPosition(
      currentLocation = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true);

      setState(() {
        curLatitude = currentLocation.latitude;
        curLongitude = currentLocation.longitude;
      });
    } catch (e) {}
  }

  getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      curLatitude = currentLocation.latitude;
      curLongitude = currentLocation.longitude;
    });
  }

  List sort = new List();
  double distances = 0;

  void getData() async {
    if (!loading) {
      try {
        setState(() {
          loading = true;
        });

        String jsonString = await rootBundle.loadString('assets/ATM.json');

        final jsonData = json.decode(jsonString);

        atmMap = new List<ATM>();

        for (int i = 0; i < jsonData.length; i++) {
          atmMap.add(new ATM.fromJson(jsonData[i]));
          _markersAll.add(
            LatLng(atmMap[i].lat, atmMap[i].long),
          );
        }

        setState(() {
          loading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  double selectedLat;
  double selectedLong;
  String selectedName;
  double distance = 0;

  aaa() async {
    final addresses = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(22.33, 33.22));

    print(addresses.first);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildProgressIndicator() {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
          child: new Opacity(
            opacity: loading ? 1.0 : 00,
            child: new CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 320,
            ),
            height: 320,
            child: new FlutterMap(
              options: new MapOptions(
                center: LatLng(41.316938, 69.282235),
                zoom: 12.3,
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                new MarkerLayerOptions(
                  markers: [
                    Marker(
                      point: LatLng(41.33587511427566, 69.28612793633908),
                      // point: LatLng(
                      //     currentLocation.latitude, currentLocation.longitude),
                      width: 120.0,
                      height: 70.0,
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      builder: (BuildContext context) {
                        return const Icon(
                          Icons.location_on,
                          size: 55.0,
                          color: Colors.red,
                        );
                      },
                    ),
                  ],
                ),
                showAll
                    ? new MarkerLayerOptions(
                        markers: _markersAll.map(
                          (point) {
                            return Marker(
                              point: point,
                              width: 120.0,
                              height: 70.0,
                              anchorPos: AnchorPos.align(AnchorAlign.center),
                              builder: (BuildContext context) {
                                return Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0.0,
                                      child: const Icon(
                                        Icons.location_on,
                                        size: 55.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.0,
                                      child: Container(
                                        color: Colors.white,
                                        child: Text("ATM"),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ).toList(),
                      )
                    : new MarkerLayerOptions(
                        markers: [
                          Marker(
                            point: LatLng(selectedLat, selectedLong),
                            width: 120.0,
                            height: 70.0,
                            anchorPos: AnchorPos.align(AnchorAlign.center),
                            builder: (BuildContext context) {
                              return Stack(
                                children: [
                                  Positioned(
                                    bottom: 0.0,
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 55.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0.0,
                                    child: Container(
                                      color: Colors.white,
                                      child: Text(selectedName),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
          !showAll
              ? ListView(
                  controller: _controller,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 7.5, left: 15, right: 7.5),
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
                      child: Text(
                        "Sizdan " +
                            ((distance / 1000).toStringAsFixed(2)) +
                            " km. uzoqlikda",
                        style: TextStyle(
                          color: Colors.black54,
                          //color: Color.fromARGB(255, 7, 50, 100),
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          ListView(
            controller: _controller,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 7.5, left: 15, right: 7.5),
            children: [
              Container(
                margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showAll = true;
                    });
                  },
                  child: Text(
                    "Barcha ATM lar",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 50, 100),
                      fontSize: 21.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 2),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              padding:
                  EdgeInsets.only(top: 7.5, left: 7.5, right: 7.5, bottom: 7.5),
              itemCount: atmMap.length + 1,
              itemBuilder: (context, index) {
                if (index == atmMap.length) {
                  return _buildProgressIndicator();
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: 11, bottom: 11),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showAll = false;
                        });

                        setState(() {
                          distance = Geolocator.distanceBetween(
                            41.33587511427566,
                            69.28612793633908,
                            atmMap[index].lat,
                            atmMap[index].long,
                          );

                          _markersAlone.clear();
                          _markersAlone.add(
                              LatLng(atmMap[index].lat, atmMap[index].long));
                          selectedLat = atmMap[index].lat;
                          selectedLong = atmMap[index].long;
                          selectedName = atmMap[index].title;

                          // curLatitude = currentLocation.latitude;
                          // curLongitude = currentLocation.longitude;
                        });
                        aaa();
                      },
                      child: Text(
                        "  " +
                            atmMap[index].id.toString() +
                            ".  " +
                            atmMap[index].title,
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 50, 100),
                          fontSize: 21.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
