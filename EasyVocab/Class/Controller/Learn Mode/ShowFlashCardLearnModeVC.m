//
//  ShowFlashCardLearnModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ShowFlashCardLearnModeVC.h"
#import "ChoosePracticeModeVC.h"
#import "EVFlashcardCollection.h"
#import "EVWalkthroughManager.h"
#import "EVViewFlipper.h"
#import "EVConstant.h"
#import "EVFlashcardView.h"
#import "Transformifier.h"


@interface ShowFlashCardLearnModeVC ()

@property (weak, nonatomic) IBOutlet UIButton       *prevButton;
@property (weak, nonatomic) IBOutlet UIButton       *nextButton;
@property (weak, nonatomic) IBOutlet UIView         *flashcardSuperview;
@property (weak, nonatomic) IBOutlet UIView         *prevFlashcardSuperview;
@property (weak, nonatomic) IBOutlet UIView         *nextFlashcardSuperview;
@property (weak, nonatomic) IBOutlet UIButton       *walkthroughButton;
@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (strong, nonatomic) EVViewFlipper         *viewFlipper;
@property (strong, nonatomic) EVFlashcardView       *flashcardView;
@property (strong, nonatomic) EVFlashcardView       *prevFlashcardView;
@property (strong, nonatomic) EVFlashcardView       *nextFlashcardView;
@property (strong, nonatomic) NSString              *currentImagePath;
@property (strong, nonatomic) NSString              *currentAnswer;
@property (strong, nonatomic) Transformifier        *transformifier;


@end

@implementation ShowFlashCardLearnModeVC

@synthesize flashcardCollection = _flashcardCollection;
@synthesize currentFlashCardID  = _currentFlashCardID;
@synthesize currentImagePath    = _currentImagePath;
@synthesize currentAnswer       = _currentAnswer;
@synthesize viewFlipper         = _viewFlipper;
@synthesize flashcardView       = _flashcardView;
@synthesize transformifier      = _transformifier;

- (Transformifier *)transformifier
{
    if (!_transformifier)
    {
        _transformifier = [[Transformifier alloc] initForLayer:self.nextFlashcardSuperview.layer];
    }
    return _transformifier;
}

- (EVViewFlipper *)viewFlipper
{
    if (!_viewFlipper)
    {
        _viewFlipper = [[EVViewFlipper alloc] init];
        _viewFlipper.mainFlashcardView = self.flashcardView;
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
        self.currentImagePath = [self.flashcardCollection flashcardPathAtIndex:_currentFlashCardID ofCategory:self.currentCategory];
        self.currentAnswer = [self.flashcardCollection answerAtIndex:_currentFlashCardID
                                                          ofCategory:self.currentCategory];
        
        self.prevButton.hidden = (currentFlashCardID == 0);
        self.nextButton.hidden = (currentFlashCardID == flashcardCount-1);
    }
}

- (void)setCurrentImagePath:(NSString *)currentImagePath
{
    if (_currentImagePath != currentImagePath)
    {
        _currentImagePath = currentImagePath;
        self.flashcardView.image = [UIImage imageWithContentsOfFile:_currentImagePath];
    }
}

- (void)setCurrentAnswer:(NSString *)currentAnswer
{
    if (_currentAnswer != currentAnswer)
    {
        _currentAnswer = currentAnswer;
        self.flashcardView.answer = _currentAnswer;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self.view.superview insertSubview:self.transformifier.view aboveSubview:self.view];
    self.transformifier.height = 100;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Main flashcard
    self.flashcardView = [[[NSBundle mainBundle] loadNibNamed:@"EVFlashcardView"
                                                        owner:self
                                                      options:nil] objectAtIndex:0];
    [self.flashcardSuperview addSubview:self.flashcardView];
    self.flashcardView.frame = self.flashcardSuperview.bounds;
    // Content
    self.flashcardView.image = [UIImage imageWithContentsOfFile:self.currentImagePath];
    self.flashcardView.answer = self.currentAnswer;
    
    // Previous flashcard
    self.prevFlashcardView = [[[NSBundle mainBundle] loadNibNamed:@"EVFlashcardView"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
    [self.prevFlashcardSuperview addSubview:self.prevFlashcardView];
    self.prevFlashcardView.frame = self.prevFlashcardSuperview.bounds;
    
    // Next flashcard
    self.nextFlashcardView = [[[NSBundle mainBundle] loadNibNamed:@"EVFlashcardView"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
    [self.nextFlashcardSuperview addSubview:self.nextFlashcardView];
    self.nextFlashcardView.frame = self.nextFlashcardSuperview.bounds;
    
    // Setup flipper
    self.viewFlipper.mainFlashcardView = self.flashcardView;
    self.viewFlipper.nextFlashcardView = self.nextFlashcardView;
    self.viewFlipper.prevFlashcardView = self.prevFlashcardView;
    
    self.viewFlipper.mainCardFrame = self.flashcardSuperview.frame;
    self.viewFlipper.nextCardFrame = self.nextFlashcardSuperview.frame;
    self.viewFlipper.prevCardFrame = self.prevFlashcardSuperview.frame;
    
    // Prev/next button hidden
    self.prevButton.hidden = (self.currentFlashCardID == 0);
    self.nextButton.hidden = (self.currentFlashCardID == [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory]-1);
    
    // Walkthrough button hidden
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
    
    // Tilt flashcard
    self.flashcardView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI / 180 * DEFAULT_TILT_ANGLE, 0, 0, 1);
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
    
    [self.viewFlipper next];
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

#pragma mark - Target/action

- (IBAction)flashcardSelected:(UITapGestureRecognizer *)sender {
    [self.viewFlipper flip];
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

@end