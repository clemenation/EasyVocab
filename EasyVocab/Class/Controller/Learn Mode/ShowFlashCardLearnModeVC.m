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
@property (weak, nonatomic) IBOutlet UIView         *prevUnderFlashcardSuperview;
@property (weak, nonatomic) IBOutlet UIView         *nextFlashcardSuperview;
@property (weak, nonatomic) IBOutlet UIView         *nextUnderFlashcardSuperview;
@property (weak, nonatomic) IBOutlet UIButton       *walkthroughButton;
@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (strong, nonatomic) EVViewFlipper         *viewFlipper;
@property (strong, nonatomic) NSMutableArray        *flashcardsViews;
@property (strong, nonatomic) NSArray               *flashcardsSuperviews;
@property (strong, nonatomic) NSMutableArray        *imagesPaths;
@property (strong, nonatomic) NSMutableArray        *answers;
@property (strong, nonatomic) Transformifier        *transformifier;

- (EVFlashcardView *)newFlashcardView:(UIView *)superview;
- (void)loadFlashcardsViews;
- (void)loadImagesAndAnswers;

@end

@implementation ShowFlashCardLearnModeVC

@synthesize flashcardCollection     = _flashcardCollection;
@synthesize currentFlashCardID      = _currentFlashCardID;
@synthesize imagesPaths             = _imagesPaths;
@synthesize answers                 = _answers;
@synthesize viewFlipper             = _viewFlipper;
@synthesize flashcardsViews         = _flashcardsViews;
@synthesize flashcardsSuperviews    = _flashcardsSuperviews;
@synthesize transformifier          = _transformifier;

- (NSArray *)flashcardsViews
{
    if (!_flashcardsViews)
    {
        _flashcardsViews = [NSMutableArray arrayWithCapacity:5];
    }
    return _flashcardsViews;
}

- (NSArray *)flashcardsSuperviews
{
    if (!_flashcardsSuperviews)
    {
        _flashcardsSuperviews = [NSArray arrayWithObjects:self.prevUnderFlashcardSuperview,
                               self.prevFlashcardSuperview,
                               self.flashcardSuperview,
                               self.nextFlashcardSuperview,
                               self.nextUnderFlashcardSuperview,
                               nil];
    }
    return _flashcardsSuperviews;
}

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
        _viewFlipper.mainFlashcardView = [self.flashcardsViews objectAtIndex:2];
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
        for (int i=0; i<5; i++)
        {
            int pos = _currentFlashCardID + (i-2);
            if (pos >= 0 && pos < flashcardCount)
            {
                [self.imagesPaths setObject:[self.flashcardCollection flashcardPathAtIndex:pos
                                                                                ofCategory:self.currentCategory]
                         atIndexedSubscript:i];
                [self.answers setObject:[self.flashcardCollection answerAtIndex:pos
                                                                     ofCategory:self.currentCategory]
                     atIndexedSubscript:i];
            }
            else
            {
                [self.imagesPaths setObject:[NSNull null] atIndexedSubscript:i];
                [self.answers setObject:[NSNull null] atIndexedSubscript:i];
            }
        }
        if (self.isViewLoaded) [self loadImagesAndAnswers];
        
        self.prevUnderFlashcardSuperview.hidden = self.prevFlashcardSuperview.hidden = self.prevButton.hidden = (currentFlashCardID == 0);
        self.nextUnderFlashcardSuperview.hidden = self.nextFlashcardSuperview.hidden = self.nextButton.hidden = (currentFlashCardID == flashcardCount-1);
    }
}

- (NSMutableArray *)imagesPaths
{
    if (!_imagesPaths)
    {
        _imagesPaths = [NSMutableArray arrayWithCapacity:5];
    }
    return _imagesPaths;
}

- (NSMutableArray *)answers
{
    if (!_answers)
    {
        _answers = [NSMutableArray arrayWithCapacity:5];
    }
    return _answers;
}

- (void)loadImagesAndAnswers
{
    for (int i=0; i<5; i++)
    {
        EVFlashcardView *flashcardView = [self.flashcardsViews objectAtIndex:i];
        id image = [self.imagesPaths objectAtIndex:i];
        id answer = [self.answers objectAtIndex:i];
        if (image != [NSNull null])
        {
            flashcardView.image = [UIImage imageWithContentsOfFile:image];
        }
        if (answer != [NSNull null])
        {
            flashcardView.answer = answer;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self.view.superview insertSubview:self.transformifier.view aboveSubview:self.view];
    self.transformifier.height = 100;
}

- (EVFlashcardView *)newFlashcardView:(UIView *)superview
{
    EVFlashcardView *flashcardView = [[[NSBundle mainBundle] loadNibNamed:@"EVFlashcardView"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
    [superview addSubview:flashcardView];
    flashcardView.frame = superview.bounds;
    
    return flashcardView;
}

- (void)loadFlashcardsViews
{
    for (int i=0; i<5; i++)
    {
        [self.flashcardsViews setObject:[self newFlashcardView:[self.flashcardsSuperviews objectAtIndex:i]]
                     atIndexedSubscript:i];
    }
    [self loadImagesAndAnswers];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadFlashcardsViews];
    
    // Setup flipper
    self.viewFlipper.mainFlashcardView = [self.flashcardsViews objectAtIndex:2];
    self.viewFlipper.nextFlashcardView = [self.flashcardsViews objectAtIndex:3];
    self.viewFlipper.prevFlashcardView = [self.flashcardsViews objectAtIndex:1];
    
    self.viewFlipper.mainCardFrame = ((UIView *)[self.flashcardsSuperviews objectAtIndex:2]).frame;
    self.viewFlipper.nextCardFrame = ((UIView *)[self.flashcardsSuperviews objectAtIndex:3]).frame;
    self.viewFlipper.prevCardFrame = ((UIView *)[self.flashcardsSuperviews objectAtIndex:1]).frame;
    
    // Prev/next button hidden
    self.prevButton.hidden = (self.currentFlashCardID == 0);
    self.nextButton.hidden = (self.currentFlashCardID == [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory]-1);
    
    // Walkthrough button hidden
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
    
    // Tilt flashcard
    ((EVFlashcardView *)[self.flashcardsViews objectAtIndex:2]).layer.transform = CATransform3DRotate(CATransform3DIdentity,
                                                                                                      M_PI / 180 * DEFAULT_TILT_ANGLE,
                                                                                                      0, 0, 1);
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
