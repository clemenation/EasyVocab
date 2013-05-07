//
//  EVFlashcardCollection.m
//  EasyVocab
//
//  Created by Dung Nguyen on 3/28/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardCollection.h"

@interface EVFlashcardCollection()

@property (strong, nonatomic) NSArray *flashcards;      // of EVFlashcard

+ (NSArray *)imagePathsOfCategory:(NSString *)category;
+ (NSArray *)answersOfCategory:(NSString *)category;
+ (NSArray *)flashcardsOfCategory:(NSString *)category;
+ (NSDictionary *)answerByCategoryDictionary;

- (NSArray *)shuffle:(NSArray *)array;

@end

@implementation EVFlashcardCollection

@synthesize category = _category;

- (NSUInteger)count
{
    return self.flashcards.count;
}

- (void)setCategory:(NSString *)category
{
    if (_category != category)
    {
        _category = category;
        self.flashcards = [EVFlashcardCollection flashcardsOfCategory:_category];
    }
}

- (id)initWithCategory:(NSString *)category
{
    if (self = [super init])
    {
        self.category = category;
    }
    return self;
}

- (NSArray *)shuffle:(NSArray *)array
{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (int i=0; i<array.count-1; i++)
    {
        int remain = array.count - (i + 1);
        int randPos = (i + 1) + (arc4random() % remain);
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:randPos];
    }
    return mutableArray;
}

- (void)shuffle
{
    NSMutableArray *flashcards = [self.flashcards mutableCopy];
    for (int i=0; i<flashcards.count-1; i++)
    {
        int remain = flashcards.count - (i + 1);
        int randPos = (i + 1) + (arc4random() % remain);
        [flashcards exchangeObjectAtIndex:i withObjectAtIndex:randPos];
    }
    self.flashcards = flashcards;
}

- (NSArray *)choicesForAnswerAtIndex:(NSUInteger)index
{
    NSMutableArray *choices = [NSMutableArray arrayWithCapacity:4];
    [choices addObject:[self answerAtIndex:index]]; // first choice is right choice
    NSMutableArray *flashcards = [NSMutableArray arrayWithArray:self.flashcards];
    [flashcards removeObjectAtIndex:index];
    flashcards = [[self shuffle:(NSArray *)flashcards] mutableCopy];
    for (int i=0; i<3; i++)
    {
        [choices addObject:((EVFlashcard *)[flashcards objectAtIndex:i]).answer];
    }
    return [self shuffle:choices];
}

- (EVFlashcard *)flashcardAtIndex:(NSUInteger)index
{
    if (index < self.flashcards.count)
    {
        return [self.flashcards objectAtIndex:index];
    }
    return nil;
}

- (NSString *)imagePathAtIndex:(NSUInteger)index
{
    if (index < self.flashcards.count)
    {
        return [self flashcardAtIndex:index].imagePath;
    }
    return nil;
}

- (NSString *)answerAtIndex:(NSUInteger)index
{
    if (index < self.flashcards.count)
    {
        return [self flashcardAtIndex:index].answer;
    }
    return nil;
}

+ (NSArray *)flashcardsOfCategory:(NSString *)category
{
    NSArray *answers = [EVFlashcardCollection answersOfCategory:category];
    NSArray *imagePaths = [EVFlashcardCollection imagePathsOfCategory:category];
    NSMutableArray *flashcards = [NSMutableArray arrayWithCapacity:answers.count];
    
    for (int i=0; i<answers.count; i++)
    {
        EVFlashcard *flashcard = [[EVFlashcard alloc] initWithAnswer:[answers objectAtIndex:i] andImagePath:[imagePaths objectAtIndex:i]];
        [flashcards addObject:flashcard];
    }
    return flashcards;
}

+ (NSDictionary *)answerByCategoryDictionary
{
    NSError * error;
    NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer"
                                                                                               ofType:@"json"]
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
    NSDictionary *answerByCategoryDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableLeaves
                                                                                 error:&error];
    return answerByCategoryDictionary;
}

+ (NSArray *)answersOfCategory:(NSString *)category
{
    return [[EVFlashcardCollection answerByCategoryDictionary] objectForKey:category];
}

+ (NSString *)answerAtIndex:(int)index
                 ofCategory:(NSString *)category
{
    NSArray *answers = [EVFlashcardCollection answersOfCategory:category];
    if (index >= 0 && index <= answers.count)
    {
        return [answers objectAtIndex:index];
    }
    return nil;
}

+ (int)numberOfFlashcardInCategory:(NSString *)category
{
    return ((NSArray *)[EVFlashcardCollection imagePathsOfCategory:category]).count;
}

+ (NSString *)flashcardPathAtIndex:(int)index
                        ofCategory:(NSString *)category
                              
{
    NSArray *paths = [self imagePathsOfCategory:category];
    if (index >= 0 && index <= paths.count)
    {
        return [paths objectAtIndex:index];
    }
    return nil;
}

+ (NSArray *)imagePathsOfCategory:(NSString *)category;
{
    return [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg"
                                              inDirectory:category];
}

@end
