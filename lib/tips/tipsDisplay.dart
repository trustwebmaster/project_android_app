// import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pharmifind/requestService.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';

class TipsDisplay extends StatefulWidget {
  TipsDisplay() : super();

  final String title = 'Mechanical Tips';

  @override
  TipsDisplayState createState() => TipsDisplayState();
}

class TipsDisplayState extends State<TipsDisplay> {
  final LocalStorage storage = LocalStorage('pharmifind');
  Size deviceSize;

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
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    this.name = storage.getItem('name');
    this.surname = storage.getItem('surname');
    this.phoneNumber = storage.getItem('phoneNumber');

    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
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

  Future<LocationData> _getLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Widget descStack() => Positioned(
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
                    'TIPS',
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

  void _showDialog(String advice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mechanical Tips"),
          content: SizedBox(height: 300, width: 300, child: Text(advice)),
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
              title: Text('Tire Puncture'),
              trailing: Icon(
                Icons.remove_red_eye,
                color: Colors.blue[900],
                size: 28.0,
              ),
              onTap: () => _showDialog('Always have a spare tire'),
            ),
          );
        },
        itemCount: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    setState(() {
      this.name = storage.getItem('name');
      this.surname = storage.getItem('surname');
      this.phoneNumber = storage.getItem('phoneNumber');
    });
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
