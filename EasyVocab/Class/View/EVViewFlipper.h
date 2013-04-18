//
//  EVViewFlipper.h
//  EasyVocab
//
//  Created by Dung Nguyen on 4/15/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVFlashcardView.h"

@interface EVViewFlipper : NSObject

@property (assign, nonatomic) BOOL displayingBackView;
@property (assign, nonatomic) CGFloat duration;

@property (weak, nonatomic) UIView *currentFrontView;
@property (weak, nonatomic) UIView *currentBackView;

@property (weak, nonatomic) EVFlashcardView *mainFlashcardView;
@property (weak, nonatomic) EVFlashcardView *nextFlashcardView;
@property (weak, nonatomic) EVFlashcardView *prevFlashcardView;

@property (assign, nonatomic) CGRect nextCardFrame;
@property (assign, nonatomic) CGRect prevCardFrame;
@property (assign, nonatomic) CGRect mainCardFrame;
@property (assign, nonatomic) CGFloat tiltAngle;

- (void)flip;
- (void)next;

@end
