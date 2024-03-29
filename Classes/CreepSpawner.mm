//
//  CreepSpawner.m
//  tdtest
//
//  Created by Eric Lanz on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreepSpawner.h"
#import "Creep.h"
#import "GameFieldScene.h"
#import "PathFinding.h"
#import "LevelManager.h"
#import "TextureLibrary.h"

@implementation CreepSpawner

@synthesize creeps;

- (id) initWithPos:(CGPoint)position :(UIColor*)color
{
    self = [super init];
    
    gameField = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
    pathFinder = gameField.pathFinder;
    
    location = CGPointMake(position.x, position.y);
    
    CGPoint start = CGPointMake(location.x, location.y);
    
    for (unsigned int i = 0; i< [gameField.goalpoints count]; i++)
    {
        PathFindNode * currentgoal = static_cast<PathFindNode*>([gameField.goalpoints objectForKey:[NSNumber numberWithInt:i]]);
        CGPoint goal = CGPointMake(currentgoal->nodeX, currentgoal->nodeY);
    
        [pathFinder findPath:start.x :start.y :goal.x :goal.y];
        start = CGPointMake(goal.x, goal.y);
    }
    
    creepColor = color;
    
    moveTimer = 0.0;
    moveInterval = 0.0333;
    spawnTimer = [gameField.levelManager GetCurrentLevel].spawnTime;
    spawnInterval = [gameField.levelManager GetCurrentLevel].spawnTime;
    spawnCount = 0;
    numberToSpawn = [gameField.levelManager GetCurrentLevel].creepCount;
    creepCount = 0;
    
    creeps = [[NSMutableArray alloc] init];

    return self;
}

- (void) CheckForRoundOver
{
    if (spawnCount == numberToSpawn && creepCount == 0)
    {
        [gameField midLevelUpdate:UITEXTURE_LEVELCLEARBACKGROUND];
        [gameField.levelManager incrementLevel];
        [gameField StartBuildPhase];
    }
}

- (void) Died:(Creep*)creep
{
    
    [gameField removeCreep:creep];
    [gameField removeChild:creep.hpbar cleanup:NO];
    if ([creeps containsObject:creep])
    {
        [creeps removeObject:creep];
        //[creep release];
        creepCount --;
        gameField.killedThisRound ++;
        //creep = nil;
        [gameField awardPoints:creep.maxHealth/10];
        [self CheckForRoundOver];
    }
}

- (void) Goal:(Creep*)creep
{
    
    [gameField removeCreep:creep];
    [gameField removeChild:creep.hpbar cleanup:NO];
    if ([creeps containsObject:creep])
    {
        [creeps removeObject:creep];

        //[creep release];
        creepCount --;
        //creep = nil;
        [gameField decrementLives];
        [self CheckForRoundOver];
    }
}

- (void) spawnCreep
{
    Creep * creep = [[Creep alloc] initWithPoint:location];
    creep.creepSprite = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:[gameField.levelManager GetCurrentLevel].textureId]];
    creep.creepSprite.position = ccp(location.x*cellSize+halfCellSize, location.y*cellSize+halfCellSize);
    creep.hpbar.position = ccp(location.x*cellSize+halfCellSize, (location.y*cellSize+halfCellSize) + (creepSize/2)+5);
    int variance = [gameField.levelManager GetCurrentLevel].variance;
    if (variance)
    {
        creep.varianceX = -variance + arc4random() % variance;
        creep.varianceY = -variance + arc4random() % variance;
    }
    creep.mySpawner = self;
    creep.speed = [gameField.levelManager GetCurrentLevel].speed;
    creep.baseSpeed = creep.speed;
    creep.maxHealth = [gameField.levelManager GetCurrentLevel].baseHealth;
    creep.health = creep.maxHealth;
    [creeps addObject:creep];
    [gameField addCreep:creep];
    spawnCount ++;
    creepCount ++;
}

- (void) tick:(double)elapsed
{
    spawnTimer += elapsed;
    moveTimer += elapsed;
    if (spawnTimer > spawnInterval)
    {
        if (spawnCount < numberToSpawn)
        {
            [self spawnCreep];
        }
        spawnTimer = 0.0;
    }
    if (moveTimer > moveInterval)
    {
        NSMutableArray * creepCopy = [NSMutableArray arrayWithArray:creeps];
        for (Creep * creep in creepCopy)
        {
            [creep Update:elapsed];
        }
        moveTimer = 0.0;
    }
}

@end
