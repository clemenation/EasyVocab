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

@synthesize flashcard           = _flashcard;
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

- (void)setFlashcard:(EVFlashcard *)flashcard
{
    if (_flashcard != flashcard)
    {
        _flashcard = flashcard;
        self.imageView.image = _flashcard.image;
        self.answerLabel.text = [_flashcard.answer uppercaseString];
        self.answerLabel.font = [UIFont fontWithName:@"UVNVanBold" size:30];
    }
}

- (void)setChoices:(NSArray *)choices
{
    if (_choices != choices && choices.count == 4)
    {
        _choices = choices;
        for (int i=0; i<4; i++)
        {
            UIButton *button = [self.answerButtons objectAtIndex:i];
            [button setTitle:[[choices objectAtIndex:i] uppercaseString]
                    forState:UIControlStateNormal];
            ((UIButton *)[self.answerButtons objectAtIndex:i]).titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:20];
        }
    }
}



#pragma mark - Target/action

- (IBAction)choiceChosen:(UIButton *)sender {
    for (UIButton *button in self.answerButtons)
    {
        if (button == sender)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"practice_back_easy_button_choice_selected.png"]
                              forState:UIControlStateNormal];
            [button setTag:YES];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"practice_back_easy_button_choice.png"]
                              forState:UIControlStateNormal];
            [button setTag:NO];
        }
    }
}

- (BOOL)checkAnswer
{
    for (UIButton *button in self.answerButtons)
    {
        if (button.tag == YES &&
            [[button titleForState:UIControlStateNormal] isEqualToString:[self.flashcard.answer uppercaseString]])
        {
            return YES;
        }
    }
    return NO;
}

- (IBAction)speakerSelected:(id)sender {
    self.tts = [[EVGoogleTranslateTTS alloc] initWithLanguage:@"en" andContent:self.flashcard.answer];
    [self.tts startAsynchronous];
}
@end
