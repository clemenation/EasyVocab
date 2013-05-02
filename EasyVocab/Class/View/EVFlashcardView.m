//
//  EVFlashcardView.m
//  EasyVocab
//
//  Created by Dung Nguyen on 4/18/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardView.h"
#import "EVGoogleTranslateTTS.h"

@interface EVFlashcardView()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@property (strong, nonatomic) EVGoogleTranslateTTS *tts;

@end

@implementation EVFlashcardView

@synthesize image               = _image;
@synthesize answer              = _answer;
@synthesize tts                 = _tts;
@synthesize containerView       = _containerView;
@synthesize flashcardViewType   = _flashcardViewType;

- (void)setFlashcardViewType:(EVFlashcardViewType)flashcardViewType
{
    _flashcardViewType = flashcardViewType;
    
    switch (_flashcardViewType)
    {
        case EVFlashcardViewLearn:
            self.answerLabel.hidden = self.speakerButton.hidden = NO;
            self.nextButton.hidden = YES;
            for (UIButton *button in self.answerButtons) button.hidden = YES;
            break;
        case EVFlashcardViewPracticeEasy:
            self.answerLabel.hidden = self.speakerButton.hidden = self.nextButton.hidden = YES;
            for (UIButton *button in self.answerButtons) button.hidden = NO;
            break;
        case EVFlashcardViewPracticeChallenge:
            
            break;
        case EVFlashcardViewPracticeAnswer:
            
            break;
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        self.imageView.image = _image;
    }
}

- (void)setAnswer:(NSString *)answer
{
    if (_answer != answer)
    {
        _answer = answer;
        self.answerLabel.text = [_answer uppercaseString];
        self.answerLabel.font = [UIFont fontWithName:@"UVNVanBold" size:30];
    }
}



#pragma mark - Target/action

- (IBAction)speakerSelected:(id)sender {
    self.tts = [[EVGoogleTranslateTTS alloc] initWithLanguage:@"en" andContent:self.answer];
    [self.tts startAsynchronous];
}
@end
