//
//  UILocationPinningView.m
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationPinningView.h"
#import <MapKit/MapKit.h>
#import "NSBundle+RSFrameworkHooks.h"

@interface UILocationPinningView() <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray<CLLocation*> *allLocationsArray;

@end

@implementation UILocationPinningView

-(void)clearAll {
    [self.allLocationsArray removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

-(NSArray<CLLocation *> *)currentLocationsOnMap{
    return [NSArray arrayWithArray:self.allLocationsArray];
}

-(void)setupWithLocations:(NSArray<CLLocation *> *)locations{
    for (CLLocation *location in locations) {
        [self addNewLocation:location];
    }
}

-(void)commonInit {
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    self.mapView.autoresizingMask = 0xFFFFFF;
    self.mapView.delegate = self;
    
    [self addSubview:self.mapView];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    
    [self.mapView addGestureRecognizer:longPressRecognizer];
    self.allLocationsArray = [[NSMutableArray alloc] init];
}


-(void)longPressEvent:(UILongPressGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locationCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    
    [self addNewLocation:location];
}


-(void)addNewLocation:(CLLocation*)location {
    [self.allLocationsArray addObject:location];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = [NSString stringWithFormat:@"%ld", self.allLocationsArray.count];
    
    annotation.coordinate = location.coordinate;
    
    [self.mapView addAnnotation:annotation];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    NSString *pinReusableIdentifier = @"pinViewIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReusableIdentifier];
    }
    
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    return pinView;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

@end
