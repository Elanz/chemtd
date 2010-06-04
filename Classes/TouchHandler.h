//
//  TouchHandler.h
//  ChemTD
//
//  Created by Eric Lanz on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

#define Swipe_Threshold 120.0
#define Pinch_Threshold 100.0
#define RadiusSelect_Threshold 100.0
#define FieldZoom_Delay 0.3

@interface TouchHandler : NSObject {

    GameFieldScene * gameField;
    
    int touchCount;
    
    UITouch * firstTouch;
    CGPoint firstTouchLocation;
    CGPoint previousFirstTouchLocation;
    UITouch * secondTouch;
    CGPoint secondTouchLocation;
    float previousDistanceBetweenTouches;
    float currentDistanceBetweenTouches;
    float distanceBetweenTouchesChangeOverTime;
    BOOL towerAttachedToTouch;
    BOOL skipPick;
    
    float originalVelocity;
    float scrollVelocity;
    CGPoint scrollVector;
}

@property (nonatomic) float originalVelocity;
@property (nonatomic) float scrollVelocity;
@property (nonatomic) CGPoint scrollVector;

-(id) initWithGameField:(GameFieldScene *)theGameField;

- (void)HandleccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)HandleMultitouchBegin:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)HandleSingletouchBegin:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)HandleccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)HandleMultitouchMove:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)HandleSingletouchMove:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)HandleccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)HandleTouchEndBuild:(int)cellX cellY:(int)cellY;
- (void)HandleTouchEndPick:(int)cellX cellY:(int)cellY originalY:(int)originalY;
- (void)HandleTouchEndPlace:(int)cellX cellY:(int)cellY originalY:(int)originalY;

- (CGPoint)processTouchPoint:(CGPoint)original;
- (int)adjustTouchLocationWithY:(int)originalY;
@end
