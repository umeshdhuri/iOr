//
//  INeedHelpViewController.h
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INeedHelpViewController : UIViewController<MBProgressHUDDelegate>
- (IBAction)btnCantyoufindClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCantFind;
@property (weak, nonatomic) IBOutlet UILabel *lblNeedHelp;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIView *blueStripView;

@end
