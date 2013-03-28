//
//  EVFlashcardCollection.m
//  EasyVocab
//
//  Created by Dung Nguyen on 3/28/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardCollection.h"

@interface EVFlashcardCollection()

@property (strong, nonatomic) NSMutableDictionary *flashcardPathsByCategory;

- (NSArray *)flashcardPathsOfCategory:(NSString *)category;

@end

@implementation EVFlashcardCollection

@synthesize flashcardPathsByCategory = _flashcardPathsByCategory;

- (int)numberOfFlashcardInCategory:(NSString *)category
{
    return ((NSArray *)[self flashcardPathsOfCategory:category]).count;
}

- (NSString *)flashcardPathAtIndex:(int)index
                        ofCategory:(NSString *)category
                              
{
    return [(NSArray *)[self flashcardPathsOfCategory:category] objectAtIndex:index];
}

- (NSArray *)flashcardPathsOfCategory:(NSString *)category
{
    NSArray *flashcardPaths = [self.flashcardPathsByCategory objectForKey:category];
    
    if (!flashcardPaths)
    {
        flashcardPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg"
                                                            inDirectory:category];        
        [self.flashcardPathsByCategory setObject:flashcardPaths
                                          forKey:category];
    }
    
    return flashcardPaths;
}

@end
