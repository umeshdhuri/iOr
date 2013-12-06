//
//  IWantToHelpViewController.m
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "IWantToHelpViewController.h"
#import "SSCheckBoxView.h"
#import "SponsorViewController.h"

@interface IWantToHelpViewController ()<DismissedSponsorDelegate>
@property (strong, nonatomic) NSMutableArray *aryCheckBox;
@property (strong, nonatomic) NSMutableArray *arySelectedCategories;
@property (strong, nonatomic) NSMutableArray *aryCheckBoxes;
@end

@implementation IWantToHelpViewController

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
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //self.title = LocalizedString(@"mlt_title_profile", nil);
    [appDelegate navigationTitle:LocalizedString(@"mlt_title_profile", nil) viewController:self];
    self.navigationController.navigationBarHidden = NO;
    
    self.lblSelectCategory.text = LocalizedString(@"ml_txt_select_categories_of_help", nil);
    self.lblSelectCategory.font = [UIFont fontWithName:RegularFont size:headerFontSize];
    
    self.arySelectedCategories = [[NSMutableArray alloc] init];
    
    self.aryCheckBoxes = [[NSMutableArray alloc] initWithCapacity:[aryCategories count]];
    
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        self.aryCheckBox = [[NSMutableArray alloc] initWithCapacity:[aryCategories count]];
        for(int i =0;i<[aryCategories count];i++) {
            [self.aryCheckBox addObject:@"NO"];
            [self.aryCheckBoxes addObject:@""];
        }
        [client getPath:[NSString stringWithFormat:kGetProfileURL,token,language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
            
                DLog(@"%@", [dictResponse valueForKey:@"data"]);
                if([[dictResponse valueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *categories = [dictResponse valueForKey:@"data"];
                    
                    for(int j=0;j<[aryCategories count];j++) {
                        NSString *categoryID = [[aryCategories objectAtIndex:j] valueForKey:@"id"];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id == %@",categoryID];
                        NSArray *filteredArray = [categories filteredArrayUsingPredicate:predicate];
                        if([filteredArray count]){
                            [self.aryCheckBox replaceObjectAtIndex:j withObject:@"YES"];
                            [self.arySelectedCategories addObject:categoryID];
                        }
                        else {
                            [self.aryCheckBox replaceObjectAtIndex:j withObject:@"NO"];
                        }
                    }
                }
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


    [appDelegate setNavigationBackButton:self];
    
    
    [self.btnSend setTitle:LocalizedString(@"bt_send", nil) forState:UIControlStateNormal];
    self.btnSend.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    [self.btnSetSponsor setTitle:LocalizedString(@"set_sponsor", nil) forState:UIControlStateNormal];
    self.btnSetSponsor.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {
        if(IS_IOS7_AND_UP) {
            CGRect frame = self.lblSelectCategory.frame;
            frame.origin.y = 12;
            self.lblSelectCategory.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 58;
            frame.size.height += 65;
            self.tblView.frame = frame;
            
            frame = self.blueStripView.frame;
            frame.origin.y = 0;
            self.blueStripView.frame = frame;

        }
        else {
            CGRect frame = self.lblSelectCategory.frame;
            frame.origin.y = 12;
            self.lblSelectCategory.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 58;
            frame.size.height += 56;
            self.tblView.frame = frame;
            
            frame = self.blueStripView.frame;
            frame.origin.y = 2;
            self.blueStripView.frame = frame;

        }
       
    }
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"] isEqualToString:@"he"]) {
        CGRect newFrame = self.btnSend.frame;
        self.btnSend.frame = self.btnSetSponsor.frame;
        self.btnSetSponsor.frame = newFrame;
    }
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_normal.png"]]];
    
    UILabel *lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 243, 24)];
    [lblCategory setBackgroundColor:[UIColor clearColor]];
    lblCategory.font = [UIFont fontWithName:RegularFont size:mediumeFontSize];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"] isEqualToString:@"he"]) {
        lblCategory.textAlignment = NSTextAlignmentRight;
    }
    else {
        lblCategory.textAlignment = NSTextAlignmentLeft;
    }
    
    lblCategory.text = [[aryCategories objectAtIndex:indexPath.row] valueForKey:@"name"];
    lblCategory.textColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];

    [view addSubview:lblCategory];
    
    BOOL state;
    
    if([[self.aryCheckBox objectAtIndex:indexPath.row] isEqualToString:@"YES"]) {
        state = YES;
    }
    else {
        state = NO;
    }
    
    SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(260, 5, 30, 30)
                                          style:kSSCheckBoxViewStyleDark
                                        checked:state];
    cbv.tag = indexPath.row;
    [cbv setStateChangedTarget:self
                      selector:@selector(checkBoxViewChangedState:)];
    [self.aryCheckBoxes replaceObjectAtIndex:indexPath.row withObject:cbv];
    [view addSubview:cbv];
    
    [cell.contentView addSubview:view];
    
    return cell;
    
    
}


#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SSCheckBoxView *cbv = [self.aryCheckBoxes objectAtIndex:indexPath.row];
    [cbv changeState];
    [self.tblView reloadData];
    
}

#pragma mark -
#pragma mark Checkbox state change methods

- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    NSLog(@"checkBoxViewChangedState: %d", cbv.checked);
    int tag = cbv.tag;
    
    if(cbv.checked)
    {
        [self.aryCheckBox replaceObjectAtIndex:tag withObject:@"YES"];
        [self.arySelectedCategories addObject:[[aryCategories objectAtIndex:tag]valueForKey:@"id"]];
    }
    else {
        [self.aryCheckBox replaceObjectAtIndex:tag withObject:@"NO"];
        [self.arySelectedCategories removeObject:[[aryCategories objectAtIndex:tag]valueForKey:@"id"]];
    }
}


- (IBAction)btnSendClicked:(id)sender {
    
    if([Utility hasConnectivity]) {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:self.arySelectedCategories forKey:@"category_ids"];
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        [client postPath:[NSString stringWithFormat:kUpdateProfileURL,token,language] parameters:dict1 loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) multiPartForm:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                [appDelegate showAlertView:LocalizedString(@"request_accepted", nil)];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSMutableDictionary *dictResponse = [operation.responseString mutableObjectFromJSONString];
            
            DLog(@"error - %@",error.description);
            
            
        }];
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }

}

- (IBAction)btnSetSponsorClicked:(id)sender {
    SponsorViewController *viewController = [[SponsorViewController alloc] init];
    viewController.delegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationFade];
}

#pragma mark -
#pragma mark DismissSponsorMethods

- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

@end
