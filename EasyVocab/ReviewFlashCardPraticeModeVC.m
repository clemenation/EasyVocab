//
//  ReviewFlashCardPraticeModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ReviewFlashCardPraticeModeVC.h"

@interface ReviewFlashCardPraticeModeVC ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *awesomeLabel;

@end

@implementation ReviewFlashCardPraticeModeVC

@synthesize isGiveUp = _isGiveUp;

- (void)setIsGiveUp:(BOOL)isGiveUp
{
    if (_isGiveUp != isGiveUp)
    {
        _isGiveUp = isGiveUp;
        self.awesomeLabel.hidden = _isGiveUp;
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
	
	self.textLabel.text = [self.correctAnswer uppercaseString];
    self.textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:30];
    self.awesomeLabel.hidden = self.isGiveUp;
}

#pragma mark - Buttons

- (IBAction)speakAnswerPressed:(id)sender {
	
}

- (IBAction)nextAnswerPressed:(id)sender {
	
}

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToLearn:(id)sender {
	[self.tabBarController setSelectedIndex:0];
}



@end
