//
//  EVFlashcardView.h
//  EasyVocab
//
//  Created by Dung Nguyen on 4/18/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVFlashcardView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *frontView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *answer;

- (IBAction)speakerSelected:(id)sender;

@end
