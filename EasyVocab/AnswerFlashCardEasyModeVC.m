//
//  AnswerFlashCardEasyModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/22/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "AnswerFlashCardEasyModeVC.h"
#import "ReviewFlashCardPraticeModeVC.h"
#import "EVWalkthroughManager.h"

@interface AnswerFlashCardEasyModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation AnswerFlashCardEasyModeVC{
	NSString * chosenAnswer;
	UIButton * chosenAnswerButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.imageView.image = [UIImage imageWithContentsOfFile:self.currentFlashCard];
	
	
	
	NSMutableArray * allAns = [NSMutableArray arrayWithArray:[self.fakeAnswer arrayByAddingObject:self.correctAnswer]];
	[self shuffleArray:allAns];
	
	for (int i=0; i<4; i++) {
		[[self.answerButtons objectAtIndex:i] setTitle:[[allAns objectAtIndex:i] uppercaseString] forState:UIControlStateNormal];
        ((UIButton *)[self.answerButtons objectAtIndex:i]).titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:20];
	}

	self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
}

#pragma mark - 

-(void)shuffleArray:(NSMutableArray*)arr{
	NSUInteger count = [arr count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [arr exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

#pragma mark -  Buttons


- (IBAction)chooseAnswer:(UIButton *)sender {
	chosenAnswer=sender.titleLabel.text;
	chosenAnswerButton=sender;
	NSLog(@"User has choose answer:%@",chosenAnswer);
	//reviewFlashCardPraticeMode
	for (UIButton * bt in self.answerButtons) {
		if (bt == chosenAnswerButton) {
			bt.selected = true;
		}else{
			bt.selected = false;

		}
	}
	
}

- (IBAction)checkAnswer:(UIButton *)sender {
	if ([chosenAnswer.uppercaseString isEqualToString:self.correctAnswer.uppercaseString]) {
		[self performSegueWithIdentifier:@"reviewFlashCardPraticeMode" sender:sender];
	}else{
		NSLog(@"Wrong answers!");
		//todo: display wrong animation;
		chosenAnswerButton.enabled = false;
		chosenAnswerButton.selected = false;
	}
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES forController:NSStringFromClass(self.class)];
}

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToLearn:(id)sender {
	[self.tabBarController setSelectedIndex:0];
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	if ([segue.identifier isEqualToString:@"reviewFlashCardPraticeMode"]) {
		///todo: seting up review
		ReviewFlashCardPraticeModeVC * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		vc.correctAnswer = self.correctAnswer;
	}
	
}

@end
