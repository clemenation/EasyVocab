//
//  EVSoundPlayer.m
//  EasyVocab
//
//  Created by Dung Nguyen on 5/10/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "EVSoundPlayer.h"

static EVSoundPlayer    *_sharedSoundPlayer;
static CGFloat          _globalVolume = 1.0f;
static EVSoundPlayer    *_backgroundMusicPlayer;
static CGFloat          _backgroundMusicVolume = 1.0f;

@interface EVSoundPlayer()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation EVSoundPlayer

#pragma mark - Setters/getters

+ (EVSoundPlayer *)backgroundMusicPlayer
{
    if (!_backgroundMusicPlayer)
    {
        _backgroundMusicPlayer = [[EVSoundPlayer alloc] init];
    }
    return _backgroundMusicPlayer;
}

+ (void)setBackgroundMusicVolume:(CGFloat)volume
{
    if (volume >= 0.0f && volume <= 1.0f)
    {
        _backgroundMusicVolume = volume;
        [EVSoundPlayer backgroundMusicPlayer].volume = _backgroundMusicVolume;
    }
}

+ (EVSoundPlayer *)sharedSoundPlayer
{
    if (!_sharedSoundPlayer)
    {
        _sharedSoundPlayer = [[EVSoundPlayer alloc] init];
    }
    return _sharedSoundPlayer;
}

+ (void)setGlobalVolume:(CGFloat)globalVolume
{
    if (globalVolume >= 0.0f && globalVolume <= 1.0f)
    {
        _globalVolume = globalVolume;
        [EVSoundPlayer sharedSoundPlayer].volume = _globalVolume;
    }
}
+ (CGFloat)globalVolume
{
    return _globalVolume;
}

- (void)setVolume:(CGFloat)volume
{
    if (volume >= 0.0f && volume <= 1.0f)
    {
        _volume = volume;
        self.audioPlayer.volume = _volume;
    }
}

#pragma mark - Class methods

- (id)init
{
    if (self = [super init])
    {
        self.volume = [EVSoundPlayer globalVolume];
    }
    return self;
}

- (void)playData:(NSData *)data
{
    [self playData:data numberOfLoops:0];
}

- (void)playData:(NSData *)data
   numberOfLoops:(NSInteger)loops
{
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data
                                                     error:&error];
    self.audioPlayer.numberOfLoops = loops;
    self.audioPlayer.volume = self.volume;
    [self.audioPlayer prepareToPlay];
    
    if (self.audioPlayer == nil)
        NSLog(@"%@", [error description]);
    else
        [self.audioPlayer play];
}

- (void)playFile:(NSString *)file
          ofType:(NSString *)type
{
    [self playFile:file ofType:type numberOfLoops:0];
}

- (void)playFile:(NSString *)file
          ofType:(NSString *)type
   numberOfLoops:(NSInteger)loops
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self playData:data numberOfLoops:loops];
}

+ (void)playClickSound
{
    [[EVSoundPlayer sharedSoundPlayer] playFile:@"click" ofType:@"m4a"];
}

+ (void)playBackgroundMusic
{
    [[EVSoundPlayer backgroundMusicPlayer] playFile:@"music"
                                             ofType:@"m4a"
                                      numberOfLoops:-1];
}

@end
