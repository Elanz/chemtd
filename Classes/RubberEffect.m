//
//  SleepEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RubberEffect.h"
#import "BaseTower.h"
#import "Creep.h"
#import "CombatManager.h"

@implementation RubberEffect

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super initWithSource:sourceTower target:targetCreep])) {
        maxDuration = 4.0;
        duration = maxDuration;
        effectType = TowerEffectType_Rubber;
    }
    return self;
}

- (void) startEffect
{
    id action2 = [CCScaleBy actionWithDuration:0.3 scale:1.5];
    id action2Back = [action2 reverse];
    repeat = [CCRepeatForever actionWithAction:[CCSequence actions: action2, action2Back, nil]];
    [creep.creepSprite runAction:repeat];
    
    creep.speed = creep.speed * 0.5;
}

- (void) finishEffect
{
    creep.creepSprite.scale = 1.0;
    [creep.creepSprite stopAction:repeat];
    creep.speed = creep.baseSpeed;
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
