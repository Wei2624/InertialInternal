//
//  E20EatonUserTrackingViewController.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/1/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20EatonUserTrackingViewController.h"

@interface E20EatonUserTrackingViewController ()

@end

@implementation E20EatonUserTrackingViewController
@synthesize eatonMapView;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)startMotionTracking
{
    self.motionManager.deviceMotionUpdateInterval = 1/1000.0f;
    [self.motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            if(_iterator1 < [eatonMapView.user1History count]){
                                NSString* theLine = [eatonMapView.user1History objectAtIndex:_iterator1];
                                _iterator1+=3;
                                NSArray    *lineValues  = [theLine componentsSeparatedByString:@","];
                                eatonMapView.user1 = [[NSMutableArray alloc] init];
                                for(int i =0;i<[lineValues count];i+=3){
                                    double x = [[lineValues objectAtIndex:i] doubleValue];
                                    double y = [[lineValues objectAtIndex:i+1] doubleValue];
                                    double weight = [[lineValues objectAtIndex:i+2] doubleValue];
                                    E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:x positionY:y withOrientationAngle:90 currentArea:[NSString stringWithFormat:@"area0"]];
                                    newUser.weight = weight;
                                    [eatonMapView.user1 addObject:newUser];
                                }
                            }
                            if(_iterator1>=2000){
                                if(_iterator2 < [eatonMapView.user2History count]){
                                    NSString* theLine = [eatonMapView.user2History objectAtIndex:_iterator2];
                                    _iterator2+=5;
                                    NSArray    *lineValues  = [theLine componentsSeparatedByString:@","];
                                    eatonMapView.user2 = [[NSMutableArray alloc] init];
                                    for(int i =0;i<[lineValues count];i+=3){
                                        double x = [[lineValues objectAtIndex:i] doubleValue];
                                        double y = [[lineValues objectAtIndex:i+1] doubleValue];
                                        double weight = [[lineValues objectAtIndex:i+2] doubleValue];
                                        E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:x positionY:y withOrientationAngle:90 currentArea:[NSString stringWithFormat:@"area0"]];
                                        newUser.weight = weight;
                                        [eatonMapView.user2 addObject:newUser];
                                    }
                                }
                            }
                            if(_iterator1>=2800){
                                if(_iterator3 < [eatonMapView.user3History count]){
                                    NSString* theLine = [eatonMapView.user3History objectAtIndex:_iterator3];
                                    _iterator3+=6;
                                    NSArray    *lineValues  = [theLine componentsSeparatedByString:@","];
                                    eatonMapView.user3 = [[NSMutableArray alloc] init];
                                    for(int i =0;i<[lineValues count];i+=3){
                                        double x = [[lineValues objectAtIndex:i] doubleValue];
                                        double y = [[lineValues objectAtIndex:i+1] doubleValue];
                                        double weight = [[lineValues objectAtIndex:i+2] doubleValue];
                                        E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:x positionY:y withOrientationAngle:90 currentArea:[NSString stringWithFormat:@"area0"]];
                                        newUser.weight = weight;
                                        [eatonMapView.user3 addObject:newUser];
                                    }
                                }
                            }
                            if(1){
                                if(_iterator4 < [eatonMapView.user4History count]){
                                    NSString* theLine = [eatonMapView.user4History objectAtIndex:_iterator4];
                                    _iterator4+=4;
                                    NSArray    *lineValues  = [theLine componentsSeparatedByString:@","];
                                    eatonMapView.user4 = [[NSMutableArray alloc] init];
                                    for(int i =0;i<[lineValues count];i+=3){
                                        double x = [[lineValues objectAtIndex:i] doubleValue];
                                        double y = [[lineValues objectAtIndex:i+1] doubleValue];
                                        double weight = [[lineValues objectAtIndex:i+2] doubleValue];
                                        E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:x positionY:y withOrientationAngle:90 currentArea:[NSString stringWithFormat:@"area0"]];
                                        newUser.weight = weight;
                                        [eatonMapView.user4 addObject:newUser];
                                    }
                                }
                            }



                            [eatonMapView setNeedsDisplay];
                            
                            
                            
                        }
                        );
     }
     ];
    
}


- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:(CGSizeMake(800, 1300))];
	scrollView.backgroundColor = [UIColor blackColor];
	scrollView.delegate = self;
    
    scrollView.minimumZoomScale = 0.5;
	scrollView.maximumZoomScale = 2.0;
	[scrollView setZoomScale:1.0];
    self.view = scrollView;


    [self loadData];
    _iterator1 = 0;
    _iterator2 = 0;
    _iterator3 = 0;
    _iterator4 = 0;
    _iterator5 = 0;
    eatonMapView.canDraw = YES;
    [eatonMapView setNeedsDisplay];
    [self loadRecordedUserPosition];
    [self startMotionTracking];
    
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    eatonMapView.frame = [self centeredFrameForScrollView:self.scrollView andUIView:eatonMapView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return eatonMapView;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}



-(void) loadRecordedUserPosition{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath= nil;
    filePath = [documentsDirectoryPath  stringByAppendingPathComponent:@"user1.csv"];
    
    
    NSError *error;
    NSString *stringFromFileAtPath = [[NSString alloc]
                                      initWithContentsOfFile:filePath
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
    
    eatonMapView.user1History  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];
    

    filePath = [documentsDirectoryPath  stringByAppendingPathComponent:@"user2.csv"];
    stringFromFileAtPath = [[NSString alloc]
                                      initWithContentsOfFile:filePath
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
    eatonMapView.user2History  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];

    filePath = [documentsDirectoryPath  stringByAppendingPathComponent:@"user3.csv"];
    stringFromFileAtPath = [[NSString alloc]
                            initWithContentsOfFile:filePath
                            encoding:NSUTF8StringEncoding
                            error:&error];
    eatonMapView.user3History  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];

    filePath = [documentsDirectoryPath  stringByAppendingPathComponent:@"user4.csv"];
    stringFromFileAtPath = [[NSString alloc]
                            initWithContentsOfFile:filePath
                            encoding:NSUTF8StringEncoding
                            error:&error];
    eatonMapView.user4History  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];

    
    

    
}

-(void) loadData{
    eatonMapView.eatonAreas = [[NSMutableDictionary alloc]init];
    NSMutableArray * newMapLine;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath= nil;
    filePath = [documentsDirectoryPath  stringByAppendingPathComponent:@"mainCorridor.csv"];
    
    
    NSError *error;
    NSString *stringFromFileAtPath = [[NSString alloc]
                                      initWithContentsOfFile:filePath
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
    
    NSArray  *lines  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];
    NSEnumerator*theEnum = [lines objectEnumerator];
    NSString *theLine;
    newMapLine = [[NSMutableArray alloc] init];
    while (nil != (theLine = [theEnum nextObject]) )
    {
        if (![theLine isEqualToString:@""] && ![theLine hasPrefix:@"#"])    // ignore empty lines and lines that start with #
        {
            NSArray    *values  = [theLine componentsSeparatedByString:@","];
            NSString *value = [values objectAtIndex:1];
            double x1 = [value doubleValue];
            value = [values objectAtIndex:2];
            double y1 = [value doubleValue];
            value = [values objectAtIndex:3];
            double x2 = [value doubleValue];
            value = [values objectAtIndex:4];
            double y2 = [value doubleValue];
            value = [values objectAtIndex:0];
            int crossable = [value intValue];
            bool cross;
            if (crossable) {
                cross = YES;
            }
            else{
                cross = NO;
            }
            E20MapLine* newLine = [[E20MapLine alloc] initWithCartesianX1:x1 Y1:y1 X2:x2 Y2:y2 boolCrossable: cross];
            [newMapLine addObject:newLine];
        }
    }
    [eatonMapView.eatonAreas setValue:newMapLine forKey:[NSString stringWithFormat:@"area%d.csv",0]];
    
    for(int i=1;i<18;i++){
        filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"store%d.csv",i]];
        
        
        NSError *error;
        NSString *stringFromFileAtPath = [[NSString alloc]
                                          initWithContentsOfFile:filePath
                                          encoding:NSUTF8StringEncoding
                                          error:&error];
        
        NSArray  *lines  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];
        NSEnumerator*theEnum = [lines objectEnumerator];
        NSString *theLine;
        
        newMapLine = [[NSMutableArray alloc] init];
        while (nil != (theLine = [theEnum nextObject]) )
        {
            if (![theLine isEqualToString:@""] && ![theLine hasPrefix:@"#"])    // ignore empty lines and lines that start with #
            {
                NSArray    *values  = [theLine componentsSeparatedByString:@","];
                NSString *value = [values objectAtIndex:1];
                double x1 = [value doubleValue];
                value = [values objectAtIndex:2];
                double y1 = [value doubleValue];
                value = [values objectAtIndex:3];
                double x2 = [value doubleValue];
                value = [values objectAtIndex:4];
                double y2 = [value doubleValue];
                value = [values objectAtIndex:0];
                int crossable = [value intValue];
                bool cross;
                if (crossable) {
                    cross = YES;
                }
                else{
                    cross = NO;
                }
                E20MapLine* newLine = [[E20MapLine alloc] initWithCartesianX1:x1 Y1:y1 X2:x2 Y2:y2 boolCrossable: cross];
                [newMapLine addObject:newLine];
                
            }
            
            [eatonMapView.eatonAreas setValue:newMapLine forKey:[NSString stringWithFormat:@"area%d.csv",i]];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
