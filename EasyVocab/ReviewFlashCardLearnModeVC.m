//
//  ReviewFlashCardLearnModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ReviewFlashCardLearnModeVC.h"
#import "ChoosePracticeModeVC.h"
#import "EVFlashcardCollection.h"

@interface ReviewFlashCardLearnModeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation ReviewFlashCardLearnModeVC

@synthesize currentFlashcardID = _currentFlashcardID;
@synthesize flashcardCollection = _flashcardCollection;
@synthesize correctAnswer = _correctAnswer;

- (EVFlashcardCollection *)flashcardCollection
{
    if (!_flashcardCollection)
    {
        _flashcardCollection = [[EVFlashcardCollection alloc] init];
    }
    return _flashcardCollection;
}

- (void)setCurrentFlashcardID:(int)currentFlashcardID
{
    if (_currentFlashcardID != currentFlashcardID)
    {
        int flashcardCount = [self.flashcardCollection numberOfFlashcardInCategory:self.currentCategory];
        if (currentFlashcardID >= 0 && currentFlashcardID < flashcardCount)
        {
            _currentFlashcardID = currentFlashcardID;            
            self.correctAnswer = [self.flashcardCollection answerAtIndex:_currentFlashcardID
                                                            ofCategory:self.currentCategory];
            
            self.prevButton.hidden = (_currentFlashcardID == 0);
            self.nextButton.hidden = (_currentFlashcardID == flashcardCount-1);
        }
    }
}

- (void)setCorrectAnswer:(NSString *)correctAnswer
{
    if (correctAnswer != _correctAnswer)
    {
        _correctAnswer = correctAnswer;
        self.textLabel.text = [self.correctAnswer uppercaseString];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.textLabel.text = [self.correctAnswer uppercaseString];
}

#pragma mark - Target/action

- (IBAction)prevButtonSelected:(UIButton *)sender
{
    self.currentFlashcardID--;
}

- (IBAction)nextButtonSelected:(UIButton *)sender
{
    self.currentFlashcardID++;
}


#pragma mark - Buttons fake Tabbar

- (IBAction)switchToPratice:(id)sender {
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
