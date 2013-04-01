//
//  ReviewFlashCardPraticeModeVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "ReviewFlashCardPraticeModeVC.h"
#import "EVGoogleTranslateTTS.h"
#import "EVWalkthroughManager.h"

@interface ReviewFlashCardPraticeModeVC ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *awesomeLabel;
@property (strong, nonatomic) EVGoogleTranslateTTS *tts;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;

@end

@implementation ReviewFlashCardPraticeModeVC

@synthesize isGiveUp = _isGiveUp;
@synthesize tts = _tts;

- (void)setIsGiveUp:(BOOL)isGiveUp
{
    if (_isGiveUp != isGiveUp)
    {
        _isGiveUp = isGiveUp;
        self.awesomeLabel.hidden = _isGiveUp;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.textLabel.text = [self.correctAnswer uppercaseString];
    self.textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:30];
    self.awesomeLabel.hidden = self.isGiveUp;
    
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];
}

#pragma mark - Buttons

- (IBAction)speakAnswerPressed:(id)sender {
	self.tts = [[EVGoogleTranslateTTS alloc] initWithLanguage:@"en" andContent:self.correctAnswer];
    [self.tts startAsynchronous];
}

- (IBAction)nextAnswerPressed:(id)sender {
	
}

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES
                                  forController:NSStringFromClass(self.class)];
}

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToLearn:(id)sender {
	[self.tabBarController setSelectedIndex:0];
}



@end
