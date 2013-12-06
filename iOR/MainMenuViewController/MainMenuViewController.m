//
//  MainMenuViewController.m
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "MainMenuViewController.h"
#import "INeedHelpViewController.h"
#import "MyRequestViewController.h"
#import "IWantToHelpViewController.h"
#import "WhoareweViewController.h"
#import "AFHTTPClient.h"

@interface MainMenuViewController () {
    int index;
}

@end

@implementation MainMenuViewController

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
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"] isEqualToString:@"he"]) {
       LocalizationSetLanguage(@"he");
    }
    else {
        LocalizationSetLanguage(@"en");
    }
    
    [appDelegate setNavigationBackButton:self];
    
    
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self submitLocation];
                });

            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error - %@",error.description);
        }];
        
        
        
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }
    
    [self.imgView setImage:[UIImage imageNamed:@"logo.png"]];
    [self.view bringSubviewToFront:self.imgView];
    

    
    if(phoneHeight == 568) {
        CGRect imageRect = self.imgView.frame;
        imageRect.size = CGSizeMake(174, 194);
        imageRect.origin.y = 25;
        imageRect.origin.x = (self.view.frame.size.width/2 - imageRect.size.height/2) + 10;
        self.imgView.frame = imageRect;
        DLog(@"%@", NSStringFromCGRect(self.imgView.frame));
        CGRect rect = self.tblView.frame;
        if(IS_IOS7_AND_UP) {
            rect.origin.y = self.imgView.frame.origin.y + self.imgView.frame.size.height + 50;
        }
        else {
            rect.origin.y = self.imgView.frame.origin.y + self.imgView.frame.size.height + 90;
        }
        self.tblView.frame = rect;
    }
    else {
        
        if(IS_IOS7_AND_UP) {
            
            CGRect imageRect = self.imgView.frame;
            imageRect.size = CGSizeMake(124, 144);
            imageRect.origin.y = 25;
            imageRect.origin.x = (self.view.frame.size.width/2 - imageRect.size.height/2) + 10;
            self.imgView.frame = imageRect;
            DLog(@"%@", NSStringFromCGRect(self.imgView.frame));
            CGRect rect = self.tblView.frame;
            rect.origin.y = self.imgView.frame.origin.y + self.imgView.frame.size.height + 10;
            rect.size.height += 45;
            self.tblView.frame = rect;

            
        }
        else {
            CGRect imageRect = self.imgView.frame;
            imageRect.size = CGSizeMake(124, 144);
            imageRect.origin.y = 15;
            imageRect.origin.x = (self.view.frame.size.width/2 - imageRect.size.height/2) + 10;
            self.imgView.frame = imageRect;
            DLog(@"%@", NSStringFromCGRect(self.imgView.frame));
            CGRect rect = self.tblView.frame;
            if(IS_IOS7_AND_UP) {
                rect.origin.y = self.imgView.frame.origin.y + self.imgView.frame.size.height + 50;
            }
            else {
                rect.origin.y = self.imgView.frame.origin.y + self.imgView.frame.size.height;
                rect.size.height += 65;
            }
            self.tblView.frame = rect;
        }
    }
    

    
}

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //self.title = @" ";
    [self.tblView reloadData];
    
//    if([Utility hasConnectivity]) {
//        
//        
//        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
//                                              showingHUDInView:self.view];
//        
//        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
//        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
//        
//        
//        
//        
//    }
//    else {
//        [appDelegate showAlertView:kNoInternetConnection];
//    }
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
    return 4;
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_pressed.9.png"]];
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;
    if(IS_IOS7_AND_UP) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_background_normal.png"]];
    }
    else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_background_normal.png"]];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UILabel *lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(135, 25, 225, 24)];
    [lblCategory setBackgroundColor:[UIColor clearColor]];
    lblCategory.font = [UIFont fontWithName:RegularFont size:22.0];
    lblCategory.textColor = [UIColor whiteColor];
     [cell.contentView addSubview:lblCategory];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 13, 49, 49)];
    [cell.contentView addSubview:imgView];
    
   

    
    switch (indexPath.row) {
        case 0: {
            lblCategory.text = LocalizedString(@"mlt_need_help", nil);
            imgView.image = [UIImage imageNamed:@"icon_1_normal.png"];
        }
            break;

        case 1: {
            lblCategory.text = LocalizedString(@"mlt_my_requests", nil);
            imgView.image = [UIImage imageNamed:@"icon_2_normal.png"];
        }
            break;

        case 2: {
            lblCategory.text = LocalizedString(@"mlt_want_to_help", nil);
            imgView.image = [UIImage imageNamed:@"icon_4_normal.png"];
        }
            break;

        case 3: {
            lblCategory.text = LocalizedString(@"mlt_who_we_are", nil);
            imgView.image = [UIImage imageNamed:@"icon_3_normal.png"];
        }
            break;

        default:
            break;
    }
    
    
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}



#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([Utility hasConnectivity]) {
    switch (indexPath.row) {
        case 0: {
            if([aryCategories count]) {
                index=0;
                INeedHelpViewController *viewController = [[INeedHelpViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else {
                [self getCategories];
            }
        }
            break;
            
        case 1: {
            MyRequestViewController *viewController = [[MyRequestViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case 2: {
            if([aryCategories count]) {
                index = 1;
                IWantToHelpViewController *viewController = [[IWantToHelpViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else {
                [self getCategories];
            }
        }
           
            break;
            
        case 3: {
            WhoareweViewController *viewController = [[WhoareweViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }
    
}

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
                
                if(index == 0) {
                    INeedHelpViewController *viewController = [[INeedHelpViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                else if(index == 1) {
                    IWantToHelpViewController *viewController = [[IWantToHelpViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self submitLocation];
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
#pragma submit location

- (void)submitLocation {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
    DLog(@"current location ---- %@", currentLocation);
    //NSString *currentLatitude = @"18.473078";
    NSString *currentLatitude = [[NSString alloc] initWithFormat:@"%g",currentLocation.coordinate.latitude];
    
    //NSString *currentLongitude = @"73.889172";
    NSString *currentLongitude = [[NSString alloc] initWithFormat:@"%g",currentLocation.coordinate.longitude];
    
    DLog(@"current currentLatitude ---- %@", currentLatitude);
    DLog(@"current currentLongitude ---- %@", currentLongitude);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:currentLatitude forKey:@"lat"];
    [dict setValue:currentLongitude forKey:@"lon"];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:dict forKey:@"User"];

    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [client postPath:[NSString stringWithFormat:kUpdateCordinates,token,language]  parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* newStr = [[NSString alloc] initWithData:responseObject
                                                  encoding:NSUTF8StringEncoding] ;
        NSMutableDictionary *dictResponse = [newStr mutableObjectFromJSONString];
        
        if([[dictResponse valueForKey:@"status"] boolValue]) {
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error - %@",error.description);
    }];
}

@end
