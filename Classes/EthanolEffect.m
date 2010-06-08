//
//  SleepEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EthanolEffect.h"
#import "BaseTower.h"
#import "Creep.h"
#import "CombatManager.h"

@implementation EthanolEffect

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super initWithSource:sourceTower target:targetCreep])) {
        maxDuration = 4.0;
        duration = maxDuration;
        effectType = TowerEffectType_Ethanol;
    }
    return self;
}

- (void) startEffect
{
    id action2 = [CCRotateBy actionWithDuration:0.5 angle:90];
    id action2Back = [action2 reverse];
    repeat = [CCRepeatForever actionWithAction:[CCSequence actions: action2, action2Back, nil]];
    [creep.creepSprite runAction:repeat];
    
    creep.speed = creep.speed * 0.4;
    NitrousSystem = [CCPointParticleSystem particleWithFile:Effect_NitrousHit];
    NitrousSystem.position = ccp(creepSize/2, creepSize/2);
    [creep.creepSprite addChild:NitrousSystem z:1];
}

- (void) finishEffect
{
    [creep.creepSprite stopAction:repeat];
    creep.speed = creep.baseSpeed;
    [NitrousSystem stopSystem];
    NitrousSystem.autoRemoveOnFinish = YES;
    NitrousSystem.duration = 0.3;
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
