//
//  ChoosePracticeModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ChoosePracticeModeVC.h"
#import "EVFlashcardPracticeModeEasyViewController.h"
#import "EVWalkthroughManager.h"
#import "EVSettingViewController.h"

@interface ChoosePracticeModeVC ()

@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;

@end

@implementation ChoosePracticeModeVC{
	int praticeModeSelected;
}

- (void)viewWillAppear:(BOOL)animated
{    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//	NSLog(@"ChoosePracticeModeVC DidLoad with category: %@",self.currentCategory);
}

#pragma mark - Buttons
- (IBAction)easyModeSelected:(id)sender {
	praticeModeSelected=1;
	[self performSegueWithIdentifier:@"showFlashCardPraticeMode" sender:sender];
}

- (IBAction)challengeModeSelected:(id)sender {
	praticeModeSelected=2;
	[self performSegueWithIdentifier:@"showFlashcardPracticeModeChallenge" sender:sender];
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToLearn:(id)sender {
	[self.tabBarController setSelectedIndex:0];
}

#pragma mark - segue

-(void)returnToChoosePraticeMode:(UIStoryboardSegue *)segue{
	NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	//geting view from container bind to property without create a new view controller
	if ([segue.identifier isEqualToString:@"showFlashCardPraticeMode"] ||
        [segue.identifier isEqualToString:@"showFlashcardPracticeModeChallenge"]) {
		NSLog(@"category=%@",self.currentCategory);
		NSLog(@"praticeMode=%d",praticeModeSelected);
		EVFlashcardViewController * vc = segue.destinationViewController;
		vc.currentCategory=self.currentCategory;
	}
	
}

#pragma mark - Target/action

- (IBAction)settingButtonSelected:(UIButton *)sender {
    [EVSettingViewController presentSettingViewControllerWithStoryboard:self.storyboard andParentViewController:self];
}

@end
