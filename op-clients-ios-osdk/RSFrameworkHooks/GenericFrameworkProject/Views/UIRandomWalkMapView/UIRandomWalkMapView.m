//
//  UIRandomWalkMapView.m
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIRandomWalkMapView.h"

@interface UIRandomWalkMapView() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UIButton *setCenterButton;

@property (weak, nonatomic) IBOutlet UIView *toolsView;

@property (strong, nonatomic) MKPolyline *currentDrawnPolyline;

@property (strong, nonatomic) MKCircle *currentDrawnCircle;
@property (strong, nonatomic) UIRandomWalkMapViewCallbacks *callbacks;
@property (strong, nonatomic) UIRandomWalkMapViewModel *model;


@end

@implementation UIRandomWalkMapView

-(void)commonInit {
    [super commonInit];
    self.mapView.delegate = self;
}



-(void)setupWithModel:(UIRandomWalkMapViewModel *)model callbacks:(UIRandomWalkMapViewCallbacks *)callbacks {
    
}

-(void)drawNewLocations:(NSArray<CLLocation *> *)locations{
    if (self.currentDrawnPolyline) {
        [self.mapView removeOverlay:self.currentDrawnPolyline];
    }
    
    if (!locations.count) {
        return;
    }
    
    CLLocationCoordinate2D* locationCoordinates = malloc(sizeof(CLLocationCoordinate2D) * locations.count);
    
    for (int i = 0; i<locations.count; i++) {
        locationCoordinates[i] = locations[i].coordinate;
    }
    
    self.currentDrawnPolyline = [MKGeodesicPolyline polylineWithCoordinates:locationCoordinates count:locations.count];
    
    free(locationCoordinates);
    
    [self.mapView addOverlay:self.currentDrawnPolyline];
}


-(void)updateCircleToCenter:(CLLocationCoordinate2D)center radiusInKM:(double)radius {
    
    if (self.currentDrawnCircle) {
        [self.mapView removeOverlay:self.currentDrawnCircle];
    }
    
    self.currentDrawnCircle = [MKCircle circleWithCenterCoordinate:center radius:radius * 1000];
    
    [self.mapView addOverlay:self.currentDrawnCircle];
}



-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircle *circle = overlay;
        return [self createCircleRendererFor:circle];
    }
    
    MKGeodesicPolyline *polyline = overlay;
    return [self createPolylineRendererFor:polyline];
    
}

-(MKPolylineRenderer*)createPolylineRendererFor:(MKPolyline*)polyline {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    
    renderer.lineWidth = 3.0;
    renderer.alpha = 0.6;
    renderer.strokeColor = [UIColor blueColor];
    
    return renderer;
}

-(MKCircleRenderer*)createCircleRendererFor:(MKCircle*)circle {
    
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:circle];
    
    renderer.fillColor = [UIColor greenColor];
    renderer.alpha = 0.3;
    return renderer;
}

#pragma mark - IBActions

- (IBAction)sliderDidChangeValue:(UISlider *)sender {
}

- (IBAction)didPressSetCenter:(id)sender {
}


@end
