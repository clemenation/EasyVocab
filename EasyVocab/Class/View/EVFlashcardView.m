//
//  EVFlashcardView.m
//  EasyVocab
//
//  Created by Dung Nguyen on 4/18/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardView.h"
#import "EVGoogleTranslateTTS.h"

@interface EVFlashcardView() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel        *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UIButton       *speakerButton;
@property (weak, nonatomic) IBOutlet UIButton       *nextButton;
@property (weak, nonatomic) IBOutlet UIButton       *checkButton;
@property (weak, nonatomic) IBOutlet UILabel        *pronounciationLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@property (strong, nonatomic) EVGoogleTranslateTTS  *tts;

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
            self.pronounciationLabel.hidden = self.answerLabel.hidden = self.speakerButton.hidden = NO;
            self.nextButton.hidden =
            self.answerTextField.hidden = self.checkButton.hidden = YES;
            [self.answerTextField resignFirstResponder];
            for (UIButton *button in self.answerButtons) button.hidden = YES;
            self.speakerButton.frame = CGRectMake(116, 195, 59, 54);
            break;
        case EVFlashcardViewPracticeEasy:
            self.answerLabel.hidden = self.speakerButton.hidden = self.nextButton.hidden =
            self.pronounciationLabel.hidden = self.answerTextField.hidden = self.checkButton.hidden = YES;
            [self.answerTextField resignFirstResponder];
            for (UIButton *button in self.answerButtons) button.hidden = NO;
            break;
        case EVFlashcardViewPracticeChallenge:
            self.answerTextField.hidden = self.checkButton.hidden = NO;
            self.pronounciationLabel.hidden = self.answerLabel.hidden = self.speakerButton.hidden = self.nextButton.hidden = YES;
            for (UIButton *button in self.answerButtons) button.hidden = YES;
            break;
        case EVFlashcardViewPracticeAnswer:
            self.answerTextField.hidden = self.checkButton.hidden = YES;
            self.pronounciationLabel.hidden = self.answerLabel.hidden = self.speakerButton.hidden = self.nextButton.hidden = NO;
            [self.answerTextField resignFirstResponder];
            for (UIButton *button in self.answerButtons) button.hidden = YES;
            self.speakerButton.frame = CGRectMake(65, 195, 59, 54);
            break;
    }
}

- (void)setFlashcard:(EVFlashcard *)flashcard
{
    if (_flashcard != flashcard)
    {
        _flashcard = flashcard;
        self.imageView.image = _flashcard.image;
        self.pronounciationLabel.text = [NSString stringWithFormat:@"| %@ |", _flashcard.pronounciation];
        self.answerLabel.text = [_flashcard.answer uppercaseString];
        self.answerLabel.font = [UIFont fontWithName:@"UVNVanBold" size:30];
        [self choiceChosen:nil];    // reset selected choice
        self.answerTextField.text = @"";
        self.answerTextField.font = [UIFont fontWithName:@"UVNVanBold" size:20];
        self.answerTextField.background = [UIImage imageNamed:@"practice_back_challenge_answer_field.png"];
    }
}



#pragma mark - Target/action

- (BOOL)checkAnswer
{
    switch (self.flashcardViewType)
    {
        case EVFlashcardViewPracticeEasy:
        {
            for (UIButton *button in self.answerButtons)
            {
                if (button.tag == YES)
                {
                    if ([[button titleForState:UIControlStateNormal] isEqualToString:[self.flashcard.answer uppercaseString]])
                    {
                        return YES;
                    }
                    else
                    {
                        button.enabled = NO;
                    }
                }
            }
            return NO;
            break;
        }
        case EVFlashcardViewPracticeChallenge:
        {
            if ([[self.answerTextField.text capitalizedString] isEqualToString:[self.flashcard.answer capitalizedString]])
            {
                [self.answerTextField resignFirstResponder];
                self.answerTextField.background = [UIImage imageNamed:@"practice_back_challenge_answer_field.png"];
                return YES;
            }
            else
            {
                self.answerTextField.background = [UIImage imageNamed:@"practice_back_challenge_answer_field_wrong.png"];
                return NO;
            }
            break;
        }
        default:
            return NO;
    }

    return NO;
}



#pragma mark - Back side answer

- (IBAction)speakerSelected:(id)sender {
    self.tts = [[EVGoogleTranslateTTS alloc] initWithLanguage:@"en" andContent:self.flashcard.answer];
    [self.tts startAsynchronous];
}



#pragma mark - Back side answer easy

- (IBAction)nextButtonSelected:(UIButton *)sender {
    if (self.delegate)
    {
        [self.delegate nextButtonOfFlashcardView:self
                                        selected:sender];
    }
}

#pragma mark - Back side practice easy

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

#pragma mark - Back side practice challenge

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.answerTextField.background = [UIImage imageNamed:@"practice_back_challenge_answer_field.png"];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.answerTextField.background = [UIImage imageNamed:@"practice_back_challenge_answer_field.png"];
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	self.answerTextField.background = [UIImage imageNamed:@"practice_back_challenge_answer_field.png"];
	return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)checkButtonSelected:(UIButton *)sender {
    if (self.delegate) [self.delegate checkButtonOfFlashcardView:self
                                                        selected:sender
                                                          result:[self checkAnswer]];
}

@end
