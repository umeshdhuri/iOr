//
//  RequestViewController.h
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DismissedControllerDelegate;

@interface RequestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblDescribeText;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (assign, nonatomic) id <DismissedControllerDelegate>delegate;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnSendClicked:(id)sender;

@end

@protocol DismissedControllerDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController description:(NSString*)description isCancel:(BOOL)isCancel;
@end
