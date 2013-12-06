//
//  WhoareweViewController.m
//  iOR
//
//  Created by Krunal on 11/7/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "WhoareweViewController.h"
#import "RTLabel.h"

@interface WhoareweViewController ()<UIScrollViewDelegate,RTLabelDelegate> {
    UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;
    RTLabel *label;
    UIScrollView *scrollView;
}

@end

@implementation WhoareweViewController

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
    // Do any additional setup after loading the view from its nib.
    
//    if(IS_IOS7_AND_UP)
//        self.edgesForExtendedLayout = UIRectCornerTopLeft;
    
//    self.dataSource = self;
//    self.delegate = self;
    self.navigationController.navigationBarHidden = NO;
//    self.title = LocalizedString(@"mlt_title_about", nil);
    [appDelegate navigationTitle: LocalizedString(@"mlt_title_about", nil) viewController:self];
    
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {
        
        if(IS_IOS7_AND_UP) {
            
            CGRect frame = self.blueStripView.frame;
            frame.origin.y = 0;
            self.blueStripView.frame = frame;
            
            frame = self.btnDescription.frame;
            frame.origin.y = 7;
            self.btnDescription.frame = frame;
            
            frame = self.btnConceptClicked.frame;
            frame.origin.y = 7;
            self.btnConceptClicked.frame = frame;
            
            frame = self.btnChangeLanguage.frame;
            frame.origin.y = 7;
            self.btnChangeLanguage.frame = frame;
            
            self.slidLabel.frame = CGRectMake(0, 32, 100, 4);

        
        }
        else {
            CGRect frame = self.blueStripView.frame;
            frame.origin.y = 2;
            self.blueStripView.frame = frame;
            
            frame = self.btnDescription.frame;
            frame.origin.y = 7;
            self.btnDescription.frame = frame;
            
            frame = self.btnConceptClicked.frame;
            frame.origin.y = 7;
            self.btnConceptClicked.frame = frame;
            
            frame = self.btnChangeLanguage.frame;
            frame.origin.y = 7;
            self.btnChangeLanguage.frame = frame;
            
            self.slidLabel.frame = CGRectMake(0, 32, 100, 4);

        }
        
        
    }
    
    [appDelegate setNavigationBackButton:self];
    
    [self initScrollView];
    
    [self.btnDescription setTitle:LocalizedString(@"mlt_description", nil) forState:UIControlStateNormal];
    [self.btnConceptClicked setTitle:LocalizedString(@"mlt_concept", nil) forState:UIControlStateNormal];
    [self.btnChangeLanguage setTitle:LocalizedString(@"mlt_change_language", nil) forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localize)
                                                 name:kLocalizationChangedNotification
                                               object:nil];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"] isEqualToString:@"he"]) {
        self.radioButtonSetController.selectedIndex = 1;
    }
    else {
        self.radioButtonSetController.selectedIndex = 0;
    }
    
    [self.btnLanguage setTitle:LocalizedString(@"mlt_change_language", nil) forState:UIControlStateNormal];
    self.btnLanguage.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    self.tvConcept.text = LocalizedString(@"concept", nil);
    self.tvDescription.text = LocalizedString(@"description", nil);
    
    self.lblEnglish.font = [UIFont fontWithName:RegularFont size:mediumeFontSize];
    self.lblHebrew.font = [UIFont fontWithName:RegularFont size:mediumeFontSize];
    
    
    CGRect newFrame = self.descriptionView.frame;
    newFrame.origin.y = 5;
    newFrame.size.width = 310;
    newFrame.origin.x = 5;
    newFrame.size.height += 20;
    
    scrollView = [[UIScrollView alloc] initWithFrame:newFrame];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [self.descriptionView addSubview:scrollView];
    
    label = [[RTLabel alloc] initWithFrame:newFrame];
    [label setText:LocalizedString(@"description", nil)];
    [label setTextColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1]];
    label.delegate = self;
    [scrollView addSubview:label];
    
    NSString *cellText = label.text;
    UIFont *cellFont = [UIFont systemFontOfSize:16];;
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = label.frame;
    frame.size = labelSize;
    frame.size.height += 50;
    label.frame = frame;
    
    scrollView.contentSize = label.frame.size;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Language Delegate

- (void)changeLanguage {
    //self.title = LocalizedString(@"mlt_title_about", nil);
      [appDelegate navigationTitle: LocalizedString(@"mlt_title_about", nil) viewController:self];
    //[self reloadData];
    [self.btnDescription setTitle:LocalizedString(@"mlt_description", nil) forState:UIControlStateNormal];
    [self.btnConceptClicked setTitle:LocalizedString(@"mlt_concept", nil) forState:UIControlStateNormal];
    [self.btnChangeLanguage setTitle:LocalizedString(@"mlt_change_language", nil) forState:UIControlStateNormal];
    pageControl.currentPage = 0;
    currentPage = 0;
    pageControlUsed = NO;
    [self btnActionShow];
    [appDelegate setNavigationBackButton:self];
     [label setText:LocalizedString(@"description", nil)];
    //self.tvDescription.text = LocalizedString(@"description", nil);
}

#pragma mark -
#pragma mark Localization methods

- (void)localize {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getCategories];
        [self changeLanguage];
    });
    
}

#pragma mark -
#pragma mark Custom Methods

- (IBAction)btnEnglishClicekd:(id)sender {
    
    self.radioButtonSetController.selectedIndex = 0;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)btnHebrewClicked:(id)sender {
    self.radioButtonSetController.selectedIndex = 1;
    [[NSUserDefaults standardUserDefaults] setObject:@"he" forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (IBAction)btnConceptClicked:(id)sender {
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {

        self.slidLabel.frame = CGRectMake(100, 32, 90, 4);
       
    }
    else {
        self.slidLabel.frame = CGRectMake(100, 96, 90, 4);
    }
    [self.scrollView setContentOffset:CGPointMake(320*1, 0)];//页面滑动
    
    [UIView commitAnimations];
}

- (IBAction)btnDescriptionClicked:(id)sender {
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {

        self.slidLabel.frame = CGRectMake(0, 32, 160, 4);

    }
    else {
        self.slidLabel.frame = CGRectMake(0, 96, 160, 4);
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0)];//页面滑动
    
    [UIView commitAnimations];
}

- (IBAction)btnLanguageClicked:(id)sender {
    if([Utility hasConnectivity]) {
        
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        [client getPath:[NSString stringWithFormat:kLanguageURL,token,language] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* newStr = [[NSString alloc] initWithData:responseObject
                                                     encoding:NSUTF8StringEncoding] ;
            NSMutableDictionary *dictResponse = [newStr mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([language isEqualToString:@"he"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"he" forKey:@"appLanguage"];
                        LocalizationSetLanguage(@"he");
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"appLanguage"];
                        LocalizationSetLanguage(@"en");
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                });
                
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLog(@"error - %@",error.description);
        }];
        
        
        
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }

}

- (IBAction)btnChangeLanguageClicked:(id)sender {
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {

        self.slidLabel.frame = CGRectMake(162, 32, 160, 4);
    }
    else {
        self.slidLabel.frame = CGRectMake(162, 96, 160, 4);
    }
    [self.scrollView setContentOffset:CGPointMake(320*1, 0)];//页面滑动
    
    [UIView commitAnimations];
}

- (void) btnActionShow
{
    if (currentPage == 0) {
        [self btnDescriptionClicked:nil];
    }
    else if(currentPage == 1){
        //[self btnConceptClicked:nil];
        [self btnChangeLanguageClicked:nil];
    }
    else {
        [self btnChangeLanguageClicked:nil];
    }
}

#pragma mark -
#pragma mark Custom Methods

- (void)initScrollView {
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    

    currentPage = 0;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor whiteColor];
    [self createAllEmptyPagesForScrollView];
}

- (void)createAllEmptyPagesForScrollView {
    

    if(!IS_IOS7_AND_UP) {
        self.descriptionView.frame = CGRectMake(320*0, 87, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 120);
    }
    else {
        if(phoneHeight == 568) {
         self.descriptionView.frame = CGRectMake(320*0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
        else {
           self.descriptionView.frame = CGRectMake(320*0, 87, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 120);
        }
    }
    [self.scrollView addSubview:self.descriptionView];
    
//    if(!IS_IOS7_AND_UP) {
//        self.conceptView.frame = CGRectMake(320*1, 87, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//    }
//    else {
//        if(phoneHeight == 568) {
//            self.conceptView.frame = CGRectMake(320*1, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//        }
//        else {
//            self.conceptView.frame = CGRectMake(320*1, 87, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//            
//        }
//    }
//    [self.scrollView addSubview:self.conceptView];
    if(!IS_IOS7_AND_UP) {
        self.changeLanguageView.frame = CGRectMake(320*1, 87, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    else {
        if(phoneHeight == 568) {
            self.changeLanguageView.frame = CGRectMake(320*1, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
        else {
            self.changeLanguageView.frame = CGRectMake(320*1, 87, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
        
    }
    [self.scrollView addSubview:self.changeLanguageView];

    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPage = page;
    currentPage = page;
    pageControlUsed = NO;
    [self btnActionShow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}



#pragma mark - GSRadioButtonSetController delegate methods

- (void)radioButtonSetController:(GSRadioButtonSetController *)controller didSelectButtonAtIndex:(NSUInteger)selectedIndex
{
    if(selectedIndex == 1 || selectedIndex == 3) {
        [[NSUserDefaults standardUserDefaults] setObject:@"he" forKey:@"appLanguage"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"appLanguage"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    return YES;
//}
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    return NO;
//}

#pragma mark -
#pragma mark Get Categories

- (void)getCategories {
    
    if([Utility hasConnectivity]) {
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        [client getPath:[NSString stringWithFormat:kCategoriesURL,token,language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                if(aryCategories) {
                    [aryCategories removeAllObjects];
                    aryCategories = nil;
                }
                aryCategories = [[NSMutableArray alloc] initWithArray:[dictResponse valueForKey:@"data"]];
                DLog(@"Categories------ %@", aryCategories);
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error - %@",error.description);
        }];
        
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }
    
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	NSLog(@"did select url %@", url);
    [[UIApplication sharedApplication] openURL:url];
}


@end
