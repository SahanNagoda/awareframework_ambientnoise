import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class AmbientNoiseSensor extends AwareSensor {
  static const MethodChannel _ambientNoiseMethod = const MethodChannel('awareframework_ambientnoise/method');
  static const EventChannel  _ambientNoiseStream  = const EventChannel('awareframework_ambientnoise/event');
  static const EventChannel  _onDataChangedStream  = const EventChannel('awareframework_ambientnoise/event_on_data_changed');

  AmbientNoiseData data = AmbientNoiseData();

  static StreamController<AmbientNoiseData> streamController = StreamController<AmbientNoiseData>();

  AmbientNoiseSensor():this.init(null);
  AmbientNoiseSensor.init(AmbientNoiseSensorConfig config) : super(config){
    super.setMethodChannel(_ambientNoiseMethod);
  }

  /// A sensor observer instance
  Stream<AmbientNoiseData> get onAmbientNoiseChanged {
    streamController.close();
    streamController = StreamController<AmbientNoiseData>();
    return streamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(_onDataChangedStream, "on_data_changed").map(
            (dynamic event) => AmbientNoiseData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      if (!streamController.isClosed) {
        streamController.add(event);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
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

class AmbientNoiseData extends AwareData {
  double frequency = 0.0;
  double decibels  = 0.0;
  double rms       = 0.0;
  bool isSilent    = true;
  AmbientNoiseData():this.from(null);
  AmbientNoiseData.from(Map<String,dynamic> data):super.from(data){
    if(data != null){
      frequency = data["frequency"] ?? 0.0;
      decibels = data["decibels"] ?? 0.0;
      rms = data["rms"] ?? 0.0;
      isSilent  = data["isSilent"] ?? true;
    }
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

    if(mounted){
      setState((){
        updateContent(widget.sensor.data);
      });
    }

    // set observer
    widget.sensor.onAmbientNoiseChanged.listen((event) {
      if(event!=null){
        if(mounted){
          setState((){
            updateContent(event);
          });
        }else{
          updateContent(event);
        }
      }

    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  void updateContent(AmbientNoiseData event){
    DateTime.fromMicrosecondsSinceEpoch(event.timestamp);
    widget.ambientInfo = "Hz:${event.frequency}\nDb:${event.decibels}\nRMS:${event.rms}";
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
}
