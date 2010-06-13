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
        zoomLevel = min_zoom;
        towerAttachedToTouch = NO;
    }
    return self;
}

- (void) ticker:(ccTime)elapsed
{
    if (scrollVelocity > .5)
    {
        //printf("moving\n");
        float percentToDecay = scrollVelocity * 0.05;
        scrollVelocity -= percentToDecay;
        float percentToMove = scrollVelocity / originalVelocity;
        [gameField updateScrollOffsetWithDeltaX:(scrollVector.x*percentToMove) DeltaY:(scrollVector.y*percentToMove)];
    }
}

- (void)HandleccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [gameField.DPSDisplay setString:[NSString stringWithFormat:@"%@ %d", String_DPSLabel, 0]];
    
    touchCount += [touches count];
    scrollVelocity = 0.0;
    //printf("touchCount = %d\n", touchCount);
    
    if (touchCount == 0 || firstTouch == nil)
    {
        firstTouch = [[[touches allObjects] objectAtIndex:0] retain]; 
        firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[firstTouch locationInView:nil]];
    }
    
    if (touchCount > 1)
    {
        if (gameField.currentGamePhase == GamePhase_Build)
        {
            [gameField showRangeIndicatorForTower:nil];
            [gameField removeChild:gameField.currentTower.towerSprite cleanup:NO];
            gameField.currentTower = nil;
        }
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
    if ([touches count] < 2)
        return;
    
    
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
        
        firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[(UITouch*)[[touches allObjects] objectAtIndex:0] locationInView:nil]];
        secondTouchLocation = [[CCDirector sharedDirector] convertToGL:[(UITouch*)[[touches allObjects] objectAtIndex:1] locationInView:nil]];
        firstTouchLocation = [self processTouchPoint:firstTouchLocation];
        secondTouchLocation = [self processTouchPoint:secondTouchLocation];
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
            gameField.currentTower = [gameField GenerateRandomTowerAtPosition:ccp((cellX*cellSize+cellSize/2), ([self adjustTouchLocationWithY:cellY]*cellSize+cellSize/2))];
            
            [gameField.currentTower setPositionWithX:(cellX*cellSize+cellSize/2) Y:([self adjustTouchLocationWithY:cellY]*cellSize+cellSize/2)];
            
            towerAttachedToTouch = YES;
            
            [gameField showRangeIndicatorForTower:gameField.currentTower];
            
            if ([gameField check1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_OPEN])
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
    if ([touches count] < 2)
        return;
    
    firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[(UITouch*)[[touches allObjects] objectAtIndex:0] locationInView:nil]];
    previousFirstTouchLocation = [[CCDirector sharedDirector] convertToGL:[(UITouch*)[[touches allObjects] objectAtIndex:0] previousLocationInView:nil]];
    secondTouchLocation = [[CCDirector sharedDirector] convertToGL:[(UITouch*)[[touches allObjects] objectAtIndex:1] locationInView:nil]];
    firstTouchLocation = [self processTouchPoint:firstTouchLocation];
    secondTouchLocation = [self processTouchPoint:secondTouchLocation];
    previousFirstTouchLocation = [self processTouchPoint:previousFirstTouchLocation];
    currentDistanceBetweenTouches = [gameField distanceBetweenPointsA:firstTouchLocation B:secondTouchLocation];
    distanceBetweenTouchesChangeOverTime = previousDistanceBetweenTouches - currentDistanceBetweenTouches;
    previousDistanceBetweenTouches = currentDistanceBetweenTouches;
    
    if (currentDistanceBetweenTouches < Swipe_Threshold)
    {
        // swipe
        
        [gameField updateScrollOffsetWithDeltaX:firstTouchLocation.x - previousFirstTouchLocation.x DeltaY:firstTouchLocation.y - previousFirstTouchLocation.y];
    }
    else 
    {
        // grow/shrink
        if (distanceBetweenTouchesChangeOverTime > Pinch_Threshold && zoomLevel < max_zoom)
        {
            //distanceBetweenTouchesChangeOverTime = 0.0;
            //gameField.zoomed = YES;
            zoomLevel += 0.02;
            [gameField updateScaleAnimated:FieldZoom_Delay newScale:zoomLevel];   
        }
        else if (distanceBetweenTouchesChangeOverTime< -Pinch_Threshold && zoomLevel > min_zoom)
        {
            //distanceBetweenTouchesChangeOverTime = 0.0;
            //gameField.zoomed = NO;
            zoomLevel -= 0.02;
            [gameField updateScaleAnimated:FieldZoom_Delay newScale:zoomLevel];
        }
    }
}

- (void)HandleSingletouchMove:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouchLocation = [self processTouchPoint:firstTouchLocation];
    int cellX = firstTouchLocation.x/cellSize;
    int cellY = firstTouchLocation.y/cellSize;

        //printf("x = %d, y = %d\n", cellX, cellY);
    
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

- (BOOL)testForBlock:(int)cellX cellY:(int)cellY
{
    BOOL passed = YES;
    
    if (!gameField.pathFinder)
    {
        gameField.pathFinder = [[PathFinding alloc] init];
    }
    
    [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_FINALTOWER];
    
    CGPoint start = gameField.startPosition;
    
    [gameField.pathFinder resetPathCache];
    
    for (unsigned int i = 0; i< [gameField.goalpoints count]; i++)
    {
        PathFindNode * currentgoal = static_cast<PathFindNode*>([gameField.goalpoints objectForKey:[NSNumber numberWithInt:i]]);
        CGPoint goal = CGPointMake(currentgoal->nodeX, currentgoal->nodeY);
        
        NSMutableArray * test = [gameField.pathFinder findPath:start.x :start.y :goal.x :goal.y];
        if ([test count] == 0)
        {
            passed = NO;
            break;
        }
        start = CGPointMake(goal.x, goal.y);
    }
    [gameField set1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_OPEN];
    return passed;
}

- (void)HandleTouchEndBuild:(NSSet*)touches
{
    int cellX = firstTouchLocation.x/cellSize;
    int cellY = firstTouchLocation.y/cellSize;
    
    gameField.rangeIndicatorSprite.visible = false;
    if ([gameField check1x1SpaceStatus:cellX :[self adjustTouchLocationWithY:cellY] :TILE_OPEN])
    {
        if (gameField.currentTower && [self testForBlock:cellX cellY:cellY])
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
            gameField.towerForThisRound = 0;
        }
        else
        {
            [gameField showRangeIndicatorForTower:nil];
            [gameField removeChild:gameField.currentTower.towerSprite cleanup:NO];
            gameField.currentTower = nil;
            [gameField.DPSDisplay setString:String_DontBlock];
        }
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
        [temp setPower:gameField.currentTower.towerPower];
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
    previousFirstTouchLocation = [self processTouchPoint:previousFirstTouchLocation];
    
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
    
    if (touchCount > 1)
    {
        float temp = [gameField distanceBetweenPointsA:firstTouchLocation B:previousFirstTouchLocation];
        if (temp > 0.0)
        {
            scrollVelocity = [gameField distanceBetweenPointsA:firstTouchLocation B:previousFirstTouchLocation];
            originalVelocity = scrollVelocity;
            scrollVector = ccp(firstTouchLocation.x - previousFirstTouchLocation.x, firstTouchLocation.y - previousFirstTouchLocation.y);
            printf("velocity = %f vector = %f, %f \n", scrollVelocity, scrollVector.x, scrollVector.y);
        }
    }
    
    touchCount -= [touches count];
    
    if (touchCount == 0)
    {
        firstTouch = nil;   

        //printf("velocity = %f, x = %f, d = %f\n", scrollVelocity, scrollVector.x, scrollVector.y);
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
    
    if (originalY > mapHeight-1)
        originalY = mapHeight-1;
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
