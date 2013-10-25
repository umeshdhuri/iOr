//
//  GoogleViewController.m
//  googleMap
//
//  Created by Umesh Dhuri on 06/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "GoogleViewController.h"

@interface GoogleViewController ()

@end

@implementation GoogleViewController

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
    [self loadView];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
                                                            longitude:151.2086
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(-33.8683, 151.2086);
    options.title = @"Sydney";
    options.snippet = @"Australia";
    [mapView_ addMarkerWithOptions:options];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
