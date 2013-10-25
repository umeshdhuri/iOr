//
//  mapViewController.m
//  googleMapKitExm
//
//  Created by Umesh Dhuri on 07/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "mapViewController.h"
#import "MyAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface mapViewController ()
@end

@implementation mapViewController
@synthesize mapView;

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
    
    CLLocation *userLocation = mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate;
    
    userCoordinate.latitude = userLocation.coordinate.latitude;
    userCoordinate.longitude = userLocation.coordinate.longitude;
    
    NSLog(@"User latitude ==== %f", userCoordinate.latitude);
    NSLog(@"User Logitude ==== %f", userCoordinate.longitude);
    
    mapView.delegate = self;
    
    MyAnnotation* myAnnotation=[[MyAnnotation alloc] init];
    myAnnotation.coordinate = userCoordinate;
    myAnnotation.title = @"My Current Location";
    myAnnotation.subtitle = @"";
    
    [mapView addAnnotation:myAnnotation];
  
}

-(IBAction) userAddress
{
    [self geoCodeUsingAddress:address.text];
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\":" intoString:nil] && [scanner scanString:@"\"lat\":" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\":" intoString:nil] && [scanner scanString:@"\"lng\":" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
