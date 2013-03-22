//
//  CategoryPickerVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/20/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "CategoryPickerVC.h"
#import "FlashCardCollectionVC.h"
#import "ChoosePracticeModeVC.h"

@interface CategoryPickerVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation CategoryPickerVC{
	NSString * choosenCategoryName;
	int shellPerPage;
	NSArray * categories;
	NSArray * colorIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//	
//	iconPath = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"iconbeast"];
//	//	NSLog(@"iconPath=%@",iconPath);
	shellPerPage=4;
	categories=[NSArray arrayWithObjects:@"food",@"number",@"animal",@"domestic",nil];
	colorIndex=[NSArray arrayWithObjects:@"blue",@"orange",@"purple",@"yellow",nil];
	
	self.pageControl.numberOfPages = categories.count/shellPerPage;
	if (categories.count%shellPerPage!=0)self.pageControl.numberOfPages ++;
	 
	self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
		[cat setTitle:[[categories objectAtIndex:indexPath.row] capitalizedString] forState:UIControlStateNormal];
		[cat setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
		[cat setImage:[UIImage imageWithContentsOfFile:iconPath] forState:UIControlStateNormal];
		
	}
	if (indexPath.row%shellPerPage==0) {
		self.pageControl.currentPage = indexPath.row/shellPerPage;
	}

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	//geting view from container bind to property without create a new view controller
	if ([segue.identifier isEqualToString:@"play"]) {
		NSLog(@"category=%@",choosenCategoryName);
		UITabBarController * destVC = segue.destinationViewController;
		[destVC setSelectedIndex:0];
		UINavigationController * firstVC = [destVC.viewControllers objectAtIndex:0];
		UINavigationController * secondVC = [destVC.viewControllers objectAtIndex:1];
		((FlashCardCollectionVC*)firstVC.topViewController).currentCategory = choosenCategoryName;
		((ChoosePracticeModeVC*)secondVC.topViewController).currentCategory = choosenCategoryName;
	}

}
@end
