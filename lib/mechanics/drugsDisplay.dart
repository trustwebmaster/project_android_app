import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmifind/mechanics/services.dart';
import '../roadAngels/locations.dart';
import '../roadAngels/pharmacy_services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:pharmifind/requestService.dart';

class DrugDisplay extends StatefulWidget {
  DrugDisplay() : super();

  final String title = 'Certified Mechanics';

  @override
  DrugDisplayState createState() => DrugDisplayState();
}

class DrugDisplayState extends State<DrugDisplay> {
  final LocalStorage storage = LocalStorage('pharmifind');
  Size deviceSize;
  List<Pharmacy> _mechanics;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  LocationData userLocation;
  var location = Location();
  String _errorMsg;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String name = "";
  String surname = "";
  String phoneNumber = "";
  var res;

  @override
  void initState() {
    super.initState();
    _mechanics = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    this.name = storage.getItem('name');
    this.surname = storage.getItem('surname');
    this.phoneNumber = storage.getItem('phoneNumber');
    _getMechanics();
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  Future<LocationData> _getLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  void postUserData(String latitude, String longitude) {
    print(
        '\n\n\n\n-------------------------------------------------------------');
    print(surname);
    print(phoneNumber);
    print(name);
    print(latitude);
    print(longitude);
    print('-------------------------\n\n\n\n');

    RequestService.request(phoneNumber, name, surname, latitude, longitude)
        .then((resp) {
      setState(() {
        this.res = resp;
      });

      if (res == "success") {
        Navigator.pop(context);
      } else {
        this._errorMsg = "Failed to submit request";
        print('Failed');
      }
    });
  }

  void _getMechanics() {
    Services.getMechanics().then((mechanics) {
      setState(() {
        _mechanics = mechanics;
      });
      _showProgress(widget.title);
      print(mechanics);
      print("Length ${mechanics.length}");
    });
  }

  void _showDialog(Pharmacy pharmacy) {
    final marker = Marker(
        markerId: MarkerId(pharmacy.name),
        position:
            LatLng(double.parse(pharmacy.lat), double.parse(pharmacy.long)),
        infoWindow: InfoWindow(
          title: pharmacy.name,
          snippet: pharmacy.address,
        ),
        onTap: () {
          postUserData(userLocation.latitude.toString(),
              userLocation.longitude.toString());
        });
    setState(() {
      markers[MarkerId(pharmacy.name)] = marker;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mechanic Location"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(-17.824858, 31.053028),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
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

  Widget descStack(Pharmacy pharmacy) => Positioned(
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
                    pharmacy.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _dataBody() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('$position'),
              ),
              title: Text(_mechanics[position].name),
              subtitle: Text(_mechanics[position].address),
              trailing: Icon(
                Icons.directions,
                color: Colors.blue[900],
                size: 28.0,
              ),
              onTap: () => _showDialog(_mechanics[position]),
            ),
          );
        },
        itemCount: _mechanics.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(
          child: Text(
            _titleProgress,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getMechanics();
            },
          )
        ],
      ),
      body: Stack(children: <Widget>[
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
                    Colors.blue[900].withOpacity(0.5),
                    Colors.blue[900].withOpacity(0.9),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(),
              Expanded(
                child: _dataBody(),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
