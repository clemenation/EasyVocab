//
//  EVFlashcard.h
//  EasyVocab
//
//  Created by Dung Nguyen on 5/3/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVFlashcard : NSObject

@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *pronounciation;
@property (readonly, nonatomic) UIImage *image;

- (id)initWithAnswer:(NSString *)answer
        andImagePath:(NSString *)imagePath
   andPronounciation:(NSString *)pronounciation;

@end
