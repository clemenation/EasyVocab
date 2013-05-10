//
//  EVSettingViewController.m
//  EasyVocab
//
//  Created by Dung Nguyen on 5/10/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVSettingViewController.h"
#import "EVSoundPlayer.h"
#import "EVWalkthroughManager.h"

@interface EVSettingViewController ()

@property (weak, nonatomic) UIViewController    *parent;
@property (weak, nonatomic) IBOutlet UIButton   *soundButton;
@property (weak, nonatomic) IBOutlet UIButton   *musicButton;
@property (weak, nonatomic) IBOutlet UIButton   *walkthroughButton;
@property (strong, nonatomic) NSDictionary      *settingDictionary;

- (void)reloadSetting;

@end

@implementation EVSettingViewController

#pragma mark - Setters/getters

@synthesize settingDictionary = _settingDictionary;

- (NSDictionary *)settingDictionary
{
    if (!_settingDictionary)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _settingDictionary = [userDefaults objectForKey:@"Settings"];
        if (!_settingDictionary)
        {
            _settingDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES], @"Sound",
                                  [NSNumber numberWithBool:YES], @"Music",
                                  nil];
            [userDefaults setObject:_settingDictionary forKey:@"Settings"];
            [userDefaults synchronize];
        }
    }
    return _settingDictionary;
}

- (void)setSettingDictionary:(NSDictionary *)settingDictionary
{
    if (_settingDictionary != settingDictionary)
    {
        if ([settingDictionary objectForKey:@"Sound"] &&
            [settingDictionary objectForKey:@"Music"])
        {
            _settingDictionary = settingDictionary;
            [[NSUserDefaults standardUserDefaults] setObject:_settingDictionary forKey:@"Settings"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self reloadSetting];
        }
    }
}

#pragma mark - Class methods

+ (void)reloadSetting
{
    [[[EVSettingViewController alloc] init] reloadSetting];
}

- (void)reloadSetting
{    
    if (((NSNumber *)[self.settingDictionary objectForKey:@"Sound"]).boolValue)
    {
        self.soundButton.alpha = 1.0f;
        [EVSoundPlayer setGlobalVolume:1.0f];
    }
    else
    {
        self.soundButton.alpha = 0.5f;
        [EVSoundPlayer setGlobalVolume:0.0f];
    }
    
    if (((NSNumber *)[self.settingDictionary objectForKey:@"Music"]).boolValue)
    {
        self.musicButton.alpha = 1.0f;
        [EVSoundPlayer setBackgroundMusicVolume:1.0f];
    }
    else
    {
        self.musicButton.alpha = 0.5f;
        [EVSoundPlayer setBackgroundMusicVolume:0.0f];
    }    
}

- (void)viewDidLoad
{
    [self reloadSetting];
}

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

#pragma mark - Target/action

- (IBAction)backButtonSelected:(UIButton *)sender {
    [self.parent dismissViewControllerAnimated:YES
                                    completion:nil];
}

- (IBAction)soundButtonSelected:(UIButton *)sender {
    BOOL sound = (((NSNumber *)[self.settingDictionary objectForKey:@"Sound"]).boolValue);
    NSMutableDictionary *setting = [self.settingDictionary mutableCopy];
    [setting setObject:[NSNumber numberWithBool:!sound]
                forKey:@"Sound"];
    self.settingDictionary = setting;
    
    if (!sound)
    {
        [EVSoundPlayer playClickSound];
    }
}

- (IBAction)musicButtonSelected:(UIButton *)sender {
    BOOL music = (((NSNumber *)[self.settingDictionary objectForKey:@"Music"]).boolValue);
    NSMutableDictionary *setting = [self.settingDictionary mutableCopy];
    [setting setObject:[NSNumber numberWithBool:!music]
                forKey:@"Music"];
    self.settingDictionary = setting;
}

- (IBAction)walkthroughButtonSelected:(UIButton *)sender {
    [EVWalkthroughManager resetWalkthrough];
    
//    self.walkthroughButton.alpha = 0.5f;
    self.walkthroughButton.enabled = NO;
}

@end
