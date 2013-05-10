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
+ (NSArray *)pronounciationsOfCategory:(NSString *)category;
+ (NSArray *)flashcardsOfCategory:(NSString *)category;
+ (NSDictionary *)answerWithPronounciationByCategoryDictionary;

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
    NSArray *pronounciations = [EVFlashcardCollection pronounciationsOfCategory:category];
    NSMutableArray *flashcards = [NSMutableArray arrayWithCapacity:answers.count];
    
    for (int i=0; i<answers.count; i++)
    {
        EVFlashcard *flashcard = [[EVFlashcard alloc] initWithAnswer:[answers objectAtIndex:i] andImagePath:[imagePaths objectAtIndex:i]
                                                   andPronounciation:[pronounciations objectAtIndex:i]];
        [flashcards addObject:flashcard];
    }
    return flashcards;
}

+ (NSDictionary *)answerWithPronounciationByCategoryDictionary
{
    NSError * error;
    NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answerWithPronounciation"
                                                                                               ofType:@"json"]
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
    NSDictionary *answerWithPronounciationByCategoryDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableLeaves
                                                                                 error:&error];
    
//    NSMutableDictionary *newAnswerByCategoryDictionary = [NSMutableDictionary dictionaryWithCapacity:answerByCategoryDictionary.count];
//    [answerByCategoryDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSArray *answers = obj;
//        NSString *category = key;
//        
//        NSMutableArray *newAnswers = [NSMutableArray arrayWithCapacity:answers.count];
//        for (NSString *answer in answers)
//        {
//            NSArray *answerObject = [NSArray arrayWithObjects:answer, @"pronounciation", nil];
//            [newAnswers addObject:answerObject];
//        }
//        [newAnswerByCategoryDictionary setObject:newAnswers forKey:category];
//    }];
//    NSData *data = [NSJSONSerialization dataWithJSONObject:newAnswerByCategoryDictionary
//                                                   options:0
//                                                     error:&error];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    return answerWithPronounciationByCategoryDictionary;
}

+ (NSArray *)pronounciationsOfCategory:(NSString *)category
{
    NSArray *answerPronounciation = [[EVFlashcardCollection answerWithPronounciationByCategoryDictionary] objectForKey:category];
    NSMutableArray *pronounciations = [NSMutableArray arrayWithCapacity:answerPronounciation.count];
    for (NSArray *obj in answerPronounciation)
    {
        [pronounciations addObject:[obj objectAtIndex:1]];
    }
    return pronounciations;
}

+ (NSArray *)answersOfCategory:(NSString *)category
{
    NSArray *answerPronounciation = [[EVFlashcardCollection answerWithPronounciationByCategoryDictionary] objectForKey:category];
    NSMutableArray *answers = [NSMutableArray arrayWithCapacity:answerPronounciation.count];
    for (NSArray *obj in answerPronounciation)
    {
        [answers addObject:[obj objectAtIndex:0]];
    }
    return answers;
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
