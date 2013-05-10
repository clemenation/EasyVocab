//
//  CategoryPickerVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/20/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CategoryPickerVC.h"
#import "FlashCardCollectionVC.h"
#import "ChoosePracticeModeVC.h"
#import "EVWalkthroughManager.h"
#import "EVSoundPlayer.h"

@interface CategoryPickerVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) BOOL wasAtPractice;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;
@property (assign, nonatomic) BOOL hasReadWalkthrough;

@end

@implementation CategoryPickerVC{
	NSString * choosenCategoryName;
	int shellPerPage;
	NSArray * categories;
	NSArray * colorIndex;
}

@synthesize wasAtPractice = _wasAtPractice;

#pragma mark - Setters/getters

- (BOOL)hasReadWalkthrough
{
    return [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass([self class])];
}

- (void)setHasReadWalkthrough:(BOOL)hasReadWalkthrough
{
    [EVWalkthroughManager setHasReadWalkthrough:hasReadWalkthrough forController:NSStringFromClass([self class])];
}


#pragma mark - Class methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//	
//	iconPath = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"iconbeast"];
//	//	NSLog(@"iconPath=%@",iconPath);
	shellPerPage=4;
	categories=[NSArray arrayWithObjects:@"food",@"numbers",@"animals",@"domestic",nil];
	colorIndex=[NSArray arrayWithObjects:@"blue",@"orange",@"purple",@"yellow",nil];
	
	self.pageControl.numberOfPages = categories.count/shellPerPage;
	if (categories.count%shellPerPage!=0)self.pageControl.numberOfPages ++;
	 
	self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    // enable/disable walkthrough
    self.walkthroughButton.hidden = self.hasReadWalkthrough;
}


#pragma mark - CollectionView datesource and delegate

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
	static NSString *CatIdent = @"Category";
	
	NSString * CellIdentifier = CatIdent;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if ([CellIdentifier isEqualToString:CatIdent]) {
		UIButton * cat = (UIButton*)[cell viewWithTag:1];
		
		NSString * colorName = [colorIndex objectAtIndex:indexPath.row%colorIndex.count];
		NSString * imagePath =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"category_button_%@",colorName] ofType:@"png"];
		NSString * iconPath =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"category_icon_%@",[categories objectAtIndex:indexPath.row]] ofType:@"png"];
        
//        cat.titleLabel.textAlignment = NSTextAlignmentCenter;
//        cat.titleLabel.backgroundColor = [UIColor grayColor];
		[cat setTitle:@"" forState:UIControlStateNormal];
        
        UILabel *customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 170, cat.frame.size.height)];
        customTitleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:30];
        customTitleLabel.layer.shadowOffset = CGSizeMake(1, 1);
        customTitleLabel.layer.shadowOpacity = 0.5f;
        customTitleLabel.layer.shadowRadius = 3.5;
        customTitleLabel.textColor = [UIColor whiteColor];
        customTitleLabel.backgroundColor = [UIColor clearColor];
        customTitleLabel.textAlignment = NSTextAlignmentCenter;
        customTitleLabel.text = [[categories objectAtIndex:indexPath.row] capitalizedString];
        [cat addSubview:customTitleLabel];
        
		[cat setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
		[cat setImage:[UIImage imageWithContentsOfFile:iconPath] forState:UIControlStateNormal];
    
        cat.imageEdgeInsets = UIEdgeInsetsMake(0, 60 - cat.imageView.frame.size.width/2, 0, 0);
		
	}
	if (indexPath.row%shellPerPage==0) {
		self.pageControl.currentPage = indexPath.row/shellPerPage;
	}

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [EVSoundPlayer playClickSound];
	NSLog(@"Category selected %@",indexPath);
	choosenCategoryName=[categories objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"play" sender:self];
	
}


-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
	//this happend when user touch one of the cell but not yet released
	
}

#pragma mark - page control

-(void)pageChanged:(UIPageControl*)sender{
	int row = sender.currentPage * shellPerPage;
	[self.iconCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:true];
}

#pragma mark - segue

-(IBAction)returnToCategoryPicker:(UIStoryboardSegue *)segue {
	NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
    
    if ([segue.sourceViewController isKindOfClass:[ChoosePracticeModeVC class]])
    {
        self.wasAtPractice = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	//geting view from container bind to property without create a new view controller
	if ([segue.identifier isEqualToString:@"play"]) {
		NSLog(@"category=%@",choosenCategoryName);
		UITabBarController * destVC = segue.destinationViewController;
		[destVC setSelectedIndex:self.wasAtPractice];   // selected index based on previous index
		UINavigationController * firstVC = [destVC.viewControllers objectAtIndex:0];
		UINavigationController * secondVC = [destVC.viewControllers objectAtIndex:1];
		((FlashCardCollectionVC*)firstVC.topViewController).currentCategory = choosenCategoryName;
		((ChoosePracticeModeVC*)secondVC.topViewController).currentCategory = choosenCategoryName;
	}

}

#pragma mark - Target/action

- (IBAction)walkthroughSelected:(UIButton *)sender {
    self.hasReadWalkthrough = YES;
    self.walkthroughButton.hidden = YES;
}

@end
