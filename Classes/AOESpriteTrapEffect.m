//
//  TrapEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AOESpriteTrapEffect.h"
#import "BaseTower.h"
#import "Creep.h"
#import "CreepSpawner.h"
#import "CombatManager.h"

@implementation AOESpriteTrapEffect

- (id) initWithSourceField:(BaseTower*)sourceTower target:(GameFieldScene*)targetField position:(CGPoint)targetPosition
{
    if ((self = [super initWithSourceField:sourceTower target:targetField position:targetPosition]))
    {
        dotTimer = 0.5;
        dotElapsed = 0.0;
        maxDuration = 5.0;
        range = 100;
        duration = maxDuration;
    }
    return self;
}

- (void) startEffect
{
    trapSprite = [CCSprite spriteWithTexture:[field.textureLibrary GetTextureWithKey:source.trapTextureKey]];
    trapSprite.position = position;
    [field addChild:trapSprite z:2];
}

- (void) finishEffect
{
    [field removeChild:trapSprite cleanup:YES];
}

- (void) updateEffect: (double) elapsed
{
    dotElapsed += elapsed;
    if (dotElapsed > dotTimer)
    {
        for (Creep * foundCreep in field.mainSpawner.creeps)
        {
            float thisdistance = [field distanceBetweenPointsA:position B:foundCreep.creepSprite.position];
            if (thisdistance < range)
            {
                int damage = source.dotMin + arc4random() % source.dotMax;
                [foundCreep shoot:damage];
                CCPointParticleSystem * bubbleSystem = [field.combatManager getParticleSystemForKey:source.hitParticleKey];
                bubbleSystem.position = ccp(creepSize/2, -(creepSize/2));
                bubbleSystem.autoRemoveOnFinish = YES;
                bubbleSystem.duration = dotTimer;
                [foundCreep.hpbar addChild:bubbleSystem];
            }
        }
        
        dotElapsed = 0.0;
    }
    duration -= elapsed;
    if (duration < 0)
    {
        [field removeEffect:self];
    }
}

@end
