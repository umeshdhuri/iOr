//
//  ProviderListViewController.h
//  iOR
//
//  Created by Krunal on 11/12/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblPeople;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIView *blueStripView;

@property (nonatomic,strong) NSMutableArray *aryHelpers;
@property (nonatomic,strong) NSDictionary *dictCategory;
@property (nonatomic, strong) NSString *navigationType;
@property (nonatomic) BOOL blnIsMyRequest;

@end
