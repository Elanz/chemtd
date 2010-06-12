//
//  SleepEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NitrousEffect.h"
#import "BaseTower.h"
#import "Creep.h"
#import "CombatManager.h"

@implementation NitrousEffect

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super initWithSource:sourceTower target:targetCreep])) {
        maxDuration = 3.0;
        duration = maxDuration;
        effectType = TowerEffectType_Nitrous;
    }
    return self;
}

- (void) startEffect
{
    id action1 = [CCRotateBy actionWithDuration:0.3 angle:35];
    id action2 = [CCRotateBy actionWithDuration:0.3 angle:-70];
    repeat = [CCRepeatForever actionWithAction:[CCSequence actions: action1, action2, [[CCSequence actions: action1, action2, nil] reverse], nil]];
    [creep.creepSprite runAction:repeat];
    
    creep.speed = creep.speed * 0.6;
    NitrousSystem = [field.combatManager getParticleSystemForKey:iEffect_NitrousHit];
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
