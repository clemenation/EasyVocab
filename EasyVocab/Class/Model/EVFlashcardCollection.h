//
//  EVFlashcardCollection.h
//  EasyVocab
//
//  Created by Dung Nguyen on 3/28/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVFlashcardCollection : NSObject

- (int)numberOfFlashcardInCategory:(NSString *)category;
- (NSString *)flashcardPathAtIndex:(int)index
                        ofCategory:(NSString *)category;
- (NSString *)answerAtIndex:(int)index
                 ofCategory:(NSString *)category;

@end
