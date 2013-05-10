//
//  EVShowFlashcardViewController.m
//  EasyVocab
//
//  Created by Dung Nguyen on 5/2/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardViewController.h"
#import "EVWalkthroughManager.h"
#import "EVCommon.h"
#import "EVSettingViewController.h"
#import "EVSoundPlayer.h"

@interface EVFlashcardViewController ()

@property (weak, nonatomic) IBOutlet UIButton       *prevButton;
@property (weak, nonatomic) IBOutlet UIButton       *nextButton;
@property (weak, nonatomic) IBOutlet UIButton       *walkthroughButton;
@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (strong, nonatomic) EVViewFlipper         *viewFlipper;
@property (strong, nonatomic) NSMutableArray        *flashcardViews;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *flashcardTapGestureRecognizer;

@end

@implementation EVFlashcardViewController

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
        _flashcardCollection = [[EVFlashcardCollection alloc] initWithCategory:self.currentCategory];
    }
    return _flashcardCollection;
}

- (void)setCurrentCategory:(NSString *)currentCategory
{
    if (_currentCategory != currentCategory)
    {
        _currentCategory = currentCategory;
        self.flashcardCollection.category = _currentCategory;
    }
}

- (void)setCurrentFlashCardID:(NSUInteger)currentFlashCardID
{
    int flashcardCount = self.flashcardCollection.count;
    if (currentFlashCardID < flashcardCount)
    {
        _currentFlashCardID = currentFlashCardID;
        
        self.prevButton.hidden = (currentFlashCardID == 0);
        self.nextButton.hidden = (currentFlashCardID == flashcardCount-1);
        
        [self loadFlashcardsContent];
    }
}

- (void)setFlashcardViewType:(EVFlashcardViewType)flashcardViewType
{
    if (_flashcardViewType != flashcardViewType)
    {
        _flashcardViewType = flashcardViewType;
        for (EVFlashcardView *flashcardView in self.flashcardViews)
        {
            flashcardView.flashcardViewType = _flashcardViewType;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (animated)
    {
        for (int i=0; i<self.flashcardViews.count; i++)
        {
            EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:i];
            flashcardView.frame = CGRectMake(14.5 + self.view.bounds.size.width * (i-1), 70.0, 291.0, 291.0);
            flashcardView.flashcardViewType = self.flashcardViewType;
            
            // Tilt flashcard
            flashcardView.frontView.transform = CGAffineTransformMakeRotation(M_PI / 180 * DEFAULT_TILT_ANGLE);
            flashcardView.backView.transform = CGAffineTransformMakeRotation(- M_PI / 180 * DEFAULT_TILT_ANGLE);
            
            if (i==0 || i==2)
            {
                flashcardView.hidden = YES;
            }
        }
    }
    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
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
        flashcardView.delegate = self;
        [self.flashcardViews addObject:flashcardView];
        [self.view insertSubview:flashcardView belowSubview:self.walkthroughButton];
    }
    
    [self loadFlashcardsContent];
    
    self.prevButton.hidden = (self.currentFlashCardID == 0);
    self.nextButton.hidden = (self.currentFlashCardID == self.flashcardCollection.count - 1);
}

- (void)loadFlashcardsContent
{
    for (int i=0; i<self.flashcardViews.count; i++)
    {
        EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:i];
        
        flashcardView.flashcard = [self.flashcardCollection flashcardAtIndex:(self.currentFlashCardID + (i-1))];
        
        [flashcardView removeGestureRecognizer:self.flashcardTapGestureRecognizer];
        if (i == 1)
        {
            [flashcardView addGestureRecognizer:self.flashcardTapGestureRecognizer];
        }
    }
}

- (void)goToNextCard:(id)sender
  animationsAddition:(void (^)(void))animations
  completionAddition:(void (^)(BOOL finished))completion
{
    EVFlashcardView *firstCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:0];
    EVFlashcardView *secondCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:1];
    EVFlashcardView *thirdCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:2];
    CGRect thirdCardFrame = thirdCard.frame;
    
    firstCard.hidden = NO;
    thirdCard.hidden = NO;
    
    void (^nextAnimation)(void) = ^{
        [UIView animateWithDuration:DEFAULT_NEXT_PREV_DURATION
                         animations:^{
                             thirdCard.frame = secondCard.frame;
                             secondCard.frame = firstCard.frame;
                             if (animations) animations();
                         }
                         completion:^(BOOL finished) {
                             firstCard.frame = thirdCardFrame;
                             [self.flashcardViews exchangeObjectAtIndex:2 withObjectAtIndex:1];
                             [self.flashcardViews exchangeObjectAtIndex:2 withObjectAtIndex:0];
                             
                             self.currentFlashCardID++;
                             
                             if (completion) completion(finished);
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



#pragma mark - EVFlashcardViewDelegate methods

- (void)nextButtonOfFlashcardView:(EVFlashcardView *)flashcardView
                         selected:(UIButton *)sender
{
    
}

#pragma mark - Target/action

- (IBAction)flashcardSelected:(UITapGestureRecognizer *)sender {
    EVFlashcardView *flashcardView = [self.flashcardViews objectAtIndex:1];
    self.viewFlipper.flashcardView = flashcardView;
    if (!self.flipOnce || !self.viewFlipper.displayingBackView)
    {
        [EVSoundPlayer playClickSound];
        [self.viewFlipper flip];
    }
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

- (IBAction)prevButtonSelected:(UIButton *)sender {
    [EVSoundPlayer playClickSound];
    
    EVFlashcardView *firstCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:0];
    EVFlashcardView *secondCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:1];
    EVFlashcardView *thirdCard = (EVFlashcardView *)[self.flashcardViews objectAtIndex:2];
    CGRect firstCardFrame = firstCard.frame;
    
    firstCard.hidden = NO;
    thirdCard.hidden = NO;
    
    sender.enabled = NO;
    
    void (^prevAnimation)(void) = ^{
        [UIView animateWithDuration:DEFAULT_NEXT_PREV_DURATION
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
    [EVSoundPlayer playClickSound];
    sender.enabled = NO;
    
    [self goToNextCard:sender
    animationsAddition:nil
    completionAddition:^(BOOL finished) {
        sender.enabled = YES;
    }];
}

- (IBAction)settingButtonSelected:(UIButton *)sender {
    [EVSoundPlayer playClickSound];
    [EVSettingViewController presentSettingViewControllerWithStoryboard:self.storyboard andParentViewController:self];
}

@end
