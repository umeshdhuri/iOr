//
//  ViewController.h
//  GoogleTranslate
//
//  Created by Umesh Dhuri on 24/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextView *textView;
    IBOutlet UITextField *textForTranslateTxt;
    IBOutlet UIButton *button;
    
    NSMutableData *responseData;
    NSMutableArray *translations;
    NSString *_lastText;
}

@property (nonatomic, copy) NSString * lastText;
- (IBAction)doTranslation;

@end
