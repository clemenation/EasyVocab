//
//  ShowFlashCardPraticeModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardPracticeModeEasyViewController.h"
#import "AnswerFlashCardEasyModeVC.h"
#import "AnswerFlashCardChallengeMode.h"
#import "EVWalkthroughManager.h"
#import "EVFlashcardCollection.h"
#import "EVCommon.h"
#import "EVFlashcardView.h"
#import "EVViewFlipper.h"
#import "EVSoundPlayer.h"

@interface EVFlashcardPracticeModeEasyViewController () <EVViewFlipperDelegate>

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *awesomeImageView;

@end

@implementation EVFlashcardPracticeModeEasyViewController

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
    
    self.flashcardViewType = EVFlashcardViewPracticeEasy;
//    self.flipOnce = YES;
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
    [EVSoundPlayer playClickSound];
	[self.tabBarController setSelectedIndex:0];
}



#pragma mark - EVFlashcardViewDelegate methods

- (void)nextButtonOfFlashcardView:(EVFlashcardView *)flashcardView
                         selected:(UIButton *)sender
{
    self.awesomeImageView.hidden = YES;
    [self goToNextCard:sender animationsAddition:nil completionAddition:^(BOOL finished) {
        flashcardView.flashcardViewType = EVFlashcardViewPracticeEasy;
    }];
}



#pragma mark - EVViewFlipperDelegate methods

- (void)viewFlipperDidFlipped:(EVViewFlipper *)viewFlipper
{
    if (viewFlipper == self.viewFlipper)
    {
        self.checkButton.hidden = !viewFlipper.displayingBackView;
    }
}



#pragma mark - Target/action

- (IBAction)quitButtonSelected:(UIButton *)sender {
    [EVSoundPlayer playClickSound];
}

- (IBAction)checkAnswer:(UIButton *)sender
{
    [EVSoundPlayer playClickSound];
    EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:1];
    if ([flashcardView checkAnswer])
    {        
        self.checkButton.hidden = YES;
        self.awesomeImageView.hidden = NO;
        flashcardView.flashcardViewType = EVFlashcardViewPracticeAnswer;
    }
}

- (IBAction)flashcardSelected:(UITapGestureRecognizer *)sender
{
    [super flashcardSelected:sender];
}

@end
