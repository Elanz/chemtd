//
//  TouchHandler.m
//  ChemTD
//
//  Created by Eric Lanz on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchHandler.h"
#import "BaseTower.h"
#import "PathFinding.h"
#import "Colors.h"
#import "TowerMixer.h"
#import "TowerManager.h"

@implementation TouchHandler

@synthesize originalVelocity;
@synthesize scrollVelocity;
@synthesize scrollVector;

-(id) initWithGameField:(GameFieldScene *)theGameField
{
    if( (self=[super init] )) 
    {
        gameField = theGameField;
        
        towerAttachedToTouch = NO;
    }
    return self;
}

- (void)HandleccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchCount += [touches count];
    
    printf("touchCount = %d\n", touchCount);
    
    if (firstTouch == nil)
    {
        firstTouch = [[[touches allObjects] objectAtIndex:0] retain]; 
        firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch locationInView:nil]];
    }
    
    if (touchCount > 1)
    {
        [self HandleMultitouchBegin:touches withEvent:event];
    }
    else 
    {
        [self HandleSingletouchBegin:touches withEvent:event];
    }
}

- (void)HandleccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch locationInView:nil]];
    previousFirstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch previousLocationInView:nil]];
    if (secondTouch)
    {
        secondTouchLocation = [[CCDirector sharedDirector] convertToGL:[secondTouch locationInView:nil]];
    }    
    
    if (touchCount > 1)
    {
        [self HandleMultitouchMove:touches withEvent:event];
    }
    else 
    {
        [self HandleSingletouchMove:touches withEvent:event];
    }    
}

- (void)HandleMultitouchBegin:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (gameField.currentGamePhase == GamePhase_Build)
    {
        [gameField showRangeIndicatorForTower:nil];
        [gameField removeChild:gameField.currentTower.towerSprite cleanup:NO];
        gameField.currentTower = nil;
    }
    if (touchCount == 2)
    {
        if (secondTouch == nil && [[touches allObjects] count] > 1)
        {
            secondTouch = [[[touches allObjects] objectAtIndex:1] retain];
            secondTouchLocation = [[CCDirector sharedDirector] convertToGL:[secondTouch locationInView:nil]];
        }
        else {
            secondTouch = [[[touches allObjects] objectAtIndex:0] retain];
            secondTouchLocation = [[CCDirector sharedDirector] convertToGL:[secondTouch locationInView:nil]];
        }
        
        currentDistanceBetweenTouches = [gameField distanceBetweenPointsA:firstTouchLocation B:secondTouchLocation];
        previousDistanceBetweenTouches = currentDistanceBetweenTouches;
    }    
}

- (void)HandleSingletouchBegin:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouchLocation = [self processTouchPoint:firstTouchLocation];
    int cellX = firstTouchLocation.x/cellSize;
    int cellY = firstTouchLocation.y/cellSize;
    

//    cellY = [self adjustTouchLocationWithY:cellY];
    
    switch (gameField.currentGamePhase) {
        case GamePhase_Build:
            gameField.currentTower = [gameField GenerateRandomTowerAtPosition:firstTouchLocation];
            
            towerAttachedToTouch = YES;
            
            [gameField showRangeIndicatorForTower:gameField.currentTower];
            
            if ([gameField check1x1SpaceStatus:cellX :cellY :TILE_OPEN])
            {
                [gameField.currentTower setColor:Color_White];
            } else {
                [gameField.currentTower setColor:Color_Red];
            }
            break;
        default:
            break;
    }  
}

- (void)HandleMultitouchMove:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentDistanceBetweenTouches = [gameField distanceBetweenPointsA:firstTouchLocation B:secondTouchLocation];
    distanceBetweenTouchesChangeOverTime += currentDistanceBetweenTouches - previousDistanceBetweenTouches;
    previousDistanceBetweenTouches = currentDistanceBetweenTouches;
    
    if (currentDistanceBetweenTouches < Swipe_Threshold)
    {
        // swipe
        
        [gameField updateScrollOffsetWithDeltaX:firstTouchLocation.x - previousFirstTouchLocation.x DeltaY:firstTouchLocation.y - previousFirstTouchLocation.y];
    }
    else 
    {
        // grow/shrink
        if (distanceBetweenTouchesChangeOverTime > Pinch_Threshold && gameField.scale < max_zoom)
        {
            distanceBetweenTouchesChangeOverTime = 0.0;
            gameField.zoomed = YES;
            [gameField updateScaleAnimated:FieldZoom_Delay newScale:max_zoom];   
        }
        else if (distanceBetweenTouchesChangeOverTime < Pinch_Threshold && gameField.scale > min_zoom)
        {
            distanceBetweenTouchesChangeOverTime = 0.0;
            gameField.zoomed = NO;
            [gameField updateScaleAnimated:FieldZoom_Delay newScale:min_zoom];
        }
    }
}

- (void)HandleSingletouchMove:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouchLocation = [self processTouchPoint:firstTouchLocation];
    int cellX = firstTouchLocation.x/cellSize;
    int cellY = firstTouchLocation.y/cellSize;

        printf("x = %d, y = %d\n", cellX, cellY);
    
//    cellY = [self adjustTouchLocationWithY:cellY];
    
    switch (gameField.currentGamePhase) {
        case GamePhase_Build:
            if (gameField.currentTower)
            {
                [gameField.currentTower setPositionWithX:(cellX*cellSize+cellSize/2) Y:([self adjustTouchLocationWithY:cellY]*cellSize+cellSize/2)];
                
                gameField.rangeIndicatorSprite.position = [gameField.currentTower getTowerPosition];
                
                if ([gameField check1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_OPEN])
                {
                    [gameField.currentTower setColor:Color_White];
                } else {
                    [gameField.currentTower setColor:Color_Red];
                }
            }
            break;
        default:
            break;
    }
}

- (void)HandleTouchEndBuild:(NSSet*)touches
{
    int cellX = firstTouchLocation.x/cellSize;
    int cellY = firstTouchLocation.y/cellSize;
    
    gameField.rangeIndicatorSprite.visible = false;
    if ([gameField check1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_OPEN])
    {
        if (gameField.currentTower)
        {
            if ([gameField.pendingTowers count] == 0) [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_PENDINGTOWER1];
            if ([gameField.pendingTowers count] == 1) [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_PENDINGTOWER2];
            if ([gameField.pendingTowers count] == 2) [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_PENDINGTOWER3];
            if ([gameField.pendingTowers count] == 3) [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_PENDINGTOWER4];
            if ([gameField.pendingTowers count] == 4) [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_PENDINGTOWER5];
            
            [gameField.pendingTowers addObject:gameField.currentTower];
            if ([gameField.pendingTowers count] == towersPerRound)
                [gameField StartPickPhase];
            [gameField.currentTower release];
            gameField.currentTower = nil;
        }
        gameField.towerForThisRound = 0;
    } else {
        [gameField.currentTower hide];
    }    
}

- (void)HandleTouchEndPick:(NSSet*)touches
{
    
    float bestDistance = 10000.0;
    gameField.currentTower = nil;
    for (BaseTower * tower in gameField.pendingTowers)
    {
        float thisDistance = [gameField distanceBetweenPointsA:[tower getTowerPosition] B:ccp(firstTouchLocation.x, firstTouchLocation.y)];
        if (thisDistance < RadiusSelect_Threshold && thisDistance < bestDistance)
        {
            bestDistance = thisDistance;
            gameField.currentTower = tower;
        }
    }
    for (BaseTower * tower in gameField.towers)
    {
        if (tower.towerType != TowerType_Base)
        {
            float thisDistance = [gameField distanceBetweenPointsA:[tower getTowerPosition] B:ccp(firstTouchLocation.x, firstTouchLocation.y)];
            if (thisDistance < RadiusSelect_Threshold && thisDistance < bestDistance)
            {
                bestDistance = thisDistance;
                gameField.currentTower = tower;
            }
        }
    }
    if (gameField.currentTower)
    {
        skipPick = [gameField.towerMixer pickTower:gameField.currentTower];
        [gameField showRangeIndicatorForTower:gameField.currentTower];
    }
}

- (void)HandleTouchEndPlace:(NSSet*)touches
{
    
    float bestDistance = 10000.0;
    BaseTower * found = nil;
    for (BaseTower * tower in gameField.pendingTowers)
    {
        float thisDistance = [gameField distanceBetweenPointsA:[tower getTowerPosition] B:ccp(firstTouchLocation.x, firstTouchLocation.y)];
        if (thisDistance < RadiusSelect_Threshold && thisDistance < bestDistance)
        {
            bestDistance = thisDistance;
            found = tower;
        }
    }
    if (found)
    {
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        BaseTower * temp = [delegate constructTowerWithType:gameField.currentTower.towerType gameField:gameField addToField:YES];
        [temp setTowerPower:gameField.currentTower.towerPower];
        [temp setPositionWithX:[found getTowerPosition].x Y:[found getTowerPosition].y];
        [found removeFromLayer];
        [gameField.pendingTowers removeObject:found];            
        [gameField.pendingTowers addObject:temp];
        [temp show];
        gameField.currentTower = temp;
        [temp towerPicked];
        [gameField StartCreepsPhase];
    }    
}

- (void)HandleccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch locationInView:nil]];
    previousFirstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch previousLocationInView:nil]];
    if (secondTouch)
    {
        secondTouchLocation = [[CCDirector sharedDirector] convertToGL:[secondTouch locationInView:nil]];
    }    
    
    firstTouchLocation = [self processTouchPoint:firstTouchLocation];
    
    skipPick = NO;
    
    //int towerid;
    switch (gameField.currentGamePhase) {
        case GamePhase_Build:
            [self HandleTouchEndBuild:touches];
            break;
        case GamePhase_Pick:
            [self HandleTouchEndPick:touches];
            break;
        case GamePhase_Place:
            [self HandleTouchEndPlace:touches];
            break;
        default:
            break;
    }
    
    if (!skipPick)
    {
        BOOL gotone = NO;
        float bestDistance = 10000.0;
        BaseTower * choice = nil;
        for (BaseTower * tower in gameField.towers)
        {
            float thisDistance = [gameField distanceBetweenPointsA:[tower getTowerPosition] B:ccp(firstTouchLocation.x, firstTouchLocation.y)];
            if (thisDistance < RadiusSelect_Threshold && thisDistance < bestDistance)
            {
                bestDistance = thisDistance;
                choice = tower;
                gotone = YES;
            }
        }
        for (BaseTower * tower in gameField.pendingTowers)
        {
            float thisDistance = [gameField distanceBetweenPointsA:[tower getTowerPosition] B:ccp(firstTouchLocation.x, firstTouchLocation.y)];
            if (thisDistance < RadiusSelect_Threshold && thisDistance < bestDistance)
            {
                bestDistance = thisDistance;
                choice = tower;
                gotone = YES;
            }
        }
        
        if (gotone == NO)
        {
            [gameField.towerManager chooseTower:nil];
            gameField.rangeIndicatorSprite.visible = NO;
        }
        else
        {
            [gameField.towerManager chooseTower:choice];
            [gameField showRangeIndicatorForTower:choice];
            gotone = YES;
        }      
    }
    
    touchCount -= [touches count];
    
    if (touchCount == 0)
    {
        firstTouch = nil;   
        firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch locationInView:nil]];
        previousFirstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch previousLocationInView:nil]];
        
        scrollVelocity = [gameField distanceBetweenPointsA:firstTouchLocation B:previousFirstTouchLocation];
        originalVelocity = scrollVelocity;
        scrollVector = ccp(firstTouchLocation.x - previousFirstTouchLocation.x, firstTouchLocation.y - previousFirstTouchLocation.y);
        
        printf("velocity = %f, x = %f, d = %f\n", scrollVelocity, scrollVector.x, scrollVector.y);
    }
    if (touchCount > 0)
        secondTouch = nil;
    
    if (touchCount == 0)
    {
        previousDistanceBetweenTouches = 0.0;
        currentDistanceBetweenTouches = 0.0;
        distanceBetweenTouchesChangeOverTime = 0.0;
    }
}

- (int)adjustTouchLocationWithY:(int)originalY
{
    int adjustment = 1;
    
    originalY += adjustment;
    
    if (originalY > mapHeight-2)
        originalY = mapHeight-2;
    if (originalY < 0)
        originalY = 0;
    
    return originalY;
}

- (CGPoint)processTouchPoint:(CGPoint)original
{
//    CGPoint	location;
//    
//    float percentX = original.x / device_width;
//    float percentY = original.y / device_height;
//    
//    float newwidth = 0.0;
//    float newheight = 0.0;
//    
//    if (!gameField.zoomed)
//    {
//        newwidth = field_width;
//        newheight = field_height;
//    }
//    if (gameField.zoomed)
//    {
//        newwidth = device_width;
//        newheight = device_height;
//    }    
//    
//    location = ccp(newwidth * percentX, newheight * percentY);
//    location.x -= gameField.field_offsetX;
//    location.y -= gameField.field_offsetY;
//    
//    return location;
    
    return [gameField convertToNodeSpace:original];
}

@end
