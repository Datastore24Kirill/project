//
//  MapController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 27.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MapController.h"
#import "MapModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "OutletTable.h"
#import "HexColors.h"
#import "SingleTone.h"
#import "HookahDetailsController.h"
#import "ChooseTableController.h"


@interface MapController ()<GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewWithMap;
@property (assign, nonatomic) BOOL firstLocationUpdate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) NSString * orgID;
@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSString * orgImage;


@property (strong, nonatomic) GMSMapView *mapView;
@property (assign, nonatomic) BOOL isAnimation;



@end

@implementation MapController

- (void) loadView {
    [super loadView];
    
    self.detailView.layer.cornerRadius = 7.f;
    [self.detailView.layer setShadowColor: [UIColor blackColor].CGColor];
    [self.detailView.layer setShadowOpacity:0.99];
    [self.detailView.layer setShadowRadius:7.0];
    [self.detailView.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    
    self.buttonBook.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"].CGColor;
    self.buttonBook.layer.borderWidth = 1.f;
    self.buttonBook.layer.cornerRadius = 3.f;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    //Кнопка фильтров
    self.filterButton.alpha = 0.f;
    if([[SingleTone sharedManager] isMapFilter] || [[SingleTone sharedManager] isOpenFilter] || [[SingleTone sharedManager] isFavoriteFilter]){
        self.filterButton.alpha = 1.f;
        
        NSMutableString * resultString = [[NSMutableString alloc] initWithString: @"Фильтр: "];
        if([[SingleTone sharedManager] isFavoriteFilter]){
            [resultString appendString: @"Избранные"];
            
            if([[SingleTone sharedManager] isMapFilter] || [[SingleTone sharedManager] isOpenFilter]){
             [resultString appendString: @", "];
            }
        }
        
        if([[SingleTone sharedManager] isMapFilter]){
            [resultString appendString: @"Рядом"];
            if([[SingleTone sharedManager] isOpenFilter]){
                [resultString appendString: @", "];
            }
        }
        
        if([[SingleTone sharedManager] isOpenFilter]){
            [resultString appendString: @"Открыто "];
        }
        [self.filterButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]];
        [self.filterButton setTitle:resultString forState:UIControlStateNormal];
    }
        
    //
    
    [self.mapView clear];
    
    MapModel * mapModel = [[MapModel alloc] init];
    NSArray * outletTableArray = [mapModel loadOutletsToMap:self.outletIDToLoad];
    
    for(int i = 0; i< outletTableArray.count; i++){
        NSDictionary * outletTableInfo = [outletTableArray objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[outletTableInfo objectForKey:@"lat"] doubleValue], [[outletTableInfo objectForKey:@"lon"] doubleValue]);
        marker.icon = [UIImage imageNamed:@"markerImage"];
        marker.userData = [NSDictionary dictionaryWithObjectsAndKeys:
                           [outletTableInfo objectForKey:@"name"],@"name",
                           [outletTableInfo objectForKey:@"rating"],@"rating",
                           [outletTableInfo objectForKey:@"orgID"],@"orgID",
                           [outletTableInfo objectForKey:@"orgImage"],@"orgImage",
                           [outletTableInfo objectForKey:@"scheduleOutlet"],@"scheduleOutlet",
                           [outletTableInfo objectForKey:@"outletID"],@"outletID",nil];
        
        marker.map = self.mapView;
        
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:55.755826
                                                            longitude:37.6173
                                                                 zoom:7];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];

    self.mapView.delegate =self;
    
    self.isAnimation = NO;

    [self.viewWithMap addSubview:self.mapView];
    //MyLocation
    

    [self.mapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:(NSKeyValueObservingOptionNew)
                      context:NULL];
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    
    MapModel * mapModel = [[MapModel alloc] init];
    
   
    
    
    NSArray * outletTableArray = [mapModel loadOutletsToMap:self.outletIDToLoad];
    
    for(int i = 0; i< outletTableArray.count; i++){
       NSDictionary * outletTableInfo = [outletTableArray objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init]; 
        marker.position = CLLocationCoordinate2DMake([[outletTableInfo objectForKey:@"lat"] doubleValue], [[outletTableInfo objectForKey:@"lon"] doubleValue]);
        marker.icon = [UIImage imageNamed:@"markerImage"];
        marker.userData = [NSDictionary dictionaryWithObjectsAndKeys:
                           [outletTableInfo objectForKey:@"name"],@"name",
                           [outletTableInfo objectForKey:@"rating"],@"rating",
                           [outletTableInfo objectForKey:@"orgID"],@"orgID",
                           [outletTableInfo objectForKey:@"orgImage"],@"orgImage",
                           [outletTableInfo objectForKey:@"scheduleOutlet"],@"scheduleOutlet",
                           [outletTableInfo objectForKey:@"outletID"],@"outletID",nil];
        
        
        marker.map = self.mapView;
        
        
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = CGRectMake(0, 0, self.viewWithMap.frame.size.width, self.viewWithMap.frame.size.height);
}

-(void)dealloc{

        [self.mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
}


#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rectViewDetail = self.detailView.frame;
            rectViewDetail.origin.y += rectViewDetail.size.height;
            self.detailView.frame = rectViewDetail;
        }];
        self.isAnimation = NO;
    }
    
   
    
}

- (BOOL) mapView:		(GMSMapView *) 	mapView
    didTapMarker:		(GMSMarker *) 	marker{
    
    self.orgID = [marker.userData objectForKey:@"orgID"];
    self.orgImage = [marker.userData objectForKey:@"orgImage"];
    self.outletID = [marker.userData objectForKey:@"outletID"];
    
    if (!self.isAnimation) {
        
        self.titleNameLabel.text = [marker.userData objectForKey:@"name"];
        self.timeLabel.text = [marker.userData objectForKey:@"scheduleOutlet"];
        
        for (int j = 0; j < 5; j++) {
            UIImageView * imageStarView = [self.rateStarsImages objectAtIndex:j];
            if ([[marker.userData objectForKey: @"rating"] intValue] > j) {
                imageStarView.image = [UIImage imageNamed:@"rateStarImageOn"];
            } else {
                imageStarView.image = [UIImage imageNamed:@"rateStarImageOff"];
            }
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rectViewDetail = self.detailView.frame;
            rectViewDetail.origin.y -= rectViewDetail.size.height;
            self.detailView.frame = rectViewDetail;
        }];
        
        self.isAnimation = YES;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleNameLabel.text = [marker.userData objectForKey:@"name"];
            self.timeLabel.text = [marker.userData objectForKey:@"scheduleOutlet"];
            
           
                self.buttonBook.userInteractionEnabled = YES;
                self.buttonBook.alpha = 1.f;
        

            
            
            for (int j = 0; j < 5; j++) {
                UIImageView * imageStarView = [self.rateStarsImages objectAtIndex:j];
                if ([[marker.userData objectForKey: @"rating"] intValue] > j) {
                    imageStarView.image = [UIImage imageNamed:@"rateStarImageOn"];
                } else {
                    imageStarView.image = [UIImage imageNamed:@"rateStarImageOff"];
                }
            }

        }];
    };
    

    
    
    return YES;
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if(self.outletIDToLoad.length !=0){
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.latToLoad doubleValue]
                                                                longitude:[self.lonToLoad doubleValue]
                                                                     zoom:12.0];
        [self.mapView animateToCameraPosition:camera];
    }else{
        if (!self.firstLocationUpdate) {
            // If the first location update has not yet been recieved, then jump to that
            // location.
            self.firstLocationUpdate = YES;
            CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
            
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                                            longitude:location.coordinate.longitude
                                                                                 zoom:12.0];
                    [self.mapView animateToCameraPosition:camera];
        }
    }
    
    
}

#pragma mark - Actions

- (IBAction)actionButtonDetails:(id)sender {
    NSLog(@"actionButtonDetails");
    self.hidesBottomBarWhenPushed = YES;
    HookahDetailsController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HookahDetailsController"];
    detail.titleName = self.titleNameLabel.text;
    detail.orgID = self.orgID;
    detail.outletID = self.outletID;
    detail.imageStingURL = self.orgImage;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)actionButtonBook:(id)sender {
    self.hidesBottomBarWhenPushed = NO;
    ChooseTableController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableController"];
    detail.outletID = self.outletID;
    detail.isMap = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    NSLog(@"actionButtonBook");
}
@end
