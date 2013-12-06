//
//  IWantToHelpViewController.h
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWantToHelpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton *btnSetSponsor;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCategory;
@property (weak, nonatomic) IBOutlet UIView *blueStripView;
- (IBAction)btnSendClicked:(id)sender;
- (IBAction)btnSetSponsorClicked:(id)sender;

@end
