//
//  Creep.m
//  tdtest
//
//  Created by Eric Lanz on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Creep.h"
#import "GameFieldScene.h"
#import "PathFinding.h"
#import "CreepSpawner.h"
#import "TextureLibrary.h"
#import "BaseEffect.h"
#import "BaseTower.h"
#import "Effects.h"

@implementation Creep

@synthesize creepSprite;
@synthesize hpbar;
@synthesize start;
@synthesize goal;
@synthesize status;
@synthesize mySpawner;
@synthesize speed;
@synthesize health;
@synthesize maxHealth;
@synthesize baseSpeed;
@synthesize varianceX;
@synthesize varianceY;

- (id)initWithPoint:(CGPoint)startPoint {
    if ((self = [super init])) {
        waypoints = [[NSMutableArray alloc] init];
        effects = [[NSMutableArray alloc] init];
        nextGoalId = 0;
        
        creepLock = [[NSLock alloc] init];
        
        gameField = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
        pathFinder = gameField.pathFinder;
        
        PathFindNode * currentgoal = static_cast<PathFindNode*>([gameField.goalpoints objectForKey:[NSNumber numberWithInt:nextGoalId]]);
        goal = CGPointMake(currentgoal->nodeX, currentgoal->nodeY);
        start = CGPointMake(startPoint.x, startPoint.y);
        
        waypoints = [pathFinder findPath:start.x :start.y :goal.x :goal.y];
        
        //printf("waypoint count = %d\n", [waypoints count]);
        
        direction = -1;
        
        nextWaypointId = [waypoints count] -1;
        nextWaypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
        nextWaypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
        
        nextWaypointX *= cellSize;
        nextWaypointY *= cellSize;
        nextWaypointX += halfCellSize;
        nextWaypointY += halfCellSize;
        
        varianceX = 0;
        varianceY = 0;
        
        speed = 2;
        baseSpeed = speed;
        
        hpbar = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:COLORTEXTURE_PURPLE]];
        [hpbar setTextureRect:CGRectMake(hpbar.position.x, hpbar.position.y, creepSize, 5)];
        [gameField addChild:[hpbar retain] z:4];
//        hpbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, creepSize, 3)];
//        hpbar.backgroundColor = [UIColor greenColor];
//        [self addSubview:hpbar];
    }
    return self;
}

- (void) addEffect:(int)effectType sourceTower:(BaseTower*)sourceTower
{
    BaseEffect * found = nil;
    for (BaseEffect * e in effects)
    {
        if (e.effectType == effectType)
        {
            found = e;
        }
    }
    if (found)
    {
        [found refreshEffect];
    }
    else
    {
        BaseEffect * effect = nil;
        switch (effectType) {
            case TowerEffectType_Burn:
                effect = [[BurnEffect alloc] initWithSource:sourceTower target:self];
                break;
            case TowerEffectType_SlowPoison:
                effect = [[SlowEffect alloc] initWithSource:sourceTower target:self];
                effect = [[PoisonEffect alloc] initWithSource:sourceTower target:self];
                break;
            case TowerEffectType_Rubber:
                effect = [[RubberEffect alloc] initWithSource:sourceTower target:self];
                break;
            case TowerEffectType_Poison:
                effect = [[PoisonEffect alloc] initWithSource:sourceTower target:self];
                break;
            case TowerEffectType_Sleep:
                effect = [[SleepEffect alloc] initWithSource:sourceTower target:self];
                break;
            case TowerEffectType_Nitrous:
                effect = [[NitrousEffect alloc] initWithSource:sourceTower target:self];
                break;
            case TowerEffectType_Ethanol:
                effect = [[EthanolEffect alloc] initWithSource:sourceTower target:self];
                break;
            default:
                break;
        }
        [effects addObject:effect];
        [effect startEffect];
    }
}

- (void) removeEffect:(BaseEffect*)effect
{
    [effect finishEffect];
    [effects removeObject:effect];
}

- (CGPoint) getNextWaypoint
{
    int waypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
    int waypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
    waypointX *= cellSize;
    waypointY *= cellSize;
    waypointX += halfCellSize;
    waypointY += halfCellSize;
    
    return ccp(waypointX, waypointY);
}

- (void) shoot:(int)damage
{
    [creepLock lock];
    if (health < 0)
    {
        [creepLock unlock];
        return;
    }
    health = health - damage;
    [gameField updateDPS:damage];
    if (health <= 0)
        [mySpawner Died:self];
    [creepLock unlock];
}

- (void) SetDirection:(int)newDirection
{
    if (direction != newDirection)
    {    
        int degreesToRotate = 0;
        switch (newDirection) {
            case CreepDirection_Right:
                degreesToRotate = 0;
                break;
            case CreepDirection_Down:
                degreesToRotate = -90;
                break;
            case CreepDirection_Left:
                degreesToRotate = 180;               
                break;
            case CreepDirection_Up:
                degreesToRotate = 90;
                break;
            default:
                break;
        }
        
        id actionTo = [CCRotateTo actionWithDuration: 0.15 angle:degreesToRotate];
        [creepSprite runAction:actionTo];
        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.15];     /* Sub. duration here */
//        self.transform = CGAffineTransformMakeRotation(degreesToRadian(degreesToRotate));
//        [UIView commitAnimations];
    }
    direction = newDirection;
}

- (void) UpdateHPBar
{
    float X = self.creepSprite.position.x;
    float Y = self.creepSprite.position.y;
    hpbar.position = ccp(X, Y + (creepSize/2)+5);
    float percentage = health / maxHealth;
    hpbar.scaleX = percentage;
}

- (void) Update: (double) elapsed
{
    [self UpdateHPBar];
    
    for (BaseEffect * effect in effects)
    {
        [effect updateEffect:elapsed];
    }
    
    float X = self.creepSprite.position.x;
    float Y = self.creepSprite.position.y;
    //printf("creepx = %d creepy = %d wx = %d wy = %d\n", X, Y, nextWaypointX, nextWaypointY);
    
    if (X == nextWaypointX && Y == nextWaypointY)
    {
        if (nextWaypointId > 0)
        {
            nextWaypointId -= 1;
            nextWaypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
            nextWaypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
            
            //printf("new waypoint #%d = %d,%d\n",nextWaypointId, nextWaypointX, nextWaypointY);
            
            nextWaypointX *= cellSize;
            nextWaypointY *= cellSize;
            nextWaypointX += halfCellSize;
            nextWaypointY += halfCellSize;
        } else {
            if (nextGoalId < [gameField.goalpoints count] - 1)
            {
                nextGoalId ++;
                PathFindNode * currentgoal = static_cast<PathFindNode*>([gameField.goalpoints objectForKey:[NSNumber numberWithInt:nextGoalId]]);
                start = CGPointMake(goal.x, goal.y);
                goal = CGPointMake(currentgoal->nodeX, currentgoal->nodeY);
                
                waypoints = [pathFinder findPath:start.x :start.y :goal.x :goal.y];
                
                nextWaypointId = [waypoints count] -1;
                nextWaypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
                nextWaypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
                
                nextWaypointX *= cellSize;
                nextWaypointY *= cellSize;
                nextWaypointX += halfCellSize;
                nextWaypointY += halfCellSize;
                
                //printf("new goal #%d = %lf,%lf\n",nextGoalId, goal.x, goal.y);
            } else {
                status = CreepStatus_Goal;
                [mySpawner Goal:self];
                return;
            }
        }
    }
    
    if (X > nextWaypointX)
    {
        //printf("creepx > nextWaypointX\n");
        [self SetDirection:CreepDirection_Left];
        status = CreepStatus_Walking;
        if (X - speed < nextWaypointX)
            creepSprite.position = ccp(nextWaypointX, creepSprite.position.y);
        else 
            creepSprite.position = ccp(creepSprite.position.x - speed, creepSprite.position.y);
    }
    else if (X < nextWaypointX)
    {
        //printf("creepx < nextWaypointX\n");
        [self SetDirection:CreepDirection_Right];
        status = CreepStatus_Walking;
        if (X + speed > nextWaypointX)
            creepSprite.position = ccp(nextWaypointX, creepSprite.position.y);
        else 
            creepSprite.position = ccp(creepSprite.position.x + speed, creepSprite.position.y);
    }
    else if (Y > nextWaypointY)
    {
        //printf("creepy > nextWaypointY\n");
        [self SetDirection:CreepDirection_Up];
        status = CreepStatus_Walking;
        if (Y - speed < nextWaypointY)
            creepSprite.position = ccp(creepSprite.position.x, nextWaypointY);
        else 
            creepSprite.position = ccp(creepSprite.position.x, creepSprite.position.y - speed);
    }
    else if (Y < nextWaypointY)
    {
        //printf("creepy < nextWaypointY\n");
        [self SetDirection:CreepDirection_Down];
        status = CreepStatus_Walking;
        if (Y + speed > nextWaypointY)
            creepSprite.position = ccp(creepSprite.position.x, nextWaypointY);
        else 
            creepSprite.position = ccp(creepSprite.position.x, creepSprite.position.y + speed);
    }
    

    
}

- (void)dealloc {
    [super dealloc];
}


@end
