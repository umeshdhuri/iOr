//
//  ViewController.m
//  EncryptionDecryption
//
//  Created by Umesh Dhuri on 15/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Encrption and Decryption string
    NSString *string = @"Encrypted string in ios";
    NSString *key = @"encrption";
    
    NSString* encrypted = [FBEncryptorAES encryptBase64String:string keyString:key separateLines:NO];
    NSLog(@"Encrypted ==== %@", encrypted);
    
    NSString* decrypted = [FBEncryptorAES decryptBase64String:encrypted keyString:key];
    NSLog(@"Decrypted ==== %@", decrypted);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
