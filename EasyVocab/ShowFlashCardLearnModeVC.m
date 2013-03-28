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
#import "EVFlashcardCollection.h"


@interface ShowFlashCardLearnModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation ShowFlashCardLearnModeVC

@synthesize flashcardCollection = _flashcardCollection;
@synthesize currentFlashCardID = _currentFlashCardID;
@synthesize currentFlashCard = _currentFlashCard;

- (EVFlashcardCollection *)flashcardCollection
{
    if (!_flashcardCollection)
    {
        _flashcardCollection = [[EVFlashcardCollection alloc] init];
    }
    return _flashcardCollection;
}

- (void)setCurrentFlashCardID:(int)currentFlashCardID
{
    if (_currentFlashCardID != currentFlashCardID)
    {
        int flashcardCount = [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory];
        if (currentFlashCardID >= 0 && currentFlashCardID < flashcardCount)
        {
            _currentFlashCardID = currentFlashCardID;
            self.currentFlashCard = [self.flashcardCollection flashcardPathAtIndex:_currentFlashCardID ofCategory:self.currentCategory];
            
            self.prevButton.hidden = (currentFlashCardID == 0);
            self.nextButton.hidden = (currentFlashCardID == flashcardCount-1);
        }
    }
}

- (void)setCurrentFlashCard:(NSString *)currentFlashCard
{
    if (_currentFlashCard != currentFlashCard)
    {
        _currentFlashCard = currentFlashCard;
        self.imageView.image = [UIImage imageWithContentsOfFile:_currentFlashCard];
    }
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

- (IBAction)prevButtonSelected:(UIButton *)sender {
    self.currentFlashCardID--;
}

- (IBAction)nextButtonSelected:(UIButton *)sender {
    self.currentFlashCardID++;
}

#pragma mark - segue

- (IBAction)returnToShowFlashCardLearnMode:(UIStoryboardSegue *)segue
{
    NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
    if ([segue.sourceViewController isKindOfClass:[ReviewFlashCardLearnModeVC class]])
    {
        ReviewFlashCardLearnModeVC *vc = segue.sourceViewController;
        self.currentFlashCardID = vc.currentFlashcardID;
    }
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
		vc.currentCategory = self.currentCategory;
		vc.currentFlashcardID = self.currentFlashCardID;
		
	}
	
}
@end
