//
//  FBCDAppDelegate.h
//  FailedBankCD
//
//  Created by Umesh Dhuri on 14/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
