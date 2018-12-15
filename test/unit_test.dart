import 'package:test/test.dart';
import 'package:awareframework_ambientnoise/awareframework_ambientnoise.dart';

void main(){
  test("test sensor config", (){
    var config = AmbientNoiseSensorConfig();
    expect(config.deviceId, "");
    expect(config.debug, false);
  });
}