//
//  ViewController.h
//  TextToSpeach
//
//  Created by Umesh Dhuri on 15/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    FliteController *fliteController;
    Slt *slt;
    
    IBOutlet UITextField *textToSpeachTxt;
}

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

-(IBAction) textToSpeach;
@end
