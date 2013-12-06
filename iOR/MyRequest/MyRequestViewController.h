//
//  MyRequestViewController.h
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRequestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequest;
@property (weak, nonatomic) IBOutlet UIView *blueStripView;

@end
