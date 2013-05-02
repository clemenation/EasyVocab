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

@property (strong, nonatomic) EVGoogleTranslateTTS *tts;

@end

@implementation EVFlashcardView

@synthesize image = _image;
@synthesize answer = _answer;
@synthesize tts = _tts;
@synthesize containerView = _containerView;

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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    self.speakerButton.center = CGPointMake(self.center.x, self.speakerButton.center.y);
//    self.speakerButton.transform = CGAffineTransformScale(self.speakerButton.transform, self.frame.size.width/291.0, self.frame.size.height/291.0);
}



#pragma mark - Target/action

- (IBAction)speakerSelected:(id)sender {
    self.tts = [[EVGoogleTranslateTTS alloc] initWithLanguage:@"en" andContent:self.answer];
    [self.tts startAsynchronous];
}
@end
