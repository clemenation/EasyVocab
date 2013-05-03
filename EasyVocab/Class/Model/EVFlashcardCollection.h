//
//  EVFlashcardCollection.h
//  EasyVocab
//
//  Created by Dung Nguyen on 3/28/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVFlashcard.h"

@interface EVFlashcardCollection : NSObject

@property (strong, nonatomic) NSString      *category;
@property (readonly, nonatomic) NSUInteger  count;

- (id)initWithCategory:(NSString *)category;
- (void)shuffle;
- (EVFlashcard *)flashcardAtIndex:(NSUInteger)index;
- (NSString *)imagePathAtIndex:(NSUInteger)index;
- (NSString *)answerAtIndex:(NSUInteger)index;

+ (int)numberOfFlashcardInCategory:(NSString *)category;
+ (NSString *)flashcardPathAtIndex:(int)index
                        ofCategory:(NSString *)category;
+ (NSString *)answerAtIndex:(int)index
                 ofCategory:(NSString *)category;

@end
