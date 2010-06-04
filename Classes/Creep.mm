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

- (id)initWithPoint:(CGPoint)startPoint {
    if ((self = [super init])) {
        waypoints = [[NSMutableArray alloc] init];
        nextGoalId = 0;
        
        gameField = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
        pathFinder = gameField.pathFinder;
        
        PathFindNode * currentgoal = static_cast<PathFindNode*>([gameField.goalpoints objectForKey:[NSNumber numberWithInt:nextGoalId]]);
        goal = CGPointMake(currentgoal->nodeX, currentgoal->nodeY);
        start = CGPointMake(startPoint.x, startPoint.y);
        
        waypoints = [pathFinder findPath:start.x :start.y :goal.x :goal.y];
        
        printf("waypoint count = %d\n", [waypoints count]);
        
        direction = -1;
        
        nextWaypointId = [waypoints count] -1;
        nextWaypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
        nextWaypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
        
        nextWaypointX *= cellSize;
        nextWaypointY *= cellSize;
        
        speed = 2;
        
        hpbar = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:COLORTEXTURE_PURPLE]];
        [hpbar setTextureRect:CGRectMake(hpbar.position.x, hpbar.position.y, creepSize, 5)];
        [gameField addChild:[hpbar retain]];
//        hpbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, creepSize, 3)];
//        hpbar.backgroundColor = [UIColor greenColor];
//        [self addSubview:hpbar];
    }
    return self;
}

- (CGPoint) getNextWaypoint
{
    int waypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
    int waypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
    waypointX *= cellSize;
    waypointY *= cellSize;
    
    return ccp(waypointX, waypointY);
}

- (void) shoot:(int)damage
{
    health = health - damage;
    if (health <= 0)
        [mySpawner Died:self];
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

- (void) Update
{
    [self UpdateHPBar];
    
    float X = self.creepSprite.position.x;
    float Y = self.creepSprite.position.y;
    //printf("creepx = %d creepy = %d wx = %d wy = %d\n", X, Y, nextWaypointX, nextWaypointY);
    
    if (X == nextWaypointX && Y == nextWaypointY)
    {
        if (nextWaypointId >= 0)
        {
            nextWaypointId -= 1;
            nextWaypointX = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeX;
            nextWaypointY = static_cast<PathFindNode*>([waypoints objectAtIndex:nextWaypointId])->nodeY;
            
            //printf("new waypoint #%d = %d,%d\n",nextWaypointId, nextWaypointX, nextWaypointY);
            
            nextWaypointX *= cellSize;
            nextWaypointY *= cellSize;
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