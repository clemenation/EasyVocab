//
//  EVViewFlipper.h
//  EasyVocab
//
//  Created by Dung Nguyen on 4/15/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVViewFlipper : NSObject

@property (assign, nonatomic) BOOL displayingBackView;
@property (assign, nonatomic) CGFloat duration;

@property (weak, nonatomic) UIView *currentFrontView;
@property (weak, nonatomic) UIView *currentBackView;

@property (weak, nonatomic) UIView *frontView;
@property (weak, nonatomic) UIView *backView;

@property (assign, nonatomic) CGRect frontStackFrame;
@property (assign, nonatomic) CGRect backStackFrame;
@property (assign, nonatomic) CGRect currentCardFrame;
@property (assign, nonatomic) CGFloat tiltAngle;

- (void)flip;

@end
