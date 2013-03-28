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
@property (strong, nonatomic) NSDictionary *answerByCategoryDictionary;

- (NSArray *)flashcardPathsOfCategory:(NSString *)category;

@end

@implementation EVFlashcardCollection

@synthesize flashcardPathsByCategory = _flashcardPathsByCategory;
@synthesize answerByCategoryDictionary = _answerByCategoryDictionary;

- (NSDictionary *)answerByCategoryDictionary
{
    if (!_answerByCategoryDictionary)
    {
		NSError * error;
        NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer"
                                                                                                   ofType:@"json"]
                                                          encoding:NSUTF8StringEncoding
                                                             error:&error];
        _answerByCategoryDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:NSJSONReadingMutableLeaves
                                                                        error:&error];
    }
    return _answerByCategoryDictionary;
}

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

- (NSString *)answerAtIndex:(int)index
                 ofCategory:(NSString *)category
{
    return [(NSArray *)[self.answerByCategoryDictionary objectForKey:category] objectAtIndex:index];
}

@end
