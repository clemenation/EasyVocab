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

@property (assign, nonatomic) CGFloat currentTiltAngle;

- (void)flipFrontView;
- (void)flipBackView;
- (void)animateLayer:(CALayer *)layer
       fromTransform:(CATransform3D)initialTransform
         toTransform:(CATransform3D)finalTransform
            duration:(NSTimeInterval)duration
      timingFunction:(NSString *)timingFunctionName
              forKey:(NSString *)key;

@end

@implementation EVViewFlipper

@synthesize currentFrontView        = _currentFrontView;
@synthesize currentBackView         = _currentBackView;
@synthesize currentTiltAngle        = _currentTiltAngle;
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

- (void)setPrevFlashcardView:(EVFlashcardView *)prevFlashcardView
{
    if (_prevFlashcardView != prevFlashcardView)
    {
        _prevFlashcardView = prevFlashcardView;
        _prevFlashcardView.layer.zPosition = _prevFlashcardView.frame.size.width/2;
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

- (void)animateLayer:(CALayer *)layer
       fromTransform:(CATransform3D)initialTransform
         toTransform:(CATransform3D)finalTransform
            duration:(NSTimeInterval)duration
      timingFunction:(NSString *)timingFunctionName
              forKey:(NSString *)key
{
    NSMutableArray *animations = [NSMutableArray array];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:initialTransform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:finalTransform];
    transformAnimation.duration = duration;
    [animations addObject:transformAnimation];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:animations];
    [animationGroup setDuration:duration];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    animationGroup.delegate = self;
    
    [layer addAnimation:animationGroup forKey:key];
}

- (void)next
{
    if (self.currentFrontView == self.mainFlashcardView.frontView)
    {
        // currently showing front view, flip it first
        self.isSwitchingToNext = YES;
        [self flip];
    }
    else
    {
        [self nextToMain];
        [self mainToPrev];
    }
}

- (void)nextToMain
{
    CGFloat scale = self.mainCardFrame.size.height / self.nextCardFrame.size.height;
    CATransform3D initialTransform = self.nextFlashcardView.layer.transform;
    CATransform3D finalTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                          (self.mainCardFrame.origin.x - self.nextCardFrame.origin.x),
                                                          (self.mainCardFrame.origin.y - self.nextCardFrame.origin.y),
                                                          0.0);
    finalTransform = CATransform3DTranslate(finalTransform,
                                            (self.mainCardFrame.size.width - self.nextCardFrame.size.width)/2,
                                            (self.mainCardFrame.size.height - self.nextCardFrame.size.height)/2,
                                            0.0);
    finalTransform = CATransform3DScale(finalTransform, scale, scale, 1.0);
    finalTransform = CATransform3DRotate(finalTransform, M_PI / 180 * self.tiltAngle, 0.0, 0.0, 1.0);
    
    [self animateLayer:self.nextFlashcardView.layer
         fromTransform:initialTransform
           toTransform:finalTransform
              duration:self.duration
        timingFunction:kCAMediaTimingFunctionEaseInEaseOut
                forKey:@"nextToMain"];
}

- (void)mainToPrev
{
    CGFloat scale = self.prevCardFrame.size.height / self.mainCardFrame.size.height;
    CATransform3D initialTransform = CATransform3DRotate(CATransform3DIdentity, - M_PI / 180 * self.tiltAngle, 0, 0, 1);
    CATransform3D finalTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                          (self.prevCardFrame.origin.x - self.mainCardFrame.origin.x),
                                                          (self.prevCardFrame.origin.y - self.mainCardFrame.origin.y),
                                                          0.0);
    finalTransform = CATransform3DTranslate(finalTransform,
                                            (self.prevCardFrame.size.width - self.mainCardFrame.size.width)/2,
                                            (self.prevCardFrame.size.height - self.mainCardFrame.size.height)/2,
                                            0.0);
    finalTransform = CATransform3DScale(finalTransform, scale, scale, 1.0);
    
    [self animateLayer:self.mainFlashcardView.layer
         fromTransform:initialTransform
           toTransform:finalTransform
              duration:self.duration
        timingFunction:kCAMediaTimingFunctionEaseInEaseOut
                forKey:@"mainToPrev"];
}

- (void)flip
{
    [self flipFrontView];
}

- (void)flipFrontView
{
    CATransform3D initialTransform = CATransform3DRotate(CATransform3DIdentity, M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, 1.0);
    CATransform3D finalTransform = CATransform3DRotate(CATransform3DIdentity, -M_PI/2, 0.0, -1.0, 0.0);
    finalTransform = CATransform3DRotate(finalTransform, M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, 1.0);
    
    [self animateLayer:self.mainFlashcardView.layer
         fromTransform:initialTransform
           toTransform:finalTransform
              duration:self.duration/2
        timingFunction:kCAMediaTimingFunctionEaseIn
                forKey:@"frontViewFlip"];
}

- (void)flipBackView
{
    CATransform3D initialTransform = CATransform3DRotate(CATransform3DIdentity, -M_PI/2, 0.0, 1.0, 0.0);
    initialTransform = CATransform3DRotate(initialTransform, - M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, 1.0);
    CATransform3D finalTransform = CATransform3DRotate(CATransform3DIdentity, - M_PI / 180 * self.currentTiltAngle, 0.0, 0.0, 1.0);
    
    [self animateLayer:self.mainFlashcardView.layer
         fromTransform:initialTransform
           toTransform:finalTransform
              duration:self.duration/2
        timingFunction:kCAMediaTimingFunctionEaseOut
                forKey:@"backViewFlip"];
}



#pragma mark - CAAnimation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.mainFlashcardView.layer animationForKey:@"frontViewFlip"])
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
    else if (anim == [self.mainFlashcardView.layer animationForKey:@"backViewFlip"])
    {
        if (self.isSwitchingToNext)
        {
            self.isSwitchingToNext = NO;
            [self nextToMain];
            [self mainToPrev];            
        }
    }
    else if (anim == [self.mainFlashcardView.layer animationForKey:@"mainToPrev"])
    {
        
    }
}

@end
