/********* BatteryStatus.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface BatteryStatus : CDVPlugin {
    // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
- (void)getStatus:(CDVInvokedUrlCommand*)command;
@end

@implementation BatteryStatus

@synthesize state, level, callbackId, isPlugged;

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    
    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)getStatus:(CDVInvokedUrlCommand*)command
{
    @try {
        UIDevice *myDevice = [UIDevice currentDevice]; UIDevice* currentDevice = [UIDevice currentDevice];
        UIDeviceBatteryState currentState = [currentDevice batteryState];
        
        isPlugged = FALSE; // UIDeviceBatteryStateUnknown or UIDeviceBatteryStateUnplugged
        if ((currentState == UIDeviceBatteryStateCharging) || (currentState == UIDeviceBatteryStateFull)) {
            isPlugged = TRUE;
        }
        float currentLevel = [currentDevice batteryLevel];
        
        if ((currentLevel != self.level) || (currentState != self.state)) {
            self.level = currentLevel;
            self.state = currentState;
        }
        
        // W3C spec says level must be null if it is unknown
        NSObject* w3cLevel = nil;
        if ((currentState == UIDeviceBatteryStateUnknown) || (currentLevel == -1.0)) {
            w3cLevel = [NSNull null];
        } else {
            w3cLevel = [NSNumber numberWithFloat:(currentLevel * 100)];
        }
        NSMutableDictionary* batteryData = [NSMutableDictionary dictionaryWithCapacity:2];
        [batteryData setObject:[NSNumber numberWithBool:isPlugged] forKey:@"isPlugged"];
        [batteryData setObject:w3cLevel forKey:@"level"];
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:batteryData];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
        
    } @catch (NSException *exception) {
        CDVPluginResult* result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR mes: exception.reason];
    }
}

@end



