//
//  GMSProjection.h
//  Google Maps SDK for iOS
//
//  Copyright 2012 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Defines a mapping between Earth coordinates (CLLocationCoordinate2D) and
 * coordinates in the content space (CGPoint).  A projection is constant, in
 * that the mapping it embodies never changes.  The mapping is not necessarily
 * linear.
 *
 * This class should not be instantiated directly, instead, obtained via
 * projection on GMSMapView.
 */
@interface GMSProjection : NSObject

/** Maps an Earth coordinate to a content coordinate. */
- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)coordinate;

/** Maps a content coordinate to an Earth coordinate. */
- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)point;

/**
 * Converts a distance in meters to content size.  This is only accurate for
 * small earth distances, as we're using CGFloat for screen distances.
 */
- (CGFloat)pointsForMeters:(CGFloat)meters
              atCoordinate:(CLLocationCoordinate2D)coordinate;

@end
