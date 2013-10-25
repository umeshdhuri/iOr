//
//  mapViewController.h
//  googleMapKitExm
//
//  Created by Umesh Dhuri on 07/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mapViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet UITextField *address;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address;
@end
