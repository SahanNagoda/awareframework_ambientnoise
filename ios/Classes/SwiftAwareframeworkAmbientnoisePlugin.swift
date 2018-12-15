import Flutter
import UIKit
import com_awareframework_ios_sensor_ambientnoise
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkAmbientnoisePlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, AmbientNoiseObserver {
    
    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.ambientNoiseSensor = AmbientNoiseSensor.init(AmbientNoiseSensor.Config(config))
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
        let instance = SwiftAwareframeworkAmbientnoisePlugin()

        super.setMethodChannel(with: registrar,
                               instance: instance,
                               channelName: "awareframework_ambientnoise/method")
        super.setEventChannels(with: registrar,
                               instance: instance,
                               channelNames: ["awareframework_ambientnoise/event",
                                              "awareframework_ambientnoise/event_on_data_changed"])
    }
    
    public func onAmbientNoiseChanged(data: AmbientNoiseData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
