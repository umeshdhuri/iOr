//
//  addData.h
//  FailedBankCD
//
//  Created by Umesh Dhuri on 17/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface addData : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *fnameTxt, *lnameTxt, *usernameTxt, *passwordTxt;
}


-(IBAction) saveData;

@end
