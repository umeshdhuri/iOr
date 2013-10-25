//
//  ViewController.h
//  scrollViewEx
//
//  Created by Umesh Dhuri on 24/12/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"

@interface ViewController : UIViewController<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    IBOutlet UIView *productBackView;
    IBOutlet UIButton *productBtn;
    IBOutlet UIImageView *productImg;
    IBOutlet UILabel *productName;
    
    NSMutableArray *_currentData;
    NSMutableArray *_data;
    NSMutableArray *_data2;
    GMGridView *_gmGridView;
     NSInteger _lastDeleteItemIndexAsked;
    IBOutlet UIView *view1, *view2;
}

@end
