#import "Umiuni2dAudioPlugin.h"
#import <AVFoundation/AVFoundation.h>

@implementation Umiuni2dAudioPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"umiuni2d_audio"
            binaryMessenger:[registrar messenger]];
  Umiuni2dAudioPlugin* instance = [[Umiuni2dAudioPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *methodName = call.method;
    if(methodName == nil || [methodName length] == 0) {
        result(FlutterMethodNotImplemented);
    }

    if([methodName isEqualToString:@"getPath"]){
        result(NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0]);
        return;
    }

    NSArray *args = call.arguments;
    NSArray *playerId = args[0];

    if([methodName isEqualToString:@"load"]){
        NSString *path = args[1];
        NSError* error = nil;
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!self.player) {
            result(@"{\"status\":\"failed\"}");
            return;
        } else {
            result(@"{\"status\":\"passed\"}");
            return;
        }
    } else {
        if(!self.player) {
            result(@"{\"status\":\"failed\"}");
            return;
        }
        if([methodName isEqualToString:@"play"]){
            BOOL ret = [self.player play];
            if(!ret) {
                result(@"{\"status\":\"failed\"}");
            } else {
                result(@"{\"status\":\"passed\"}");
            }
            return;
        } else if([methodName isEqualToString:@"pause"]){
            [self.player pause];
            result(@"{\"status\":\"passed\"}");
            return;
        } else if([methodName isEqualToString:@"stop"]){
            [self.player stop];
            result(@"{\"status\":\"passed\"}");
            return;
        } else if([methodName isEqualToString:@"seek"]){
            NSNumber *num = args[1];
            self.player.currentTime = [num doubleValue];
            result(@"{\"status\":\"passed\"}");
            return;
        } else if([methodName isEqualToString:@"getCurentTime"]){
            result([[NSNumber alloc] initWithDouble:self.player.currentTime]);
            return;
        } else if([methodName isEqualToString:@"setVolume"]){
            NSArray *args = call.arguments;
            NSNumber *volume = args[1];
            NSNumber *interval = args[2];
            [self.player setVolume:[volume floatValue] fadeDuration:[interval doubleValue]];
            result(@"{\"status\":\"passed\"}");
            return;
        } else if([methodName isEqualToString:@"getVolume"]){
            result([[NSNumber alloc] initWithDouble:self.player.volume]);
            return;
        }
        
    }
    result(FlutterMethodNotImplemented);
}

@end
