//
//  CategoryPickerVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/20/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "CategoryPickerVC.h"
#import "FlashCardCollectionVC.h"

@interface CategoryPickerVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation CategoryPickerVC{
	NSString * choosenCategoryName;
	int shellPerPage;
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
	self.pageControl.numberOfPages = 7/shellPerPage+1;
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
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
	static NSString *CatIdent = @"Category";
	
	NSString * CellIdentifier = CatIdent;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if ([CellIdentifier isEqualToString:CatIdent]) {
		UILabel * label = (UILabel*)[cell viewWithTag:1];
		label.text = [NSString stringWithFormat:@"Category %d",indexPath.row+1];
	}
	if (indexPath.row%shellPerPage==0) {
		self.pageControl.currentPage = indexPath.row/shellPerPage;
	}

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"Category selected %@",indexPath);
	choosenCategoryName=[NSString stringWithFormat:@"category%d",indexPath.row+1];
	[self performSegueWithIdentifier:@"goToLearnMode" sender:self];
	
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
	if ([segue.identifier isEqualToString:@"goToLearnMode"]) {
		NSLog(@"category=%@",choosenCategoryName);
		((FlashCardCollectionVC*)segue.destinationViewController).currentCategory = choosenCategoryName;
	}
	if ([segue.identifier isEqualToString:@"goToPracticeMode"]) {
		NSLog(@"category=%@",choosenCategoryName);
	}
	if ([segue.identifier isEqualToString:@"goToLearnMode"]) {
		NSLog(@"category=%@",choosenCategoryName);
	}
}
@end
