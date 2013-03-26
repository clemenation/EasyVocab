//
//  AnswerFlashCardEasyModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/22/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "AnswerFlashCardEasyModeVC.h"
#import "ReviewFlashCardPraticeModeVC.h"

@interface AnswerFlashCardEasyModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation AnswerFlashCardEasyModeVC{
	NSString * chosenAnswer;
	UIButton * chosenAnswerButton;
}

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
	
	
	
	NSMutableArray * allAns = [NSMutableArray arrayWithArray:[self.fakeAnswer arrayByAddingObject:self.correctAnswer]];
	[self shuffleArray:allAns];
	
	for (int i=0; i<4; i++) {
		[[self.answerButtons objectAtIndex:i] setTitle:[allAns objectAtIndex:i] forState:UIControlStateNormal];
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	if ([chosenAnswer isEqualToString:self.correctAnswer]) {
		[self performSegueWithIdentifier:@"reviewFlashCardPraticeMode" sender:sender];
	}else{
		NSLog(@"Wrong answers!");
		//todo: display wrong animation;
		chosenAnswerButton.enabled = false;
		chosenAnswerButton.selected = false;
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
	
	if ([segue.identifier isEqualToString:@"reviewFlashCardPraticeMode"]) {
		///todo: seting up review
		ReviewFlashCardPraticeModeVC * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		vc.correctAnswer = self.correctAnswer;
	}
	
}

@end
