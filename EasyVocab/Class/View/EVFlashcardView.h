//
//  EVFlashcardView.h
//  EasyVocab
//
//  Created by Dung Nguyen on 4/18/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVFlashcard.h"

@interface EVFlashcardView : UIControl

typedef enum {
    EVFlashcardViewLearn,
    EVFlashcardViewPracticeEasy,
    EVFlashcardViewPracticeChallenge,
    EVFlashcardViewPracticeAnswer
} EVFlashcardViewType;

@property (weak, nonatomic) IBOutlet UIView         *backView;
@property (weak, nonatomic) IBOutlet UIView         *frontView;
@property (assign, nonatomic) EVFlashcardViewType   flashcardViewType;

@property (strong ,nonatomic) EVFlashcard           *flashcard;
@property (strong, nonatomic) UIView                *containerView;
@property (strong, nonatomic) NSArray               *choices;

- (IBAction)speakerSelected:(id)sender;

@end
