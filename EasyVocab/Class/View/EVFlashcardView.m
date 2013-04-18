//
//  EVFlashcardView.m
//  EasyVocab
//
//  Created by Dung Nguyen on 4/18/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVFlashcardView.h"

@interface EVFlashcardView()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EVFlashcardView

@synthesize image = _image;
@synthesize answer = _answer;

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
        self.answerLabel.text = answer;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
