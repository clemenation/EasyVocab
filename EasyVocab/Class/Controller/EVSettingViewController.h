//
//  EVSettingViewController.h
//  EasyVocab
//
//  Created by Dung Nguyen on 5/10/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVSettingViewController : UIViewController

@property (weak, nonatomic) UIButton *settingButton;

+ (EVSettingViewController *)settingViewControllerWithStoryboard:(UIStoryboard *)storyboard
                                         andParentViewController:(UIViewController *)parent;
+ (EVSettingViewController *)presentSettingViewControllerWithStoryboard:(UIStoryboard *)storyboard
                                         andParentViewController:(UIViewController *)parent;

@end
