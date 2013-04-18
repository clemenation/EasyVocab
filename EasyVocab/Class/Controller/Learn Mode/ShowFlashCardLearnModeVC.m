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
#import "EVWalkthroughManager.h"
#import "EVViewFlipper.h"
#import "EVConstant.h"
#import "EVFlashcardView.h"


@interface ShowFlashCardLearnModeVC ()

@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;
@property (strong, nonatomic) EVViewFlipper *viewFlipper;
@property (weak, nonatomic) IBOutlet UIView *flashcardSuperview;
@property (strong, nonatomic) EVFlashcardView *flashcardView;


@end

@implementation ShowFlashCardLearnModeVC

@synthesize flashcardCollection = _flashcardCollection;
@synthesize currentFlashCardID = _currentFlashCardID;
@synthesize currentFlashCard = _currentFlashCard;
@synthesize viewFlipper = _viewFlipper;
@synthesize flashcardView = _flashcardView;

- (EVViewFlipper *)viewFlipper
{
    if (!_viewFlipper)
    {
        _viewFlipper = [[EVViewFlipper alloc] init];
        _viewFlipper.frontView = self.flashcardView.frontView;
        _viewFlipper.backView = self.flashcardView.backView;
        _viewFlipper.tiltAngle = DEFAULT_TILT_ANGLE;
        _viewFlipper.duration = DEFAULT_FLIP_DURATION;
    }
    return _viewFlipper;
}

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
    int flashcardCount = [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory];
    if (currentFlashCardID >= 0 && currentFlashCardID < flashcardCount)
    {
        _currentFlashCardID = currentFlashCardID;
        self.currentFlashCard = [self.flashcardCollection flashcardPathAtIndex:_currentFlashCardID ofCategory:self.currentCategory];
        
        self.prevButton.hidden = (currentFlashCardID == 0);
        self.nextButton.hidden = (currentFlashCardID == flashcardCount-1);
    }
}

- (void)setCurrentFlashCard:(NSString *)currentFlashCard
{
    if (_currentFlashCard != currentFlashCard)
    {
        _currentFlashCard = currentFlashCard;
        self.flashcardView.image = [UIImage imageWithContentsOfFile:_currentFlashCard];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.flashcardView = [[[NSBundle mainBundle] loadNibNamed:@"EVFlashcardView"
                                                        owner:self
                                                      options:nil] objectAtIndex:0];
    [self.flashcardSuperview addSubview:self.flashcardView];
    self.flashcardView.frame = self.flashcardSuperview.bounds;
  
    self.flashcardView.image = [UIImage imageWithContentsOfFile:_currentFlashCard];
    self.prevButton.hidden = (self.currentFlashCardID == 0);
    self.nextButton.hidden = (self.currentFlashCardID == [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory]-1);
    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
    
    // Tilt flashcard
    self.flashcardView.frontView.transform = CGAffineTransformMakeRotation(M_PI / 180 * DEFAULT_TILT_ANGLE);
    self.flashcardView.backView.transform = CGAffineTransformMakeRotation(- M_PI / 180 * DEFAULT_TILT_ANGLE);
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

#pragma mark - Target/action

- (IBAction)flipSelected:(UIButton *)sender {
    [self.viewFlipper flip];
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

@end
