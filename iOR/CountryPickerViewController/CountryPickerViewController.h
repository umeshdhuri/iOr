//
//  CountryPickerViewController.h
//  iOR
//
//  Created by Krunal Doshi on 10/28/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DismissedViewControllerDelegate;
@class SponsorViewController;

@interface CountryPickerViewController : UIViewController
@property (assign, nonatomic) id <DismissedViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btnCloseClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseClicked;
@property (weak, nonatomic) IBOutlet UITableView *tblCountry;
@property (weak, nonatomic) SponsorViewController *sponsorViewController;
@end

@protocol DismissedViewControllerDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController dictCountry:(NSDictionary*)dictCountry;
@end
