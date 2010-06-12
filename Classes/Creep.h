//
//  Creep.h
//  tdtest
//
//  Created by Eric Lanz on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#define CreepStatus_Walking 0
#define CreepStatus_Goal 1

#define CreepDirection_Up 0
#define CreepDirection_Down 1
#define CreepDirection_Left 2
#define CreepDirection_Right 3

@class GameFieldScene;
@class PathFinding;
@class CreepSpawner;
@class BaseEffect;
@class BaseTower;

@interface Creep : NSObject {

    CGPoint start;
    CGPoint goal;
    
    unsigned int nextGoalId;
    int nextWaypointId;
    int nextWaypointX;
    int nextWaypointY;
    
    int status;
    
    float maxHealth;
    float health;
    float speed;
    float baseSpeed;
    
    NSLock * creepLock;
    
    int direction;

    NSMutableArray * effects;
    
    GameFieldScene *gameField;
    PathFinding *pathFinder;
    CreepSpawner *mySpawner;
    
    CCSprite * creepSprite;
    
    NSMutableArray * waypoints;
    
    CCSprite * hpbar;
}

@property (nonatomic, retain) CCSprite * creepSprite;
@property (nonatomic, retain) CCSprite * hpbar;
@property (nonatomic) int status;
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint goal;
@property (nonatomic) float speed;
@property (nonatomic) float baseSpeed;
@property (nonatomic) float health;
@property (nonatomic) float maxHealth;
@property (nonatomic, retain) CreepSpawner *mySpawner;

- (void) addEffect:(int)effectType sourceTower:(BaseTower*)sourceTower;
- (void) removeEffect:(BaseEffect*)effect;
- (void) shoot:(int)damage;
- (id)initWithPoint:(CGPoint)startPoint;
- (void) Update: (double) elapsed;
- (void) SetDirection:(int)newDirection;
- (CGPoint) getNextWaypoint;

@end
