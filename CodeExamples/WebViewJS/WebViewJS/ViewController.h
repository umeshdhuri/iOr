//
//  ViewController.h
//  WebViewJS
//
//  Created by Umesh Dhuri on 01/08/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIWebView *webViewObj;
    IBOutlet UITextField *keyTxt, *valueTxt;
}
@end
