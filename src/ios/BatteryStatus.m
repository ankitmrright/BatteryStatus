/********* BatteryStatus.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface BatteryStatus : CDVPlugin {
    // Member variables go here.
    UIDeviceBatteryState state;
    float level;
    bool isPlugged;
    NSString* callbackId;
    
    @property (nonatomic) UIDeviceBatteryState state;
    @property (nonatomic) float level;
    @property (nonatomic) bool isPlugged;
    @property (strong) NSString* callbackId;
}

- (void)isPlugged:(CDVInvokedUrlCommand*)command;
- (void)getLevel:(CDVInvokedUrlCommand*)command;
@end

@implementation BatteryStatus

@synthesize state, level, callbackId, isPlugged;

- (void)isPlugged:(CDVInvokedUrlCommand*)command
{
    @try {
        UIDevice *myDevice = [UIDevice currentDevice]; UIDevice* currentDevice = [UIDevice currentDevice];
        UIDeviceBatteryState currentState = [currentDevice batteryState];
        
        isPlugged = FALSE; // UIDeviceBatteryStateUnknown or UIDeviceBatteryStateUnplugged
        if ((currentState == UIDeviceBatteryStateCharging) || (currentState == UIDeviceBatteryStateFull)) {
            isPlugged = TRUE;
        }
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@(isPlugged)];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
        
    } @catch (NSException *exception) {
        CDVPluginResult* result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR mes: exception.reason];
    }
}

- (void)getLevel:(CDVInvokedUrlCommand*)command
{
    @try {
        UIDevice *myDevice = [UIDevice currentDevice]; UIDevice* currentDevice = [UIDevice currentDevice];
        UIDeviceBatteryState currentState = [currentDevice batteryState];
        
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
        
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@(w3cLevel)];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
        
    } @catch (NSException *exception) {
        CDVPluginResult* result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR mes: exception.reason];
    }
}

@end



