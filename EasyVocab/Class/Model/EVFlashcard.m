//
//  EVFlashcard.m
//  EasyVocab
//
//  Created by Dung Nguyen on 5/3/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcard.h"

@implementation EVFlashcard

- (UIImage *)image
{
    return [UIImage imageWithContentsOfFile:self.imagePath];
}

- (id)initWithAnswer:(NSString *)answer
        andImagePath:(NSString *)imagePath
   andPronounciation:(NSString *)pronounciation
{
    if (self = [super init])
    {
        self.answer = answer;
        self.imagePath = imagePath;
        self.pronounciation = pronounciation;
    }
    return self;
}

@end
