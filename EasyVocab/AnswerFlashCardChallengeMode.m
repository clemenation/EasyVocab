//
//  AnswerFlashCardChallengeMode.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "AnswerFlashCardChallengeMode.h"
#import "ReviewFlashCardPraticeModeVC.h"
#import "EVWalkthroughManager.h"

@interface AnswerFlashCardChallengeMode ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *giveUpButton;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;

@end

@implementation AnswerFlashCardChallengeMode{
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.imageView.image = [UIImage imageWithContentsOfFile:self.currentFlashCard];
    self.textField.font = [UIFont fontWithName:@"UVNVanBold" size:20];
    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
    if (self.walkthroughButton.hidden) [self.textField becomeFirstResponder];
}

#pragma mark - textField delegate

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//	[textField resignFirstResponder];
//	return NO;
//}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
	self.textField.backgroundColor = [UIColor clearColor];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	self.textField.backgroundColor = [UIColor clearColor];
	return true;
}

#pragma mark - Buttons

- (IBAction)checkAnswerPressed:(id)sender {
	
	if ([[self.textField.text capitalizedString] isEqualToString:[self.correctAnswer capitalizedString]]) {
		[self performSegueWithIdentifier:@"reviewFlashCardPraticeMode" sender:sender];
	}else{
		NSLog(@"Wrong answer! Try another words in the textfield pls!");
		///todo: display incorrect animation
		self.textField.backgroundColor = [UIColor redColor];
	}
	
}
- (IBAction)giveUpButtonPressed:(id)sender {
	[self performSegueWithIdentifier:@"reviewFlashCardPraticeMode" sender:sender];
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [self.textField becomeFirstResponder];
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
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
        
        // disable awesome message in back flashcard
        vc.isGiveUp = (sender == self.giveUpButton);
	}
	
}

@end
