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
#import "UILocationIndexPinAnnotationView.h"
#import "CommonViewUtils.h"
#import "Common.h"


@implementation UILocationPinningViewCallbacks
@end

@interface UILocationPinningView() <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray<CLLocation*> *allLocationsArray;
@property (strong, nonatomic) NSMutableArray<MKPointAnnotation*> *allAnnotations;
@property (strong, nonatomic) UILocationPinningViewCallbacks *callbacks;
@end

@implementation UILocationPinningView

-(void)deleteLocationAt:(NSInteger)index {
    MKPointAnnotation *annotation = self.allAnnotations[index];
    [self.allAnnotations removeObject:annotation];
    [self.mapView removeAnnotation:annotation];

    [self refreshMapView];
}

-(void)modifyLocationAt:(NSInteger)index toLatitude:(double)latitude andLongitude:(double)longitude {
    MKPointAnnotation *annotation = self.allAnnotations[index];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    NSLog(@"should modify location at index: %ld", index);
    [self refreshMapView];
}

-(void)clearAll {
    [self.allLocationsArray removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

-(NSArray<CLLocation *> *)currentLocationsOnMap{
    return [NSArray arrayWithArray:self.allLocationsArray];
}

-(void)setupWithLocations:(NSArray<CLLocation *> *)locations callbacks:(UILocationPinningViewCallbacks *)callbacks{
    for (CLLocation *location in locations) {
        [self addNewLocation:location];
    }
    self.callbacks = callbacks;
}

-(void)commonInit {
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    self.mapView.delegate = self;
    
    [CommonViewUtils fullyConstrainView:self.mapView inHostView:self];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    
    [self.mapView addGestureRecognizer:longPressRecognizer];
    self.allLocationsArray = [[NSMutableArray alloc] init];
    self.allAnnotations = [[NSMutableArray alloc] init];
}


-(void)longPressEvent:(UILongPressGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locationCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    
    [self addNewLocation:location];
    SAFECALL(self.callbacks.onNewLocationAdded, location)
}


-(void)addNewLocation:(CLLocation*)location {
    [self.allLocationsArray addObject:location];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = [NSString stringWithFormat:@"%ld", (unsigned long)self.allLocationsArray.count];
    
    annotation.coordinate = location.coordinate;
    
    [self.mapView addAnnotation:annotation];
    [self.allAnnotations addObject:annotation];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    NSString *pinReusableIdentifier = @"pinViewIdentifier";
    UILocationIndexPinAnnotationView *pinView = (UILocationIndexPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    if (!pinView) {
        pinView = [[UILocationIndexPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReusableIdentifier];
    }
    
    NSInteger index = [self.allAnnotations indexOfObject:annotation] + 1;
    pinView.locationIndexPinView.index = index;
    pinView.frame = CGRectMake(0, 0, 50, 66);
    [pinView setNeedsLayout];
    [pinView layoutIfNeeded];
    pinView.draggable = YES;
    
    return pinView;
}

-(void)refreshMapView {
    CLLocationCoordinate2D center = self.mapView.centerCoordinate;
    CLLocationCoordinate2D fakeCenter = center;
    fakeCenter.latitude = 0;
    
    self.mapView.centerCoordinate = fakeCenter;
    self.mapView.centerCoordinate = center;
    
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D droppedAt = view.annotation.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
        NSInteger indexOfAnnotation = [self.allAnnotations indexOfObject:view.annotation];
        [self.allLocationsArray replaceObjectAtIndex:indexOfAnnotation withObject:location];
        SAFECALL(self.callbacks.onModifyLocationAtIndex, location, indexOfAnnotation)
    }
    
    UILocationIndexPinAnnotationView *pinView = view;
    if (newState == MKAnnotationViewDragStateStarting) {
        view.dragState = MKAnnotationViewDragStateDragging;
        pinView.inDragging = YES;
    }
    else if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling) {
        view.dragState = MKAnnotationViewDragStateNone;
        pinView.inDragging = NO;
    }
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
