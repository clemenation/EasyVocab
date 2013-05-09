//
//  EVViewFlipper.m
//  EasyVocab
//
//  Created by Dung Nguyen on 4/15/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EVViewFlipper.h"

@interface EVViewFlipper()

- (void)flipFrontView;
- (void)flipBackView;

@property (strong, nonatomic) CAAnimationGroup *frontViewAnimation;
@property (strong, nonatomic) CAAnimationGroup *backViewAnimation;
@property (assign, nonatomic) CGFloat currentTiltAngle;
@property (copy, nonatomic) void (^completion)(void);

@end

@implementation EVViewFlipper

@synthesize frontViewAnimation  = _frontViewAnimation;
@synthesize backViewAnimation   = _backViewAnimation;
@synthesize currentFrontView    = _currentFrontView;
@synthesize currentBackView     = _currentBackView;
@synthesize currentTiltAngle    = _currentTiltAngle;
@synthesize flashcardView       = _flashcardView;



#pragma mark - Setters/getters

- (void)setFlashcardView:(EVFlashcardView *)flashcardView
{
    if (_flashcardView != flashcardView)
    {
        _flashcardView = flashcardView;
        _flashcardView.frontView.layer.zPosition = _flashcardView.frontView.frame.size.width/2;        
        _flashcardView.backView.layer.zPosition = _flashcardView.backView.frame.size.width/2;
        
        _currentBackView = nil;     // reset
        _currentFrontView = nil;    // reset
        _currentTiltAngle = self.tiltAngle;
    }
}

- (CGFloat)currentTiltAngle
{
    if (abs(_currentTiltAngle) != abs(self.tiltAngle))
    {
        _currentTiltAngle = self.tiltAngle;
    }
    return _currentTiltAngle;
}

- (UIView *)currentFrontView
{
    if (!_currentFrontView)
    {
        _currentFrontView = self.flashcardView.frontView;
        _currentFrontView.hidden = NO;
    }
    return _currentFrontView;
}

- (UIView *)currentBackView
{
    if (!_currentBackView)
    {
        _currentBackView = self.flashcardView.backView;
        _currentBackView.hidden = YES;
    }
    return _currentBackView;
}

- (BOOL)displayingBackView
{
    return (self.currentFrontView != self.flashcardView.frontView);
}



#pragma mark - Class methods

- (id)init
{
    if (self = [super init])
    {
        static CGFloat DEFAULT_DURATION = 0.4f;
        self.duration = DEFAULT_DURATION;
        
        static CGFloat DEFAULT_TILT_ANGLE = 5.0f;
        self.tiltAngle = DEFAULT_TILT_ANGLE;
    }
    return self;
}

- (void)flip
{
    [self flip:nil];
}

- (void)flip:(void (^)(void))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewFlipperWillFlip:)])
    {
        [self.delegate viewFlipperWillFlip:self];
    }
    self.completion = completion;
    [self flipFrontView];
}

- (void)flipFrontView
{
    CATransform3D initialScale = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CATransform3D initialTransform = CATransform3DRotate(initialScale, 0.0, 0.0, -1.0, 0.0);
    CATransform3D finalTransform = CATransform3DRotate(initialScale, -M_PI/2, 0.0, -1.0, 0.0);
    CATransform3D initialTilt = CATransform3DRotate(initialTransform, M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, 1.0);
    CATransform3D finalTilt = CATransform3DRotate(finalTransform, M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, 1.0);
    
    NSMutableArray *animations = [NSMutableArray array];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:initialTilt];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:finalTilt];
    transformAnimation.duration = self.duration/2;
    [animations addObject:transformAnimation];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:animations];
    [animationGroup setDuration:self.duration/2];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.delegate = self;
    
    self.frontViewAnimation = animationGroup;
    
    [self.currentFrontView.layer addAnimation:animationGroup forKey:@"flipFrontView"];
}

- (void)flipBackView
{
    CATransform3D initialScale = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CATransform3D initialTransform = CATransform3DRotate(initialScale, M_PI/2, 0.0, -1.0, 0.0);
    CATransform3D finalTransform = CATransform3DRotate(initialScale, 0, 0.0, -1.0, 0.0);
    CATransform3D initialTilt = CATransform3DRotate(initialTransform, M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, -1.0);
    CATransform3D finalTilt = CATransform3DRotate(finalTransform, M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, -1.0);
    
    NSMutableArray *animations = [NSMutableArray array];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:initialTilt];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:finalTilt];
    transformAnimation.duration = self.duration/2;
    [animations addObject:transformAnimation];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:animations];
    [animationGroup setDuration:self.duration/2];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.delegate = self;
    
    self.backViewAnimation = animationGroup;
    
    [self.currentBackView.layer addAnimation:animationGroup forKey:@"flipBackView"];
}



#pragma mark - CAAnimation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.currentFrontView.layer animationForKey:@"flipBackView"])
    {
        if (self.completion != nil)
        {
            self.completion();
        }
        if (self.delegate)
        {
            [self.delegate viewFlipperDidFlipped:self];
        }
    }
    else if (anim == [self.currentFrontView.layer animationForKey:@"flipFrontView"])
    {
        self.currentFrontView.hidden = YES;
        self.currentBackView.hidden = NO;
        
        [self flipBackView];
        
        // Switch current front/back view role
        UIView *temp = self.currentFrontView;
        self.currentFrontView = self.currentBackView;
        self.currentBackView = temp;
        
        self.currentTiltAngle = -self.currentTiltAngle;
    }
}

@end
