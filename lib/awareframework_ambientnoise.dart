import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class AmbientNoiseSensor extends AwareSensorCore {
  static const MethodChannel _ambientNoiseMethod = const MethodChannel('awareframework_ambientnoise/method');
  static const EventChannel  _ambientNoiseStream  = const EventChannel('awareframework_ambientnoise/event');

  AmbientNoiseSensor(AmbientNoiseSensorConfig config):this.convenience(config);
  AmbientNoiseSensor.convenience(config) : super(config){
    super.setMethodChannel(_ambientNoiseMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onAmbientNoiseChanged {
    return super.getBroadcastStream(_ambientNoiseStream, "on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }
}

class AmbientNoiseSensorConfig extends AwareSensorConfig{
  AmbientNoiseSensorConfig({Key key, this.interval, this.samples, this.silenceThreshold});

  // Int: Sampling interval in minute. (default = 5)
  int interval;

  // Int: Data samples to collect per minute. (default = 30)
  int samples;

  //  Double: A threshold of RMS for determining silence or not. (default = 50)
  double silenceThreshold;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class AmbientNoiseCard extends StatefulWidget {
  AmbientNoiseCard({Key key, @required this.sensor}) : super(key: key);

  final AmbientNoiseSensor sensor;

  String ambientInfo = "---";

  @override
  AmbientNoiseCardState createState() => new AmbientNoiseCardState();
}


class AmbientNoiseCardState extends State<AmbientNoiseCard> {

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onAmbientNoiseChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          widget.ambientInfo = event.toString();
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
          child: new Text(widget.ambientInfo),
        ),
      title: "Ambient Noise",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
