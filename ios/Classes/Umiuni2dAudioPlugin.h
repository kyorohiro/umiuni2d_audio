#import <Flutter/Flutter.h>
#import <AVFoundation/AVFoundation.h>
@interface Umiuni2dAudioPlugin : NSObject<FlutterPlugin>
@property (nonatomic, strong) AVAudioPlayer* player;
@end
