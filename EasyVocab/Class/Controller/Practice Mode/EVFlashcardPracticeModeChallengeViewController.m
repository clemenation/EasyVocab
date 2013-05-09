//
//  EVFlashcardPracticeModeChallengeViewController.m
//  EasyVocab
//
//  Created by Dung Nguyen on 5/9/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardPracticeModeChallengeViewController.h"
#import "AnswerFlashCardEasyModeVC.h"
#import "AnswerFlashCardChallengeMode.h"
#import "EVWalkthroughManager.h"
#import "EVFlashcardCollection.h"
#import "EVCommon.h"
#import "EVFlashcardView.h"
#import "EVViewFlipper.h"

@interface EVFlashcardPracticeModeChallengeViewController () <EVViewFlipperDelegate>

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *giveUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *awesomeImageView;

@end

@implementation EVFlashcardPracticeModeChallengeViewController

- (void)setCurrentCategory:(NSString *)currentCategory
{
    BOOL changed = (self.currentCategory != currentCategory);
    [super setCurrentCategory:currentCategory];
    
    if (changed)
    {
        [self.flashcardCollection shuffle]; // auto shuffle flashcards
        self.currentFlashCardID = 0;        // and start from beginning
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.flashcardViewType = EVFlashcardViewPracticeChallenge;
    self.flipOnce = YES;
    self.viewFlipper.delegate = self;
}

- (void)loadFlashcardsContent
{
    [super loadFlashcardsContent];
    
    if (self.flashcardViews.count == 3)
    {
        EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:1];
        flashcardView.choices = [self.flashcardCollection choicesForAnswerAtIndex:self.currentFlashCardID];
    }
}



#pragma mark - Buttons fake Tabbar

- (IBAction)switchToLearn:(id)sender {
	[self.tabBarController setSelectedIndex:0];
}



#pragma mark - EVFlashcardViewDelegate methods

- (void)nextButtonOfFlashcardView:(EVFlashcardView *)flashcardView
                         selected:(UIButton *)sender
{
    self.awesomeImageView.hidden = YES;
    [self goToNextCard:sender animationsAddition:nil completionAddition:^(BOOL finished) {
        flashcardView.flashcardViewType = EVFlashcardViewPracticeChallenge;
    }];
}



#pragma mark - EVViewFlipperDelegate methods

- (void)viewFlipperDidFlipped:(EVViewFlipper *)viewFlipper
{
    if (viewFlipper == self.viewFlipper)
    {
        self.checkButton.hidden = !viewFlipper.displayingBackView;
        self.giveUpButton.hidden = !viewFlipper.displayingBackView;
        EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:1];
        if (viewFlipper.displayingBackView)
        {
            [flashcardView.answerTextField becomeFirstResponder];
        }
    }
}



#pragma mark - Target/action

- (IBAction)checkAnswer:(UIButton *)sender
{
    EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:1];
    if ([flashcardView checkAnswer])
    {
        self.checkButton.hidden = YES;
        self.awesomeImageView.hidden = NO;
        flashcardView.flashcardViewType = EVFlashcardViewPracticeAnswer;
    }
}

- (void)checkButtonOfFlashcardView:(EVFlashcardView *)flashcardView
                          selected:(UIButton *)sender
                            result:(BOOL)result
{
    if (result)
    {
        self.awesomeImageView.hidden = NO;
        flashcardView.flashcardViewType = EVFlashcardViewPracticeAnswer;
        self.giveUpButton.hidden = YES;
    }
}

- (IBAction)flashcardSelected:(UITapGestureRecognizer *)sender
{
    [super flashcardSelected:sender];
}

- (IBAction)giveUpButtonSelected:(UIButton *)sender {
    ((EVFlashcardView *)[self.flashcardViews objectAtIndex:1]).flashcardViewType = EVFlashcardViewPracticeAnswer;
    self.giveUpButton.hidden = YES;
}

@end
