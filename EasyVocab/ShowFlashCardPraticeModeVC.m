//
//  ShowFlashCardPraticeModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ShowFlashCardPraticeModeVC.h"
#import "AnswerFlashCardEasyModeVC.h"
#import "AnswerFlashCardChallengeMode.h"
#import "EVWalkthroughManager.h"

@interface ShowFlashCardPraticeModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;
@property (weak, nonatomic) IBOutlet UIView *flashcardView;

@end

@implementation ShowFlashCardPraticeModeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.imageView.image = [UIImage imageWithContentsOfFile:self.currentFlashCard];
    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
    
    self.flashcardView.transform = CGAffineTransformMakeRotation(M_PI / 180 * 5);
}

#pragma mark - gesture

- (IBAction)tapGestureAction:(id)sender {
	
	if (self.currentPraticeMode==1) {
		[self performSegueWithIdentifier:@"answerFlashCardEasyMode" sender:nil];
	}
	if (self.currentPraticeMode==2) {
		[self performSegueWithIdentifier:@"answerFlashCardChallengeMode" sender:nil];
	}
}
#pragma mark - Buttons fake Tabbar

- (IBAction)switchToLearn:(id)sender {
	[self.tabBarController setSelectedIndex:0];
}
#pragma mark - segue

-(void)returnToShowFlashCardPraticeMode:(UIStoryboardSegue *)segue{
	NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
	NSArray * allCard = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:self.currentCategory];
	self.currentFlashCardID=(self.currentFlashCardID+1)%allCard.count;
	self.currentFlashCard=[allCard objectAtIndex:self.currentFlashCardID];
	[self viewDidLoad];
	
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	if ([segue.identifier isEqualToString:@"answerFlashCardEasyMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		AnswerFlashCardEasyModeVC * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		NSError * error;
		NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
		
		NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] 
																  options:NSJSONReadingMutableLeaves 
																	error:&error];
		if (!jsonDict) {
			NSLog(@"Got an error: %@", error);
			//			NSLog(@"With jsonString=%@",jsonString);
			vc.correctAnswer = @"easy vocab";
			vc.fakeAnswer = [NSArray arrayWithObjects:@"fake1",@"fake2",@"fake3", nil];
		} else {
			NSArray * categoryAnswer = [jsonDict objectForKey:self.currentCategory];
			//			NSLog(@"categoryAnswer=%@",categoryAnswer);
			vc.correctAnswer = [categoryAnswer objectAtIndex:self.currentFlashCardID];
			int k = rand()%4+1;
			vc.fakeAnswer = [NSMutableArray arrayWithObjects:
							 [categoryAnswer objectAtIndex:(self.currentFlashCardID+1*k)%categoryAnswer.count],
							 [categoryAnswer objectAtIndex:(self.currentFlashCardID+2*k)%categoryAnswer.count],
							 [categoryAnswer objectAtIndex:(self.currentFlashCardID+3*k)%categoryAnswer.count],
							 nil];
		}															
		
		
		
	}
	
	if ([segue.identifier isEqualToString:@"answerFlashCardChallengeMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		AnswerFlashCardChallengeMode * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		
		NSError * error;
		NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
		
		NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] 
																  options:NSJSONReadingMutableLeaves 
																	error:&error];
		if (!jsonDict) {
			NSLog(@"Got an error: %@", error);
			vc.correctAnswer = @"easy vocab";
		} else {
			NSArray * categoryAnswer = [jsonDict objectForKey:self.currentCategory];
			vc.correctAnswer = [categoryAnswer objectAtIndex:self.currentFlashCardID];
		}		
		
	}
}

#pragma mark - Target/action

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

@end
