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

@interface ShowFlashCardPraticeModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ShowFlashCardPraticeModeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.imageView.image = [UIImage imageWithContentsOfFile:self.currentFlashCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	if ([segue.identifier isEqualToString:@"answerFlashCardEasyMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		AnswerFlashCardEasyModeVC * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		vc.correctAnswer = @"easy vocab";
		vc.fakeAnswer = [NSArray arrayWithObjects:@"fake1",@"fake2",@"fake3", nil];
	}
	
	if ([segue.identifier isEqualToString:@"answerFlashCardChallengeMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		AnswerFlashCardChallengeMode * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		vc.correctAnswer = @"easy vocab";
	}
	
}
@end
