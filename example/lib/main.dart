import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_ambientnoise/awareframework_ambientnoise.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AmbientNoiseSensor sensor;
  AmbientNoiseSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = AmbientNoiseSensorConfig()
      ..dbType = DatabaseType.DEFAULT
      ..dbHost = "node.awareframework.com:1001"
      ..debug = true;

    sensor = new AmbientNoiseSensor.init(config);

    sensor.start();
  }

  void sync(){
    sensor.sync(force: true);
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: new AmbientNoiseCard(sensor: sensor,),
        floatingActionButton: new FloatingActionButton(
          onPressed: sync,
          tooltip: 'Refresh',
          child: new Icon(Icons.sync),
        ),
      ),
    );
  }
}
