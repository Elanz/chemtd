//
//  BaseEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseEffect.h"
#import "BaseTower.h"
#import "Creep.h"
#import "GameFieldScene.h"

@implementation BaseEffect

@synthesize effectType;

- (id) initWithTargetTower:(BaseTower*)targetTower
{
    if ((self = [super init])) 
    {
        targetType = TowerTarget;
        tower = targetTower;
        creep = nil;
        field = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
    }
    return self;
}

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super init])) {
        source = sourceTower;
        targetType = CreepTarget;
        creep = targetCreep;
        field = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];;
        tower = nil;
    }
    return self;
}

- (id) initWithSourceField:(BaseTower*)sourceTower target:(GameFieldScene*)targetField position:(CGPoint)targetPosition
{
    if ((self = [super init])) {
        source = sourceTower;
        targetType = CreepTarget;
        position = targetPosition;
        creep = nil;
        field = targetField;
        tower = nil;
    }
    return self;
}

- (void) refreshEffect
{
    duration = maxDuration;
}

- (void) startEffect
{
    
}

- (void) finishEffect
{
    
}

- (void) updateEffect: (double) elapsed
{
    
}

@end
