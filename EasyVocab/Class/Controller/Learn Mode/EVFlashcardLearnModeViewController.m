//
//  ShowFlashCardLearnModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardLearnModeViewController.h"
#import "ChoosePracticeModeVC.h"
#import "EVFlashcardCollection.h"
#import "EVWalkthroughManager.h"
#import "EVViewFlipper.h"
#import "EVCommon.h"
#import "EVFlashcardView.h"
#import "EVSoundPlayer.h"


@interface EVFlashcardLearnModeViewController ()

@end

@implementation EVFlashcardLearnModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.flashcardViewType = EVFlashcardViewLearn;
}

#pragma mark - Buttons fake Tabbar

- (IBAction)allButtonSelected:(UIButton *)sender {
    [EVSoundPlayer playClickSound];
}

- (IBAction)switchToPratice:(id)sender {
    [EVSoundPlayer playClickSound];
	[self.tabBarController setSelectedIndex:1];
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	//geting view from container bind to property without create a new view controller
	if ([segue.identifier isEqualToString:@"goToPracticeMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		((ChoosePracticeModeVC*)segue.destinationViewController).currentCategory = self.currentCategory;
	}	
}

@end
