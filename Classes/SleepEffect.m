//
//  SleepEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SleepEffect.h"
#import "BaseTower.h"
#import "Creep.h"
#import "CombatManager.h"

@implementation SleepEffect

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super initWithSource:sourceTower target:targetCreep])) {
        maxDuration = 1.0;
        duration = maxDuration;
        effectType = TowerEffectType_Burn;
    }
    return self;
}

- (void) startEffect
{
    creep.speed = 0.0;
    sleepSystem = [CCPointParticleSystem particleWithFile:Effect_Sleep];
    sleepSystem.position = ccp(creepSize/2, -(creepSize/2));
    [creep.hpbar addChild:sleepSystem z:1];
}

- (void) finishEffect
{
    creep.speed = creep.baseSpeed;
    [sleepSystem stopSystem];
    sleepSystem.autoRemoveOnFinish = YES;
    sleepSystem.duration = 0.3;
}

- (void) updateEffect: (double) elapsed
{
    duration -= elapsed;
    if (duration < 0)
    {
        [creep removeEffect:self];
    }
}

@end
