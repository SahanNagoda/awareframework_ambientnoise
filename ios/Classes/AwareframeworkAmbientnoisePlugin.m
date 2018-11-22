#import "AwareframeworkAmbientnoisePlugin.h"
#import <awareframework_ambientnoise/awareframework_ambientnoise-Swift.h>

@implementation AwareframeworkAmbientnoisePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkAmbientnoisePlugin registerWithRegistrar:registrar];
}
@end
