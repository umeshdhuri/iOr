//
//  ViewController.m
//  scrollViewEx
//
//  Created by Umesh Dhuri on 24/12/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i ++) 
    {
        [_data addObject:[NSString stringWithFormat:@"A %d", i]];
    }
    
    _data2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i ++) 
    {
        [_data2 addObject:[NSString stringWithFormat:@"B %d", i]];
    }
    
    _currentData = _data;
    
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView=gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
   
    _gmGridView.itemSpacing = 10;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    
    
    //Add SwipeGestureRecognizer
     /*
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftView:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightView:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRight];
    
    
    
    int xVal = 20;
    int yVal = 20;
    int widthView = 230;
    int heightView = 180;
    int countVal = 1;
    for (int i=0; i <= 11; i++) 
    {
        productBackView = [[UIView alloc] initWithFrame:CGRectMake(xVal, yVal, widthView, heightView)];
        [productBackView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:productBackView];
        
        
        
        if(countVal == 4)
        {
            countVal = 0;
            
            xVal = 20;
            yVal = yVal + 200;
        }else{
            xVal = xVal + 250;
        }
            
        countVal++;
        
    }*/
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) swipeLeftView
{
    NSLog(@"Left");
   
    
    
}

-(void) swipeRightView
{
 
    NSLog(@"Right");
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}




//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
           if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    UIView *view; 
    
    /*if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor redColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }*/
    
    if (!cell) 
    {
    cell = [[GMGridViewCell alloc] init];
    cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
    cell.deleteButtonOffset = CGPointMake(-15, -15);
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor redColor];
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 8;
    
    cell.contentView = view;
    }
    
    //[[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
   /* UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];*/
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, size.width-30, size.width-50)];
    [imgView setImage:[UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.att.com/Common/about_us/images/mediakit/iphone/iphone_5_avail_banner.jpg"]]]];
    [view addSubview:imgView];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{  
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
            if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(700, 530);
        }
        else
        {
            return CGSizeMake(600, 500);
        }
    
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
            label.font = [UIFont boldSystemFontOfSize:15];
   
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}

@end
