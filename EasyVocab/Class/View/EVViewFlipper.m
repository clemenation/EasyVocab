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

@end

@implementation EVViewFlipper

@synthesize frontViewAnimation      = _frontViewAnimation;
@synthesize backViewAnimation       = _backViewAnimation;
@synthesize currentFrontView        = _currentFrontView;
@synthesize currentBackView         = _currentBackView;
@synthesize currentTiltAngle        = _currentTiltAngle;
@synthesize prevCardFrame           = _prevStackFrame;
@synthesize nextFlashcardView       = _nextFlashcardView;
@synthesize mainFlashcardView       = _mainFlashcardView;



#pragma mark - Setters/getters

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
        _currentFrontView = self.mainFlashcardView.frontView;
        _currentFrontView.hidden = NO;
    }
    return _currentFrontView;
}

- (UIView *)currentBackView
{
    if (!_currentBackView)
    {
        _currentBackView = self.mainFlashcardView.backView;
        _currentBackView.hidden = YES;
    }
    return _currentBackView;
}

- (void)setMainFlashcardView:(EVFlashcardView *)mainFlashcardView
{
    if (_mainFlashcardView != mainFlashcardView)
    {
        _mainFlashcardView = mainFlashcardView;
        _mainFlashcardView.frontView.layer.zPosition = _mainFlashcardView.frontView.frame.size.width/2;
        _mainFlashcardView.backView.layer.zPosition = _mainFlashcardView.backView.frame.size.width/2;
    }
}

- (void)setNextFlashcardView:(EVFlashcardView *)nextFlashcardView
{
    if (_nextFlashcardView != nextFlashcardView)
    {
        _nextFlashcardView = nextFlashcardView;
        _nextFlashcardView.layer.zPosition = _nextFlashcardView.frame.size.width/2;
    }
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

- (void)next
{
    [self nextToCurrent];
    [self currentToPrev];
}

- (void)nextToCurrent
{
    CGFloat scale = self.mainCardFrame.size.height / self.nextCardFrame.size.height;
    CATransform3D initialTransform = CATransform3DIdentity;
    CATransform3D finalTransform = CATransform3DTranslate(initialTransform,
                                                          (self.mainCardFrame.origin.x - self.nextCardFrame.origin.x),
                                                          (self.mainCardFrame.origin.y - self.nextCardFrame.origin.y),
                                                          0.0);
    finalTransform = CATransform3DTranslate(finalTransform,
                                            (self.mainCardFrame.size.width - self.nextCardFrame.size.width)/2,
                                            (self.mainCardFrame.size.height - self.nextCardFrame.size.height)/2,
                                            0.0);
    finalTransform = CATransform3DScale(finalTransform, scale, scale, 1.0);
    finalTransform = CATransform3DRotate(finalTransform, M_PI / 180 * self.tiltAngle, 0.0, 0.0, 1.0);
    
    NSMutableArray *animations = [NSMutableArray array];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:initialTransform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:finalTransform];
    transformAnimation.duration = self.duration;
    [animations addObject:transformAnimation];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:animations];
    [animationGroup setDuration:self.duration];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.nextFlashcardView.layer addAnimation:animationGroup forKey:@"anim"];
}

- (void)currentToPrev
{
    
}

- (void)flip
{
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
    
    [self.currentFrontView.layer addAnimation:animationGroup forKey:@"anim"];
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
    
    self.backViewAnimation = animationGroup;
    
    [self.currentBackView.layer addAnimation:animationGroup forKey:@"anim"];
}



#pragma mark - CAAnimation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.currentFrontView.layer animationForKey:@"anim"])
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
