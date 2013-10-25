//
//  SaveDataInKeyChainViewController.h
//  DataSecurity
//
//  Created by Umesh Dhuri on 23/04/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>

@interface SaveDataInKeyChainViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *dataTxt;
@property (nonatomic, retain) IBOutlet UILabel *saveDataLbl;
@end
