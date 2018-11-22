import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class AmbientnoiseSensor extends AwareSensorCore {
  static const MethodChannel _ambientnoiseMethod = const MethodChannel('awareframework_ambientnoise/method');
  static const EventChannel  _ambientnoiseStream  = const EventChannel('awareframework_ambientnoise/event');

  /// Init Ambientnoise Sensor with AmbientnoiseSensorConfig
  AmbientnoiseSensor(AmbientnoiseSensorConfig config):this.convenience(config);
  AmbientnoiseSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_ambientnoiseMethod, _ambientnoiseStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onAmbientNoiseChanged {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class AmbientnoiseSensorConfig extends AwareSensorConfig{
  AmbientnoiseSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class AmbientnoiseCard extends StatefulWidget {
  AmbientnoiseCard({Key key, @required this.sensor}) : super(key: key);

  AmbientnoiseSensor sensor;

  @override
  AmbientnoiseCardState createState() => new AmbientnoiseCardState();
}


class AmbientnoiseCardState extends State<AmbientnoiseCard> {

  String ambientInfo = "---";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onAmbientNoiseChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          ambientInfo = event.toString();
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text(ambientInfo),
        ),
      title: "Ambient Noise",
      sensor: widget.sensor
    );
  }

}
