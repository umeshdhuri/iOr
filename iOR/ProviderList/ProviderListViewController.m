//
//  ProviderListViewController.m
//  iOR
//
//  Created by Krunal on 11/12/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "ProviderListViewController.h"

@interface ProviderListViewController ()
@property (nonatomic,strong) NSDictionary *selectedProvider;
@end

@implementation ProviderListViewController

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
    self.lblPeople.text = LocalizedString(@"need_help_people_screen", nil);
    self.lblPeople.font = [UIFont fontWithName:RegularFont size:headerFontSize];
    //self.title = LocalizedString(@"mlt_title_need_help", nil);
    
    if([self.navigationType isEqualToString:@"INeedHelp"]) {
        [appDelegate navigationTitle:LocalizedString(@"mlt_title_need_help", nil) viewController:self];
    }else{
        [appDelegate navigationTitle:LocalizedString(@"mlt_title_requests", nil) viewController:self];
    }
    
    
    [appDelegate setNavigationBackButton:self];

    
    if(!IS_IOS7_AND_UP || phoneHeight != 568) {
        if(IS_IOS7_AND_UP) {
            CGRect frame = self.lblPeople.frame;
            frame.origin.y = 12;
            self.lblPeople.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 37;
            frame.size.height += 45;
            self.tblView.frame = frame;
            
            frame = self.blueStripView.frame;
            frame.origin.y = 0;
            self.blueStripView.frame = frame;
        }
        else {
            CGRect frame = self.lblPeople.frame;
            frame.origin.y = 12;
            self.lblPeople.frame = frame;
            
            frame = self.tblView.frame;
            frame.origin.y = 37;
            frame.size.height += 45;
            self.tblView.frame = frame;
            
            frame = self.blueStripView.frame;
            frame.origin.y = 2;
            self.blueStripView.frame = frame;
        }
        
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
    return [self.aryHelpers count];
    
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
    
    UILabel *lblProvider = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 185, 24)];
    [lblProvider setBackgroundColor:[UIColor clearColor]];
    [lblProvider setFont:[UIFont fontWithName:RegularFont size:fontSize]];
    lblProvider.text = [[self.aryHelpers objectAtIndex:indexPath.row] valueForKey:@"name"];
    lblProvider.textColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];
    
    [view addSubview:lblProvider];
    
    UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 90, 24)];
    [lblDistance setBackgroundColor:[UIColor clearColor]];
    
    lblDistance.text = [NSString stringWithFormat:@"%.2f%@",[[[self.aryHelpers objectAtIndex:indexPath.row] valueForKey:@"distance"] floatValue],LocalizedString(@"mt_km", nil)];
    lblDistance.textColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];
    lblDistance.textAlignment = NSTextAlignmentRight;
    [view addSubview:lblDistance];
    
    [cell.contentView addSubview:view];
    
    
    return cell;
    
    
}


#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedProvider = [self.aryHelpers objectAtIndex:indexPath.row];
    if(self.blnIsMyRequest) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[self.selectedProvider valueForKey:@"name"]] message:[NSString stringWithFormat:LocalizedString(@"people_find_text", nil),[self.dictCategory valueForKey:@"description"]] delegate:self cancelButtonTitle:LocalizedString(@"mlt_call_him", nil) otherButtonTitles:LocalizedString(@"cancel", nil), nil];
        alertView.tag = 1002;
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[self.selectedProvider valueForKey:@"name"]] message:[NSString stringWithFormat:LocalizedString(@"people_find_text", nil),[self.dictCategory valueForKey:@"name"]] delegate:self cancelButtonTitle:LocalizedString(@"mlt_call_him", nil) otherButtonTitles:LocalizedString(@"cancel", nil), nil];
        alertView.tag = 1002;
        [alertView show];

    }

    
}

#pragma mark -
#pragma mark UIAlertView Delegate MEthods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 if(alertView.tag == 1002) {
        if(buttonIndex == 0) {
            NSString *strPhone = [NSString stringWithFormat:@"tel:%@",[self.selectedProvider valueForKey:@"phone"]];
            NSURL *url = [[NSURL alloc] initWithString:strPhone];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
