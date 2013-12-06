//
//  MyRequestViewController.m
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "MyRequestViewController.h"
#import "ProviderListViewController.h"

@interface MyRequestViewController ()
@property (strong, nonatomic) NSMutableArray *aryRequests;

@end

@implementation MyRequestViewController

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
    
    //self.title = LocalizedString(@"mlt_title_requests", nil);
    [appDelegate navigationTitle:LocalizedString(@"mlt_title_requests", nil) viewController:self];
    self.navigationController.navigationBarHidden = NO;
    self.lblNoRequest.hidden = YES;
    self.lblNoRequest.text = LocalizedString(@"no_requests", nil);
    self.aryRequests = [[NSMutableArray alloc] init];
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        [client getPath:[NSString stringWithFormat:kMyRequestURL,token,language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                if([[dictResponse valueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    self.aryRequests = [[NSMutableArray alloc] initWithArray:[dictResponse valueForKey:@"data"]];
                    if([self.aryRequests count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tblView reloadData];
                    });
                    }
                    else {
                        self.tblView.hidden = YES;
                        self.lblNoRequest.hidden = NO;
                    }
                    
                }
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error - %@",error.description);
        }];
        
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }
    
    [appDelegate setNavigationBackButton:self];

    
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {
        if(IS_IOS7_AND_UP) {
            CGRect frame = self.blueStripView.frame;
            frame.origin.y = 0;
            self.blueStripView.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 18;
            frame.size.height = 530;
            self.tblView.frame = frame;
        }
        else {
            CGRect frame = self.blueStripView.frame;
            frame.origin.y = 2;
            self.blueStripView.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 18;
            frame.size.height = 480;
            self.tblView.frame = frame;
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    self.title = LocalizedString(@"mlt_title_requests", nil);
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    self.title = @"";
//}


#pragma mark -
#pragma mark TableView DataSource Mehotds

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aryRequests count];
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_normal.png"]]];
    
    UILabel *lblProvider = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 225, 24)];
    [lblProvider setBackgroundColor:[UIColor clearColor]];
    
    lblProvider.text = [[self.aryRequests objectAtIndex:indexPath.row] valueForKey:@"description"];
    lblProvider.textColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];
    lblProvider.font = [UIFont fontWithName:RegularFont size:fontSize];
    [view addSubview:lblProvider];
    
    UILabel *lblHelperCount = [[UILabel alloc] initWithFrame:CGRectMake(247, 10, 20, 24)];
    [lblHelperCount setBackgroundColor:[UIColor clearColor]];
    
    lblHelperCount.text = [NSString stringWithFormat:@"%@",[[self.aryRequests objectAtIndex:indexPath.row] valueForKey:@"heplers_count"]];
    lblHelperCount.textColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];
    lblHelperCount.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    [view addSubview:lblHelperCount];
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setImage:[UIImage imageNamed:@"Button-Close-icon.png"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(btnDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.tag = indexPath.row;
    [btnDelete setFrame:CGRectMake(265, 10, 24, 24)];
    [view addSubview:btnDelete];
    
    [cell.contentView addSubview:view];

    
    return cell;
    
    
}


#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.aryRequests objectAtIndex:indexPath.row];
    
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        [client getPath:[NSString stringWithFormat:kGetRequestHelpers,token,[dict valueForKey:@"id"],language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                if([[dictResponse valueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *aryHelpers = [[NSMutableArray alloc] initWithArray:[dictResponse valueForKey:@"data"]];
                    DLog(@"aryHelpers------ %@", aryHelpers);
                    ProviderListViewController *viewController = [[ProviderListViewController alloc] init];
                    viewController.aryHelpers = aryHelpers;
                    viewController.dictCategory = dict;
                    viewController.navigationType = @"MyRequest";
                    viewController.blnIsMyRequest = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
            }
            else {
                [appDelegate showAlertView:LocalizedString(@"no_result_text", nil) message:@""];
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
#pragma mark Custom methods

- (void)btnDeleteClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSDictionary *dict = [self.aryRequests objectAtIndex:btn.tag];
    
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        [client getPath:[NSString stringWithFormat:kRemoveRequest,token,[dict valueForKey:@"id"],language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                [self.aryRequests removeObjectAtIndex:btn.tag];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tblView reloadData];
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
