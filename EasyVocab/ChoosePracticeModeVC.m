//
//  ChoosePracticeModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ChoosePracticeModeVC.h"
#import "ShowFlashCardPraticeModeVC.h"

@interface ChoosePracticeModeVC ()

@end

@implementation ChoosePracticeModeVC{
	int praticeModeSelected;
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
	NSLog(@"ChoosePracticeModeVC DidLoad with category: %@",self.currentCategory);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons
- (IBAction)easyModeSelected:(id)sender {
	praticeModeSelected=1;
	[self performSegueWithIdentifier:@"showFlashCardPraticeMode" sender:sender];
}

- (IBAction)challengeModeSelected:(id)sender {
	praticeModeSelected=2;
	[self performSegueWithIdentifier:@"showFlashCardPraticeMode" sender:sender];
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
	if ([segue.identifier isEqualToString:@"showFlashCardPraticeMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		NSLog(@"praticeMode=%d",praticeModeSelected);
		ShowFlashCardPraticeModeVC * vc = segue.destinationViewController;
		vc.currentCategory=self.currentCategory;
		vc.currentPraticeMode = praticeModeSelected;
		
		NSArray * allCard = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:self.currentCategory];
		vc.currentFlashCardID = rand()%[allCard count];
		vc.currentFlashCard = [allCard objectAtIndex:vc.currentFlashCardID];
	}
	
}







@end
