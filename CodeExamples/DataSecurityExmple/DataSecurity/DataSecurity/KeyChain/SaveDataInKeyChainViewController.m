//
//  SaveDataInKeyChainViewController.m
//  DataSecurity
//
//  Created by Umesh Dhuri on 23/04/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "SaveDataInKeyChainViewController.h"
static NSString *serviceName = @"com.Synechron.DataSecurity";

@interface SaveDataInKeyChainViewController ()

@end

@implementation SaveDataInKeyChainViewController
@synthesize dataTxt, saveDataLbl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(IBAction) saveData {
    
    [self createKeychainValue:@"umeshd" forIdentifier:@"Password"];
    
    NSData *passwordData = [self searchKeychainCopyMatching:@"Password"];
    if (passwordData) {
        NSString *password = [[NSString alloc] initWithData:passwordData
                                                   encoding:NSUTF8StringEncoding];
        
        NSLog(@"password === %@", password);
        saveDataLbl.text = password;
        [passwordData release];
    }
    
}

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];
    
    return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    NSData *result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary,
                                          (CFTypeRef *)&result);
    
    [searchDictionary release];
    return result;
}


- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(id)kSecValueData];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
    [dictionary release];
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}


- (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(id)kSecValueData];
    
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    
    [searchDictionary release];
    [updateDictionary release];
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (void)deleteKeychainValue:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    SecItemDelete((CFDictionaryRef)searchDictionary);
    [searchDictionary release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
