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



#pragma mark - EVViewFlipperDelegate methods

- (void)viewFlipperDidFlipped:(EVViewFlipper *)viewFlipper
{
    if (viewFlipper == self.viewFlipper)
    {
        self.checkButton.hidden = !viewFlipper.displayingBackView;
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

- (IBAction)flashcardSelected:(UITapGestureRecognizer *)sender
{
    [super flashcardSelected:sender];
}



#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
//	if ([segue.identifier isEqualToString:@"answerFlashCardEasyMode"]) {
//		NSLog(@"category=%@",self.currentCategory);
//		AnswerFlashCardEasyModeVC * vc = segue.destinationViewController;
//		vc.currentFlashCard = self.currentFlashCard;
//		NSError * error;
//		NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
//		
//		NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] 
//																  options:NSJSONReadingMutableLeaves 
//																	error:&error];
//		if (!jsonDict) {
//			NSLog(@"Got an error: %@", error);
//			//			NSLog(@"With jsonString=%@",jsonString);
//			vc.correctAnswer = @"easy vocab";
//			vc.fakeAnswer = [NSArray arrayWithObjects:@"fake1",@"fake2",@"fake3", nil];
//		} else {
//			NSArray * categoryAnswer = [jsonDict objectForKey:self.currentCategory];
//			//			NSLog(@"categoryAnswer=%@",categoryAnswer);
//			vc.correctAnswer = [categoryAnswer objectAtIndex:self.currentFlashCardID];
//			int k = rand()%4+1;
//			vc.fakeAnswer = [NSMutableArray arrayWithObjects:
//							 [categoryAnswer objectAtIndex:(self.currentFlashCardID+1*k)%categoryAnswer.count],
//							 [categoryAnswer objectAtIndex:(self.currentFlashCardID+2*k)%categoryAnswer.count],
//							 [categoryAnswer objectAtIndex:(self.currentFlashCardID+3*k)%categoryAnswer.count],
//							 nil];
//		}															
//		
//		
//		
//	}
//	
//	if ([segue.identifier isEqualToString:@"answerFlashCardChallengeMode"]) {
//		NSLog(@"category=%@",self.currentCategory);
//		AnswerFlashCardChallengeMode * vc = segue.destinationViewController;
//		vc.currentFlashCard = self.currentFlashCard;
//		
//		NSError * error;
//		NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
//		
//		NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] 
//																  options:NSJSONReadingMutableLeaves 
//																	error:&error];
//		if (!jsonDict) {
//			NSLog(@"Got an error: %@", error);
//			vc.correctAnswer = @"easy vocab";
//		} else {
//			NSArray * categoryAnswer = [jsonDict objectForKey:self.currentCategory];
//			vc.correctAnswer = [categoryAnswer objectAtIndex:self.currentFlashCardID];
//		}		
//		
//	}
}

@end
