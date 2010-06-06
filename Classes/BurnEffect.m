//
//  BurnEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BurnEffect.h"
#import "BaseTower.h"
#import "Creep.h"

@implementation BurnEffect

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super initWithSource:sourceTower target:targetCreep])) {
        dotTimer = 0.5;
        dotElapsed = 0.0;
        maxDuration = 5.0;
        duration = maxDuration;
        effectType = TowerEffectType_Burn;
    }
    return self;
}

- (void) startEffect
{
    id action2 = [CCTintBy actionWithDuration:1 red:-255 green:-255 blue:-255];
    id action2Back = [action2 reverse];
    repeat = [CCRepeatForever actionWithAction:[CCSequence actions: action2, action2Back, nil]];
    
    [target.creepSprite runAction:repeat];
}

- (void) finishEffect
{
    [target.creepSprite stopAction:repeat];
}

- (void) updateEffect: (double) elapsed
{
    dotElapsed += elapsed;
    duration -= elapsed;
    if (dotElapsed > dotTimer)
    {
        int damage = source.dotMin + arc4random() % source.dotMax;
        [target shoot:damage];
        dotElapsed = 0.0;
    }
    if (duration < 0)
    {
        [target removeEffect:self];
    }
}

@end
