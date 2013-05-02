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


@interface ShowFlashCardLearnModeVC ()

@property (weak, nonatomic) IBOutlet UIButton       *prevButton;
@property (weak, nonatomic) IBOutlet UIButton       *nextButton;
@property (weak, nonatomic) IBOutlet UIButton       *walkthroughButton;
@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (strong, nonatomic) EVViewFlipper         *viewFlipper;
@property (strong, nonatomic) NSMutableArray        *flashcardViews;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *flashcardTapGestureRecognizer;

- (void)loadFlashcardsContent;

@end

@implementation ShowFlashCardLearnModeVC

@synthesize flashcardCollection = _flashcardCollection;
@synthesize currentFlashCardID  = _currentFlashCardID;
@synthesize viewFlipper         = _viewFlipper;
@synthesize flashcardViews      = _flashcardViews;

- (NSMutableArray *)flashcardViews
{
    if (!_flashcardViews)
    {
        _flashcardViews = [NSMutableArray arrayWithCapacity:3];
    }
    return _flashcardViews;
}

- (EVViewFlipper *)viewFlipper
{
    if (!_viewFlipper)
    {
        _viewFlipper = [[EVViewFlipper alloc] init];
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
        
        self.prevButton.hidden = (currentFlashCardID == 0);
        self.nextButton.hidden = (currentFlashCardID == flashcardCount-1);
        
        [self loadFlashcardsContent];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    for (int i=0; i<self.flashcardViews.count; i++)
    {
        EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:i];
        flashcardView.frame = CGRectMake(35.0 + self.view.bounds.size.width * (i-1), 91.0, 250.0, 250.0);
        
        // Tilt flashcard
        flashcardView.frontView.transform = CGAffineTransformMakeRotation(M_PI / 180 * DEFAULT_TILT_ANGLE);
        flashcardView.backView.transform = CGAffineTransformMakeRotation(- M_PI / 180 * DEFAULT_TILT_ANGLE);
        
        if (i==0 || i==2)
        {
            flashcardView.hidden = YES;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.flashcardViews removeAllObjects];
    for (int i=0; i<3; i++)
    {
        EVFlashcardView *flashcardView = [[[NSBundle mainBundle] loadNibNamed:@"EVFlashcardView"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
        [self.flashcardViews addObject:flashcardView];
        [self.view addSubview:flashcardView];
    }
    
    [self loadFlashcardsContent];
    
    self.prevButton.hidden = (self.currentFlashCardID == 0);
    self.nextButton.hidden = (self.currentFlashCardID == [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory]-1);
    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
}

- (void)loadFlashcardsContent
{
    for (int i=0; i<self.flashcardViews.count; i++)
    {
        EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:i];
        
        flashcardView.image = [UIImage imageWithContentsOfFile:[self.flashcardCollection flashcardPathAtIndex:(self.currentFlashCardID + (i-1))
                                                                  ofCategory:self.currentCategory]];
        flashcardView.answer = [self.flashcardCollection answerAtIndex:(self.currentFlashCardID + (i-1))
                                                            ofCategory:self.currentCategory];
        
        [flashcardView removeGestureRecognizer:self.flashcardTapGestureRecognizer];
        if (i == 1)
        {
            [flashcardView addGestureRecognizer:self.flashcardTapGestureRecognizer];
        }
    }
}

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToPratice:(id)sender {
	[self.tabBarController setSelectedIndex:1];
}

- (IBAction)prevButtonSelected:(UIButton *)sender {
    EVFlashcardView *firstCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:0];
    EVFlashcardView *secondCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:1];
    EVFlashcardView *thirdCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:2];
    CGRect firstCardFrame = firstCard.frame;
    
    firstCard.hidden = NO;
    thirdCard.hidden = NO;
    
    sender.enabled = NO;
    
    void (^prevAnimation)(void) = ^{
        [UIView animateWithDuration:0.5
                         animations:^{
                             firstCard.frame = secondCard.frame;
                             secondCard.frame = thirdCard.frame;
                         }
                         completion:^(BOOL finished) {
                             thirdCard.frame = firstCardFrame;
                             [self.flashcardViews exchangeObjectAtIndex:0 withObjectAtIndex:1];
                             [self.flashcardViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
                             
                             self.currentFlashCardID--;
                             
                             sender.enabled = YES;
                         }];

    };
    
    if (self.viewFlipper.flashcardView == secondCard && self.viewFlipper.displayingBackView)
    {
        [self.viewFlipper flip:prevAnimation];
    }
    else
    {
        prevAnimation();
    }
}

- (IBAction)nextButtonSelected:(UIButton *)sender {
    EVFlashcardView *firstCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:0];
    EVFlashcardView *secondCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:1];
    EVFlashcardView *thirdCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:2];
    CGRect thirdCardFrame = thirdCard.frame;
    
    firstCard.hidden = NO;
    thirdCard.hidden = NO;
    
    sender.enabled = NO;
    
    void (^nextAnimation)(void) = ^{
        [UIView animateWithDuration:0.5
                         animations:^{
                             thirdCard.frame = secondCard.frame;
                             secondCard.frame = firstCard.frame;
                         }
                         completion:^(BOOL finished) {
                             firstCard.frame = thirdCardFrame;
                             [self.flashcardViews exchangeObjectAtIndex:2 withObjectAtIndex:1];
                             [self.flashcardViews exchangeObjectAtIndex:2 withObjectAtIndex:0];
                             
                             self.currentFlashCardID++;
                             
                             sender.enabled = YES;
                         }];        
    };
    
    if (self.viewFlipper.flashcardView == secondCard && self.viewFlipper.displayingBackView)
    {
        [self.viewFlipper flip:nextAnimation];
    }
    else
    {
        nextAnimation();
    }
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
    self.viewFlipper.flashcardView = [self.flashcardViews objectAtIndex:1];
    [self.viewFlipper flip];
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

@end
