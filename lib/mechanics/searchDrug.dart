import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmifind/roadAngels/locations.dart';
import 'package:pharmifind/roadAngels/pharmacy_services.dart';

import 'services.dart';

class SearchDrug extends StatefulWidget {
  final String title;
  SearchDrug({Key key, @required this.title}) : super(key: key);

  @override
  DrugDisplayState createState() => DrugDisplayState();
}

class DrugDisplayState extends State<SearchDrug> {
  List<Pharmacy> _drugs;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  List<Pharmacy> _searchResult = [];
  List<Pharmacy> _searchPharmResult = [];
  List<Pharmacy> _pharmacies;
  List<Pharmacy> _searchLocResult;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    _getRoadAngels();

    super.initState();
    _drugs = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void onSearchTextChanged(String text) async {
    _searchResult = [];
    _drugs.forEach((drug) {
      if (drug.name.contains(text)) {
        _searchResult.add(drug);
      }
    });

    setState(() {
      _drugs = _searchResult;
    });
  }

  void _getRoadAngels() {
    _showProgress('Loading Drugs...');
    Services.getMechanics().then((drugs) {
      setState(() {
        _drugs = drugs;
      });
      _showProgress(widget.title);
      onSearchTextChanged(widget.title);
    });

    PharmacyService.getPharmacies().then((pharmacies) {
      setState(() {
        _pharmacies = pharmacies;
      });
    });
  }

  void _showDialog(String pharmacyId, Pharmacy drug) {
    _searchLocResult = [];

    _pharmacies.forEach((pharmacy) {
      if (pharmacy.id.contains(pharmacyId)) {
        _searchLocResult.add(pharmacy);
      }
    });

    final marker = Marker(
      markerId: MarkerId(_searchLocResult[0].name),
      position: LatLng(double.parse(_searchLocResult[0].lat),
          double.parse(_searchLocResult[0].long)),
      infoWindow: InfoWindow(
        title: _searchLocResult[0].name,
        snippet: _searchLocResult[0].address,
      ),
    );
    setState(() {
      markers[MarkerId(_searchLocResult[0].name)] = marker;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pharmacy Directions"),
          content: Column(
            children: <Widget>[
              SizedBox(
                height: 300,
                width: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(-17.824858, 31.053028),
                    zoom: 15.0,
                  ),
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
              SizedBox(
                width: 300,
                child: Center(
                  child: Text(
                    '\n\n ' + drug.name + '\n\n \$' + drug.address,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget imageStack() => Image.asset(
        "assets/images/pill.jpg",
        fit: BoxFit.cover,
      );

  //stack3
  Widget distanceStack(String pharmacyId, double rating) {
    _searchPharmResult = [];

    _pharmacies.forEach((pharmacy) {
      if (pharmacy.id.contains(pharmacyId)) {
        _searchPharmResult.add(pharmacy);
      }
    });

    print(_searchPharmResult[0].name);

    return Positioned(
      top: 0.0,
      left: 0.0,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.blue[900].withOpacity(0.9),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.yellow,
              size: 10.0,
            ),
            SizedBox(
              width: 2.0,
            ),
            Text(
              _searchPharmResult[0].name,
              style: TextStyle(color: Colors.white, fontSize: 7.0),
            )
          ],
        ),
      ),
    );
  }

  Widget descStack(Pharmacy drug) => Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[900].withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    drug.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(drug.address,
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      );

  Widget _dataBody() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.builder(
        itemBuilder: (context, position) {
          return InkWell(
            onTap: () => _showDialog(_drugs[position].name, _drugs[position]),
            child: Card(
              elevation: 10.0,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    imageStack(),
                    descStack(_drugs[position]),
                    distanceStack(_drugs[position].name, 4.0)
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: _drugs.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(
          child: Text(
            'Search Results for ' + _titleProgress,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getRoadAngels();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/pills.jpg',
                ),
              ),
            ),
            height: deviceSize.height,
          ),
          Container(
            height: deviceSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.orange[600].withOpacity(0.8),
                  Colors.blue[900].withOpacity(0.8),
                  Colors.blue[900].withOpacity(0.9),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(),
                Expanded(
                  child: _drugs.isNotEmpty
                      ? _dataBody()
                      : Center(
                          child: Text(
                            'Road Angel ' + widget.title + ' Not Found',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
