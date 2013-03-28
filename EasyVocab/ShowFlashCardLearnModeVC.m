//
//  ShowFlashCardLearnModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ShowFlashCardLearnModeVC.h"
#import "ReviewFlashCardLearnModeVC.h"
#import "ChoosePracticeModeVC.h"
@interface ShowFlashCardLearnModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation ShowFlashCardLearnModeVC

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

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToPratice:(id)sender {
	[self.tabBarController setSelectedIndex:1];
}


#pragma mark - segue

- (IBAction)returnToShowFlashCardLearnMode:(UIStoryboardSegue *)segue
{
    NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	//geting view from container bind to property without create a new view controller
	if ([segue.identifier isEqualToString:@"goToPracticeMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		((ChoosePracticeModeVC*)segue.destinationViewController).currentCategory = self.currentCategory;
	}
	
	if ([segue.identifier isEqualToString:@"reviewFlashCardLearnMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		ReviewFlashCardLearnModeVC * vc = segue.destinationViewController;
		vc.currentFlashCard = self.currentFlashCard;
		vc.currentCategory = self.currentCategory;
		
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
@end
