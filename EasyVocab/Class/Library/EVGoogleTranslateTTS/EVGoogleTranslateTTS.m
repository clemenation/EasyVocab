//
//  EVGoogleTranslateTTS.m
//  EasyVocab
//
//  Created by Dung Nguyen on 3/31/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "EVGoogleTranslateTTS.h"
#import "ASIHTTPRequest.h"
#import "EVSoundPlayer.h"

@interface EVGoogleTranslateTTS()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (void)playAudioData:(NSData *)data;
- (ASIHTTPRequest *)makeRequest;

@end

@implementation EVGoogleTranslateTTS

@synthesize language = _language;
@synthesize content = _content;
@synthesize audioPlayer = _audioPlayer;

#pragma mark - Setters/getters

- (AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer)
    {
        _audioPlayer = [[AVAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

#pragma mark - Class methods

- (id)initWithLanguage:(NSString *)language
{
    if (self = [super init])
    {
        self.language = language;
    }
    return self;
}

- (id)initWithLanguage:(NSString *)language
            andContent:(NSString *)content
{
    if (self = [self initWithLanguage:language])
    {
        self.content = content;
    }
    return self;
}

- (void)startSynchronous
{
    ASIHTTPRequest *request = [self makeRequest];
    [request startSynchronous];
    
    NSError *error = request.error;
    
    if (error)
    {
        NSLog(@"ERROR: %@", error);
    }
    else
    {
        [self playAudioData:request.responseData];
    }
}

- (void)startAsynchronous
{
    __weak ASIHTTPRequest *request = [self makeRequest];
    [request setCompletionBlock:^{
        [self playAudioData:request.responseData];
    }];
    [request startAsynchronous];
}

- (void)playAudioData:(NSData *)data
{
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 1.0f;
    [self.audioPlayer prepareToPlay];
    
    if (self.audioPlayer == nil)
        NSLog(@"%@", [error description]);
    else
        [self.audioPlayer play];    
}

- (ASIHTTPRequest *)makeRequest
{
    NSString* resourcePath = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=%@&q=%@",
                              self.language,
                              self.content]; //your url
    resourcePath = [resourcePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:resourcePath]];
    [request addRequestHeader:@"User-Agent"
                        value:@"Mozilla/5.0"];
    
    return request;
}

@end
