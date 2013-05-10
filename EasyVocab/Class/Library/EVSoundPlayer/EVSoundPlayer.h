//
//  EVSoundPlayer.h
//  EasyVocab
//
//  Created by Dung Nguyen on 5/10/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVSoundPlayer : NSObject

@property (assign, nonatomic) CGFloat volume;

+ (EVSoundPlayer *)sharedSoundPlayer;
+ (void)setGlobalVolume:(CGFloat)globalVolume;
+ (EVSoundPlayer *)backgroundMusicPlayer;
+ (void)setBackgroundMusicVolume:(CGFloat)volume;

+ (CGFloat)globalVolume;
- (void)playData:(NSData *)data;
- (void)playData:(NSData *)data
   numberOfLoops:(NSInteger)loops;
- (void)playFile:(NSString *)file
          ofType:(NSString *)type;
- (void)playFile:(NSString *)file
          ofType:(NSString *)type
   numberOfLoops:(NSInteger)loops;
+ (void)playClickSound;
+ (void)playBackgroundMusic;

@end
