//
//  CustomTabBarController.h
//  CustomTabBar
//
//  Created by Umesh Dhuri on 01/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController <UITabBarControllerDelegate>
{
    UIButton *btn1; // home: tag 0
	UIButton *btn2; // my profile: tag 1
	UIButton *btn3; // multimedia: tag 2
	UIButton *btn4; // pressBox: tag 3
	UIButton *btn5; //questions: tag 4
}

@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, retain) UIButton *btn4;
@property (nonatomic, retain) UIButton *btn5;
@property (nonatomic, readwrite) int tagNum;
-(void)addCustomElements;
@end
