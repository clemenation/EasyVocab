//
//  EVFlashcardView.h
//  EasyVocab
//
//  Created by Dung Nguyen on 4/18/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVFlashcard.h"

@protocol EVFlashcardViewDelegate;

@interface EVFlashcardView : UIControl

typedef enum {
    EVFlashcardViewLearn,
    EVFlashcardViewPracticeEasy,
    EVFlashcardViewPracticeChallenge,
    EVFlashcardViewPracticeAnswer
} EVFlashcardViewType;

@property (weak, nonatomic) IBOutlet UITextField    *answerTextField;
@property (weak, nonatomic) IBOutlet UIView         *backView;
@property (weak, nonatomic) IBOutlet UIView         *frontView;
@property (weak, nonatomic) id <EVFlashcardViewDelegate> delegate;
@property (assign, nonatomic) EVFlashcardViewType   flashcardViewType;

@property (strong ,nonatomic) EVFlashcard           *flashcard;
@property (strong, nonatomic) UIView                *containerView;
@property (strong, nonatomic) NSArray               *choices;

- (IBAction)speakerSelected:(id)sender;
- (IBAction)nextButtonSelected:(UIButton *)sender;
- (BOOL)checkAnswer;

@end

@protocol EVFlashcardViewDelegate

- (void)nextButtonOfFlashcardView:(EVFlashcardView *)flashcardView
                         selected:(UIButton *)sender;

@optional

- (void)checkButtonOfFlashcardView:(EVFlashcardView *)flashcardView
                          selected:(UIButton *)sender
                            result:(BOOL)result;

@end