//
//  WhoareweViewController.h
//  iOR
//
//  Created by Krunal on 11/7/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSRadioButtonSetController.h"

@interface WhoareweViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnChangeLanguage;
@property (weak, nonatomic) IBOutlet UIButton *btnConceptClicked;
@property (weak, nonatomic) IBOutlet UIView *blueStripView;
@property (weak, nonatomic) IBOutlet UIButton *btnDescription;
@property (weak, nonatomic) IBOutlet UILabel *slidLabel;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;
@property (strong, nonatomic) IBOutlet UIView *conceptView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *changeLanguageView;
@property (weak, nonatomic) IBOutlet UILabel *lblHebrew;
@property (weak, nonatomic) IBOutlet UITextView *tvConcept;
@property (weak, nonatomic) IBOutlet UILabel *lblEnglish;
- (IBAction)btnEnglishClicekd:(id)sender;
- (IBAction)btnHebrewClicked:(id)sender;
@property (nonatomic, strong) IBOutlet GSRadioButtonSetController * radioButtonSetController;
- (IBAction)btnConceptClicked:(id)sender;
- (IBAction)btnDescriptionClicked:(id)sender;
- (IBAction)btnLanguageClicked:(id)sender;
- (IBAction)btnChangeLanguageClicked:(id)sender;

@end
