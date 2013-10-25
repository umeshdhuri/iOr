//
//  FBCDViewController.h
//  FailedBankCD
//
//  Created by Umesh Dhuri on 17/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addData.h"

@interface FBCDViewController : UIViewController {
    NSMutableArray *dataList;
    NSMutableDictionary *dataDict;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

-(IBAction) insertData;

@end
