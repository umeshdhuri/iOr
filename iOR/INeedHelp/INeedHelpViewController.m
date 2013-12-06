//
//  INeedHelpViewController.m
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "INeedHelpViewController.h"
#import "RequestViewController.h"
#import "ProviderListViewController.h"

@interface INeedHelpViewController ()<DismissedControllerDelegate> {
    int minRadius;
    int maxRadius;
    int addRequestMinRadius;
    int addRequestMaxRadius;
    MBProgressHUD *HUD;
    NSString *requestID;
}
@property (nonatomic,strong) NSDictionary *selectedCategory;
@property (nonatomic, strong) NSString *addRequestDescription;

@end

@implementation INeedHelpViewController

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
    
    minRadius = 0;
    maxRadius = 1;
    requestID = 0;
    
    //self.title = LocalizedString(@"mlt_title_need_help", nil);
    [appDelegate navigationTitle:LocalizedString(@"mlt_title_need_help", nil) viewController:self];
    self.navigationController.navigationBarHidden = NO;
    
    [self.btnCantFind setTitle:LocalizedString(@"bt_text_can_not_find", nil) forState:UIControlStateNormal];
    self.btnCantFind.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    [self.lblNeedHelp setText:LocalizedString(@"need_help_screen_text", nil)];
    self.lblNeedHelp.font = [UIFont fontWithName:RegularFont size:headerFontSize];
    
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {
        if(IS_IOS7_AND_UP) {
            CGRect frame = self.lblNeedHelp.frame;
            frame.origin.y = 12;
            self.lblNeedHelp.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 58;
            frame.size.height += 65;
            self.tblView.frame = frame;
            
            frame = self.blueStripView.frame;
            frame.origin.y = 0;
            self.blueStripView.frame = frame;
            
        }
        else {
            CGRect frame = self.lblNeedHelp.frame;
            frame.origin.y = 12;
            self.lblNeedHelp.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 58;
            frame.size.height += 56;
            self.tblView.frame = frame;
            
            frame = self.blueStripView.frame;
            frame.origin.y = 2;
            self.blueStripView.frame = frame;
        }
    }
    
    [appDelegate setNavigationBackButton:self];
    
        
}

- (void)viewWillAppear:(BOOL)animated {
    [appDelegate navigationTitle:LocalizedString(@"mlt_title_need_help", nil) viewController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    //self.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TableView DataSource Mehotds

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryCategories count];
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_pressed.9.png"]];
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;
//    if(IS_IOS7_AND_UP) {
//        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_normal.png"]];
//    }
//    else {
//        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_background_normal.png"]];
//    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_normal.png"]]];
    
    UILabel *lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 24)];
    [lblCategory setBackgroundColor:[UIColor clearColor]];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"] isEqualToString:@"he"]) {
        lblCategory.textAlignment = NSTextAlignmentRight;
    }
    else {
        lblCategory.textAlignment = NSTextAlignmentLeft;
    }

    
    lblCategory.text = [[aryCategories objectAtIndex:indexPath.row] valueForKey:@"name"];
    //lblCategory.textColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
    lblCategory.textColor = [UIColor colorWithRed:190.0/255 green:190.0/255 blue:190.0/255 alpha:100.0];
    lblCategory.font = [UIFont fontWithName:RegularFont size:fontSize];
    [view addSubview:lblCategory];
    
    [cell.contentView addSubview:view];


//    
//    cell.textLabel.textColor = [UIColor whiteColor];
//    
//    cell.textLabel.text = [[aryCategories objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    
    return cell;
    
    
}


#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    minRadius = 0;
    maxRadius = 1;
    requestID = 0;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedCategory = [aryCategories objectAtIndex:indexPath.row];
    [self getHelper:self.selectedCategory];
       
}

#pragma mark -
#pragma mark Custom methods

- (IBAction)btnCantyoufindClicked:(id)sender {
    minRadius = 0;
    maxRadius = 1;
    requestID = 0;
    RequestViewController *viewController = [[RequestViewController alloc] init];
    viewController.delegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationFade];
}

#pragma mark -
#pragma mark DismissControllerDelegate methods

- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController description:(NSString *)description isCancel:(BOOL)isCancel {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if(!isCancel) {
        self.addRequestDescription = description;
        [self addHelpRequest];
    }
}


#pragma mark -
#pragma mark Get Helper WebService Call

- (void)getHelper:(NSDictionary*)category {
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        

        [client getPath:[NSString stringWithFormat:kGetHelpersURL,token,minRadius,maxRadius,[category valueForKey:@"id"],language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];

            if([[dictResponse valueForKey:@"status"] boolValue]) {

                if([[dictResponse valueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *aryHelpers = [[NSMutableArray alloc] initWithArray:[dictResponse valueForKey:@"data"]];
                    DLog(@"aryHelpers------ %@", aryHelpers);
                    ProviderListViewController *viewController = [[ProviderListViewController alloc] init];
                    viewController.aryHelpers = aryHelpers;
                    viewController.dictCategory = category;
                    viewController.navigationType = @"INeedHelp";
                    viewController.blnIsMyRequest = NO;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPopUp:minRadius isRequest:NO];
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

- (void)showPopUp:(int)radius isRequest:(BOOL)isRequest {
    bool blnIsNextSearch = TRUE;
    if(radius == 0) {
        minRadius = 1;
        maxRadius = 5;
    }
    else if(radius == 1){
        minRadius = 5;
        maxRadius = 10;
    }
    else if(radius == 5) {
        minRadius = 10;
        maxRadius = 50;
    }
    else if(radius == 10) {
        minRadius = 50;
        maxRadius = 100;
    }
    else if(radius == 50) {
        blnIsNextSearch = FALSE;
        minRadius = 0;
        maxRadius = 1;
        //[appDelegate showAlertView:LocalizedString(@"no_results_text", nil)];
        [appDelegate showAlertView:LocalizedString(@"no_result_text", nil) message:LocalizedString(@"no_results_text", nil)];
    }
    if(blnIsNextSearch) {

        if(!isRequest) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: LocalizedString(@"no_people_text", nil),minRadius] message:[NSString stringWithFormat:LocalizedString(@"search_range_text", nil),maxRadius] delegate:self cancelButtonTitle:LocalizedString(@"mlt_yes", nil) otherButtonTitles:LocalizedString(@"mlt_no", nil), nil];
            alertView.tag = 1001;
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: LocalizedString(@"no_people_text", nil),minRadius] message:[NSString stringWithFormat:LocalizedString(@"search_to_push_range", nil),maxRadius] delegate:self cancelButtonTitle:LocalizedString(@"mlt_yes", nil) otherButtonTitles:LocalizedString(@"mlt_no", nil), nil];
            alertView.tag = 1002;
            [alertView show];
        }

    }
    
}

#pragma mark -
#pragma mark Add Help request

- (void)addHelpRequest {
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        NSString *requestDescription = [self.addRequestDescription stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        

        
        [client getPath:[NSString stringWithFormat:kAddHelpRequestURL,token,minRadius,maxRadius,requestDescription,language,requestID] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                if([[dictResponse valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    int helperCount = [[[dictResponse valueForKey:@"data"] valueForKey:@"helpers_count"] intValue];
                    if(helperCount > 0) {
                        requestID = [[dictResponse valueForKey:@"data"] valueForKey:@"request_id"];
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        
                        // Set determinate mode
                        HUD.mode = MBProgressHUDModeAnnularDeterminate;
                        
                        HUD.delegate = self;
                        HUD.detailsLabelText = LocalizedString(@"mlt_req_sent_wait_for_user", nil);
                        
                        // myProgressTask uses the HUD instance to update progress
                        [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showPopUp:minRadius isRequest:YES];
                        });
                    }
                }
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPopUp:minRadius isRequest:YES];
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

#pragma mark -
#pragma mark UIAlertView Delegate MEthods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1001) {
        if(buttonIndex == 0) {
            [self getHelper:self.selectedCategory];
        }
        else {
            requestID = 0;
            minRadius = 0;
            maxRadius = 1;
        }
    }
    else if(alertView.tag == 1002) {
        if(buttonIndex == 0) {
            [self addHelpRequest];
        }
    }
}

#pragma mark - 
#pragma mark MBProgress HUD methods

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(300000);
	}
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
    
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        [client getPath:[NSString stringWithFormat:kGetRequestHelpers,token,requestID,language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                if([[dictResponse valueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *aryHelpers = [[NSMutableArray alloc] initWithArray:[dictResponse valueForKey:@"data"]];
                    DLog(@"aryHelpers------ %@", aryHelpers);
                    ProviderListViewController *viewController = [[ProviderListViewController alloc] init];
                    viewController.aryHelpers = aryHelpers;
                    viewController.dictCategory = self.selectedCategory;
                    viewController.blnIsMyRequest = NO;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPopUp:minRadius isRequest:YES];
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
@end
