/********* BatteryStatus.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface BatteryStatus : CDVPlugin {
    // Member variables go here.
    UIDeviceBatteryState state;
    float level;
    bool isPlugged;
    NSString* callbackId;
}
@property (nonatomic) UIDeviceBatteryState state;
@property (nonatomic) float level;
@property (nonatomic) bool isPlugged;
@property (strong) NSString* callbackId;

- (void)isPlugged:(CDVInvokedUrlCommand*)command;
- (void)getLevel:(CDVInvokedUrlCommand*)command;
@end

@implementation BatteryStatus

@synthesize state, level, callbackId, isPlugged;

- (void)isPlugged:(CDVInvokedUrlCommand*)command
{
    @try {
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];

        int state = [myDevice batteryState];
        // 0 unknown, 1 unplegged, 2 charging, 3 full

     
        NSString * pluggedResult = @"";
        if (state == 0) {
            pluggedResult = @"unknown";
        } else if (state == 1) {
            pluggedResult = @"unplugged";
        } else if (state == 2) {
            pluggedResult = @"charging";
        } else {
            pluggedResult = @"full";
        }
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pluggedResult];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
    } @catch (NSException *exception) {
        CDVPluginResult* result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: exception.reason];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

- (void)getLevel:(CDVInvokedUrlCommand*)command
{
    @try {
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        
        double batLeft = (float)[myDevice batteryLevel] * 100;
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%ld", batLeft]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
    } @catch (NSException *exception) {
        CDVPluginResult* result =  [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: exception.reason];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

@end



