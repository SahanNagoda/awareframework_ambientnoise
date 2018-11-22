import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_ambientnoise
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkAmbientnoisePlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, AmbientNoiseObserver {
    

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.ambientNoiseSensor = AmbientNoiseSensor.init(AmbientNoiseSensor.Config(json))
            }else{
                self.ambientNoiseSensor = AmbientNoiseSensor.init(AmbientNoiseSensor.Config())
            }
            self.ambientNoiseSensor?.CONFIG.sensorObserver = self
            return self.ambientNoiseSensor
        }else{
            return nil
        }
    }

    var ambientNoiseSensor:AmbientNoiseSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkAmbientnoisePlugin(),
                          methodChannelName: "awareframework_ambientnoise/method",
                          eventChannelName: "awareframework_ambientnoise/event")

    }
    
    public func onAmbientNoiseChanged(data: AmbientNoiseData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
