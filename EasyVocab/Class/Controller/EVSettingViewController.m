//
//  EVSettingViewController.m
//  EasyVocab
//
//  Created by Dung Nguyen on 5/10/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVSettingViewController.h"

@interface EVSettingViewController ()

@property (weak, nonatomic) UIViewController *parent;

@end

@implementation EVSettingViewController

+ (EVSettingViewController *)settingViewControllerWithStoryboard:(UIStoryboard *)storyboard
                                         andParentViewController:(UIViewController *)parent
{
    EVSettingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EVSettingViewController"];
    vc.parent = parent;
    return vc;
}

+ (EVSettingViewController *)presentSettingViewControllerWithStoryboard:(UIStoryboard *)storyboard
                           andParentViewController:(UIViewController *)parent
{
    EVSettingViewController *vc = [EVSettingViewController settingViewControllerWithStoryboard:storyboard
                                                                       andParentViewController:parent];
    [parent presentViewController:vc animated:YES completion:nil];
    return vc;
}

- (IBAction)backButtonSelected:(UIButton *)sender {
    [self.parent dismissViewControllerAnimated:YES
                                    completion:nil];
}

@end
