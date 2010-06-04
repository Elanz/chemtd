//
//  CreepSpawner.h
//  tdtest
//
//  Created by Eric Lanz on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SpawnerStatus_ON 1
#define SpawnerStatus_OFF 0

@class Creep;
@class PathFinding;
@class GameFieldScene;

@interface CreepSpawner : NSObject {
    
    int spawnerStatus;
    UIColor * creepColor;
    
    CGPoint location;
    
    NSMutableArray * creeps;
    
    double spawnTimer;
    double moveTimer;
    
    float spawnInterval;
    float moveInterval;
    int spawnCount;
    int creepCount;
    int numberToSpawn;
    
    GameFieldScene *gameField;
    PathFinding *pathFinder;
}

@property (nonatomic, retain) NSMutableArray * creeps;

- (id) initWithPos:(CGPoint)position :(UIColor*)color;
- (void) tick:(double)elapsed;
- (void) Goal:(Creep*)creep;
- (void) Died:(Creep*)creep;
- (void) CheckForRoundOver;

@end
